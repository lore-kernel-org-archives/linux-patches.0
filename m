Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87511B96D;
	Thu, 18 Jan 2024 10:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575148; cv=none; b=BdpHkPtrMTcsng386H7PzlV8RvofMKiIFOpHlc9VxMDLKMKJxFjhXlKJnpyzOtjfC65mgbbUWeKrM1tiVQUugUpC1TSNiRhSC7CUfqZER0g/yFsI4X0JQxue7Pc3prJYxub2HO5T7oFakzyXCEialMahCzOFa2+xcnw8Gw6RIYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575148; c=relaxed/simple;
	bh=h+mosCBvILtQO31OXb+jO2GkJIds9orwEcoUnBR2Aqo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=h90rYxl6mrDQVLDTAs7zTC/2Q4lN/Wb8HY7hBp9NthRUUGF+zjqr/KNLSefPV0GrW+AZaOXb9x+DpGaNJGkcElieh78vEDmce2jRe/Z6+/s4BwIbXV7gHE14q2e0icHu1UdmeZIj4UEQnAHfLY5Sg4yJl6k5NpAvK6C7/n/dkyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCQ4+6V6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCQ4+6V6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9B3C433F1;
	Thu, 18 Jan 2024 10:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575148;
	bh=h+mosCBvILtQO31OXb+jO2GkJIds9orwEcoUnBR2Aqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCQ4+6V6FYk67e/+lP9DvDnwOZhYgN5AxMG+DVLOTbs/jK7Mki4WPjnvuwlmTTHPE
	 NYYHhjVKltbBql7r8XPAcF18wjlluvdrU0sRPjb8ylMox02TwtVLc/heEb5wJkz5pO
	 ErJYWe5sNfbPBaFpoNDi+492Ep5WNZ8sGIi89B9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/150] kunit: Reset suite counter right before running tests
Date: Thu, 18 Jan 2024 11:47:06 +0100
Message-ID: <20240118104320.237821150@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 2e3c94aed51eabbe9c1c0ee515371ea5441c2fa7 ]

Today we reset the suite counter as part of the suite cleanup,
called from the module exit callback, but it might not work that
well as one can try to collect results without unloading a previous
test (either unintentionally or due to dependencies).

For easy reproduction try to load the kunit-test.ko and then
collect and parse results from the kunit-example-test.ko load.
Parser will complain about mismatch of expected test number:

[ ] KTAP version 1
[ ] 1..1
[ ]     # example: initializing suite
[ ]     KTAP version 1
[ ]     # Subtest: example
..
[ ] # example: pass:5 fail:0 skip:4 total:9
[ ] # Totals: pass:6 fail:0 skip:6 total:12
[ ] ok 7 example

[ ] [ERROR] Test: example: Expected test number 1 but found 7
[ ] ===================== [PASSED] example =====================
[ ] ============================================================
[ ] Testing complete. Ran 12 tests: passed: 6, skipped: 6, errors: 1

Since we are now printing suite test plan on every module load,
right before running suite tests, we should make sure that suite
counter will also start from 1. Easiest solution seems to be move
counter reset to the __kunit_test_suites_init() function.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index e451cfe6143e..7452d1a2acd9 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -740,6 +740,8 @@ int __kunit_test_suites_init(struct kunit_suite * const * const suites, int num_
 		return 0;
 	}
 
+	kunit_suite_counter = 1;
+
 	static_branch_inc(&kunit_running);
 
 	for (i = 0; i < num_suites; i++) {
@@ -766,8 +768,6 @@ void __kunit_test_suites_exit(struct kunit_suite **suites, int num_suites)
 
 	for (i = 0; i < num_suites; i++)
 		kunit_exit_suite(suites[i]);
-
-	kunit_suite_counter = 1;
 }
 EXPORT_SYMBOL_GPL(__kunit_test_suites_exit);
 
-- 
2.43.0



