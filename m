Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60D31B952;
	Sat,  3 Feb 2024 04:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933736; cv=none; b=km/w9UyHUrxxkS4gIAKfiSQi38sK1m0nZ88yipr2IiNBH5jPf41J0wrFIL/5OO0sMPUgsLbMl/9uCdpjVYpnCEX6b7Yh53k6yCbNrBoN7Zb1FkE6nFbNmTp/pbdlbouKNsTGU7UMQ6B+qc+6yGUiV/BbV6tweeVKKB3w1x9qB/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933736; c=relaxed/simple;
	bh=kVDdbehRkJjjTFXdot1nn45gMF5hzbEGS9BTTcMCjVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bW0D9sKDjoygEHc7Q1T3G1F32qw24AqQQOBAe3KXWwA5i705Pvzv3KT1c52IQbuIlz1SOj1XRy3naw0JbMWVeMuAcgHDqRfrwXNgP2cIdk2U78731O48nBoKfuSHVZ3h23uiK6hSeB1GHNvFEbjQAmFBDQkEXJ9Ei0GbivSBlzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE6jJF7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE6jJF7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFF5C433A6;
	Sat,  3 Feb 2024 04:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933736;
	bh=kVDdbehRkJjjTFXdot1nn45gMF5hzbEGS9BTTcMCjVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE6jJF7/Hucfl/JwvcUkhyLGYyGOXAxhud340VBbHK8GDeOKqhFkVbPLEaTsCfdz5
	 Em5Xr3mu1DLc6l/rB5PAdvOSjuy5SK1u3sQiWubo0l48uP07HUfM8DwQkBiZJOBf5R
	 6WQfaUrgIm6zF0W9swlulOSbkdhCvqlbl4SK0hsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 025/353] kunit: Reset test->priv after each param iteration
Date: Fri,  2 Feb 2024 20:02:23 -0800
Message-ID: <20240203035404.566550315@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 342fb9789267ee3908959bfa136b82e88e2ce918 ]

If we run parameterized test that uses test->priv to prepare some
custom data, then value of test->priv will leak to the next param
iteration and may be unexpected.  This could be easily seen if
we promote example_priv_test to parameterized test as then only
first test iteration will be successful:

$ ./tools/testing/kunit/kunit.py run \
	--kunitconfig ./lib/kunit/.kunitconfig *.example_priv*

[ ] Starting KUnit Kernel (1/1)...
[ ] ============================================================
[ ] =================== example (1 subtest) ====================
[ ] ==================== example_priv_test  ====================
[ ] [PASSED] example value 3
[ ] # example_priv_test: initializing
[ ] # example_priv_test: ASSERTION FAILED at lib/kunit/kunit-example-test.c:230
[ ] Expected test->priv == ((void *)0), but
[ ]     test->priv == 0000000060dfe290
[ ]     ((void *)0) == 0000000000000000
[ ] # example_priv_test: cleaning up
[ ] [FAILED] example value 2
[ ] # example_priv_test: initializing
[ ] # example_priv_test: ASSERTION FAILED at lib/kunit/kunit-example-test.c:230
[ ] Expected test->priv == ((void *)0), but
[ ]     test->priv == 0000000060dfe290
[ ]     ((void *)0) == 0000000000000000
[ ] # example_priv_test: cleaning up
[ ] [FAILED] example value 1
[ ] # example_priv_test: initializing
[ ] # example_priv_test: ASSERTION FAILED at lib/kunit/kunit-example-test.c:230
[ ] Expected test->priv == ((void *)0), but
[ ]     test->priv == 0000000060dfe290
[ ]     ((void *)0) == 0000000000000000
[ ] # example_priv_test: cleaning up
[ ] [FAILED] example value 0
[ ] # example_priv_test: initializing
[ ] # example_priv_test: cleaning up
[ ] # example_priv_test: pass:1 fail:3 skip:0 total:4
[ ] ================ [FAILED] example_priv_test ================
[ ]     # example: initializing suite
[ ]     # module: kunit_example_test
[ ]     # example: exiting suite
[ ] # Totals: pass:1 fail:3 skip:0 total:4
[ ] ===================== [FAILED] example =====================

Fix that by resetting test->priv after each param iteration, in
similar way what we did for the test->status.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 7aceb07a1af9..1cdc405daa30 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -660,6 +660,7 @@ int kunit_run_tests(struct kunit_suite *suite)
 				test.param_index++;
 				test.status = KUNIT_SUCCESS;
 				test.status_comment[0] = '\0';
+				test.priv = NULL;
 			}
 		}
 
-- 
2.43.0



