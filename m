Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761B13195E4;
	Tue, 31 Mar 2026 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774977004; cv=none; b=rrShUq+ZfwSmvLljPH5iuDyVsm8tsfC8nlA5sceiOw0V7jOSzsj4CanHHioP2AoGrz0ImhXlYdumeDcgUxFK718hvOWCeJCb2RUhzzZ0Ce7T+63AnPKBozk6spYjxLksEJkuca7KIiWH88AXgf6muEZlvLCfNIEiEOJQ7fR5mjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774977004; c=relaxed/simple;
	bh=r5S2e0rjpq9gnIoZUHR/Ypv9/gOZQipwCptdIBnbtYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s479fw2c1OXRjYBw1qgUhKlJXzy/3irBbDMu4RNgxBik4gU9Z96H0Dw7pBKZn+C6RgKztuGzXX3MKZwBK7dx4YSrRtWei2ninkzlH9S4NcT1Vh5b+arKEY9Mvaz1dPKJaD8dNSFmbB/VRFCErX7pYIwfTYPJjATrojOYdMnAl0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djCsdm/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djCsdm/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B3DC19423;
	Tue, 31 Mar 2026 17:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774977004;
	bh=r5S2e0rjpq9gnIoZUHR/Ypv9/gOZQipwCptdIBnbtYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djCsdm/0r7HQyrsMSvbcOhi/iEFCOnmYQtsSzjS5w0M1gv2vHjrPJYekvAANGeeuv
	 KU00xENCgDJD2NzEvc54NIeoOICC1xfkBqAGAs3piQQZBNJtr36frUXzzQ4FS/xSBt
	 PQVk4pTuqLbsIgGNk7waE4OdWG9csUf8O70i/hnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 279/309] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Tue, 31 Mar 2026 18:23:02 +0200
Message-ID: <20260331161803.833961879@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Law <objecting@objecting.org>

commit 7fe000eb32904758a85e62f6ea9483f89d5dabfc upstream.

Patch series "mm/damon/sysfs: fix memory leak and NULL dereference
issues", v4.

DAMON_SYSFS can leak memory under allocation failure, and do NULL pointer
dereference when a privileged user make wrong sequences of control.  Fix
those.


This patch (of 3):

When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
param_ctx is leaked because the early return skips the cleanup at the out
label.  Destroy param_ctx before returning.

Link: https://lkml.kernel.org/r/20260321175427.86000-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260321175427.86000-2-sj@kernel.org
Fixes: f0c5118ebb0e ("mm/damon/sysfs: catch commit test ctx alloc failure")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1476,8 +1476,10 @@ static int damon_sysfs_commit_input(void
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_new_ctx();
-	if (!test_ctx)
+	if (!test_ctx) {
+		damon_destroy_ctx(param_ctx);
 		return -ENOMEM;
+	}
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err)
 		goto out;


