Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F72261FCD;
	Mon, 27 May 2024 19:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836860; cv=none; b=SWNYOgvB3eT8u0EI4stqVWqf/05akd8y7YTPDCGmlCpI2wdfvcryGs/ZKjXNSm9BGKAOx6MVoCdVLNwSnFDjDbIox2DkmWcM7ecb98bygOc69mqg3eyUri1xtBKgyNLY6wn9t4D9fezd27AwOiqCW50TX1HJzBCnNpbyVxYTDYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836860; c=relaxed/simple;
	bh=6Y8rwQR5T7m2PEVgkjw4UDt90CrDWGNaOloLfhJlQcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puH3g4/T+1e+M1IvPwnaAx0K1ZxMjmijgX3NNdwXDMU0HpbfA7aflVOy1wozJ9TtoZMducGWmJ77doa9nsCpJNNai/yVJ0CpIPxndKK7pzDzTVXSyX7jkhIgAZK+0UluHnX8iFRkXjw59q4DjY9cQBc7Uih6ErJIKQc0aweMDsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7Bp/Fak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7Bp/Fak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EBAC32782;
	Mon, 27 May 2024 19:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836860;
	bh=6Y8rwQR5T7m2PEVgkjw4UDt90CrDWGNaOloLfhJlQcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7Bp/Fak/v90aWmrNIqptJJ91jMH9ekIemGjy1Bf19u0vdRGHD6LZG9TN24IJEvbS
	 +W9Xd1Iqp+1Z10XNkepbed1c89NU92ylonCh7aQXhseSb3MvFhOcv13VU2Kibpro3X
	 d7n8TmtjpUzHN21lHcSvtGgH7qRsgNlguhY7vtZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Pache <npache@redhat.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 215/427] kunit: bail out early in __kunit_test_suites_init() if there are no suites to test
Date: Mon, 27 May 2024 20:54:22 +0200
Message-ID: <20240527185622.550488105@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 5496b9b77d7420652202b73cf036e69760be5deb ]

Commit c72a870926c2 added a mutex to prevent kunit tests from running
concurrently.  Unfortunately that mutex gets locked during module load
regardless of whether the module actually has any kunit tests.  This
causes a problem for kunit tests that might need to load other kernel
modules (e.g. gss_krb5_test loading the camellia module).

So check to see if there are actually any tests to run before locking
the kunit_run_lock mutex.

Fixes: c72a870926c2 ("kunit: add ability to run tests after boot using debugfs")
Reported-by: Nico Pache <npache@redhat.com>
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 1d1475578515c..b8514dbb337c0 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -712,6 +712,9 @@ int __kunit_test_suites_init(struct kunit_suite * const * const suites, int num_
 {
 	unsigned int i;
 
+	if (num_suites == 0)
+		return 0;
+
 	if (!kunit_enabled() && num_suites > 0) {
 		pr_info("kunit: disabled\n");
 		return 0;
-- 
2.43.0



