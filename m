Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AF73112AE;
	Mon, 18 Aug 2025 13:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524334; cv=none; b=WQNntcjrqb6+IlaLUsaMSV0QVEuProGPN03wL5C2wvLmSRDCdvU0NMseUKMyMxW2L9jhgIMJtlzZGp0YP16AKx6cI+anQQvAMCjAiYW347E+lmqHY7NjV4r0hk/ylOiSekad8myZi/GQJETwO1tdHiuHf/go0iEdxKGwfgLag44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524334; c=relaxed/simple;
	bh=08yxGWiLxQYiZvHz+VcDOkvuygfJWFHhBlnVLv4N7VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0HtceHndbkDH7Ew0YOxF6U0Eynym05dnUBaKVRegmYLfEYJUutiaqBIh6Yh2nFxGrOTi7eUalRgCj5ZTcRabWWeMB7g7vVcNjPE8bQaHqTyCrxEIGCOEP/fAbilwMHYHn6teSVS6FLxVQv1P5/hGkAqQ4hk+Gjo6jUBV0g4cKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTVHKXun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTVHKXun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16222C116C6;
	Mon, 18 Aug 2025 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524334;
	bh=08yxGWiLxQYiZvHz+VcDOkvuygfJWFHhBlnVLv4N7VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTVHKXunQYTvDim+SXxt9Oq5sZlvvhEER6J1am2ViP4k7JG4ksNND7hNMQufyx6s6
	 kfNM0tmR1y+hUkPPhYtZf51d4A7ClgwNnk3XVXwT/bfkIZYdgac25D+g4M4td1zv5L
	 TWcg7fNKhnf+hUu7fxMJANFy7yo0EpLVtbc9oAq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 441/515] samples/damon/wsse: fix boot time enable handling
Date: Mon, 18 Aug 2025 14:47:07 +0200
Message-ID: <20250818124515.402615199@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 0ed1165c37277822b519f519d0982d36efc30006 upstream.

Patch series "mm/damon: fix misc bugs in DAMON modules".

>From manual code review, I found below bugs in DAMON modules.

DAMON sample modules crash if those are enabled at boot time, via kernel
command line.  A similar issue was found and fixed on DAMON non-sample
modules in the past, but we didn't check that for sample modules.

DAMON non-sample modules are not setting 'enabled' parameters accordingly
when real enabling is failed.  Honggyu found and fixed[1] this type of
bugs in DAMON sample modules, and my inspection was motivated by the great
work.  Kudos to Honggyu.

Finally, DAMON_RECLIAM is mistakenly losing scheme internal status due to
misuse of damon_commit_ctx().  DAMON_LRU_SORT has a similar misuse, but
fortunately it is not causing real status loss.

Fix the bugs.  Since these are similar patterns of bugs that were found in
the past, it would be better to add tests or refactor the code, in future.


This patch (of 6):

If 'enable' parameter of the 'wsse' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250706193207.39810-2-sj@kernel.org
Link: https://lore.kernel.org/20250702000205.1921-1-honggyu.kim@sk.com [1]
Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/wsse.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index e20238a249e7..e941958b1032 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -89,6 +89,8 @@ static void damon_sample_wsse_stop(void)
 		put_pid(target_pidp);
 }
 
+static bool init_called;
+
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -114,7 +116,15 @@ static int damon_sample_wsse_enable_store(
 
 static int __init damon_sample_wsse_init(void)
 {
-	return 0;
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_wsse_start();
+		if (err)
+			enable = false;
+	}
+	return err;
 }
 
 module_init(damon_sample_wsse_init);
-- 
2.50.1



