Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF36B30ACF6;
	Sat, 12 Sep 2026 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226091; cv=none; b=o5O8FTMa08S3N1A+ytYm3v2C14f6hqZx119dUlHrxy15kjrSXpTZdoxd/H8UkIZHJs3MkQu3IVWhjJsBGqlfwELdfzdVhYzkdKlXIeJFEJM+Rwao82PsyixbnTWVmDODzIv4VB+TtyiEIXl6p2XvNNft/aq99+YIOeSZmyYlVmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226091; c=relaxed/simple;
	bh=bwIpZ4zgn8gYE3077naMBuo0E4xQbUBQOO/uJrcjxzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeGPNpF7uczeiZM2ZDDoEbUxHRuGPmlcl9+J2eWS2dIwLQhAVpaKry1uFsNHK/sTaeYNF0JSbWpi/VZl0GD7/FaQ/frikeVFquYVn70MHogKfbB768xVNn35kvnOb3RuAPYuczAfGILKH2xRnkBlwzArB5R97fRtnmfLeO95YRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXihE0xE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXihE0xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FC91F000FF;
	Sat, 12 Sep 2026 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226089;
	bh=lDlEshFn01CGmpfsWExEcrUjo9MdrXxwnQ+ixmFMalM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXihE0xEggsbgdP5XfyrU0cEC7xYq2X+yYTZGX3A0ono/ta4yUbW2gw822eS7c+x+
	 08Wi4x/ol565+gBX+5EW93Z/kA8bXUUFCzUGjlevDwLS0rFBXvjAiZdLiXe7HA85Yv
	 xTeCfDYc2xfgJvQ6W7EiEUJcGsQtDaVpTGBhAqvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1332/1424] net: add missing ref_tracker_dir_exit() to net_passive_dec()
Date: Sat, 12 Sep 2026 09:02:44 +0200
Message-ID: <20260912065637.088663705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit f85dc137aabf357bf3d9fe4c9712121039d83798 ]

I found that trying to read /sys/kernel/debug/ref_tracker/* causes NULL
pointer dereference crash when alloc_netdev_mqs() via unshare() returned
NULL, for commit 9ba74e6c9e9d ("net: add networking namespace refcount
tracker") added ref_tracker_dir_exit(&net->refcnt_tracker) to only
__put_net() path whereas commit 65b584f53611 ("ref_tracker: automatically
register a file in debugfs for a ref_tracker_dir") added
ref_tracker_dir_debugfs() to ref_tracker_dir_init() path.

Since preinit_net() calls ref_tracker_dir_init(&net->refcnt_tracker) and
ref_tracker_dir_init(&net->notrefcnt_tracker), we need to make sure that
both ref_tracker_dir_exit(&net->refcnt_tracker) and
ref_tracker_dir_exit(&net->notrefcnt_tracker) are called before
net_passive_dec() schedules for kmem_cache_free() via net_complete_free().

ref_tracker_dir_exit(&net->refcnt_tracker) is called via put_net() when
ns_ref_put() returned true. But put_net() is not called when copy_net_ns()
fails. Therefore, call ref_tracker_dir_exit() from net_passive_dec() if
put_net() is not yet called.

Link: https://sashiko.dev/#/patchset/b06ce35d-e7bc-47a5-8e0a-e82be7e4dd08%40I-love.SAKURA.ne.jp
Fixes: 9ba74e6c9e9d ("net: add networking namespace refcount tracker")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://patch.msgid.link/64254d80-9248-466c-8108-95f43bd71117@I-love.SAKURA.ne.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index b99fdca441f31..99b54f469edfb 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -472,8 +472,12 @@ void net_passive_dec(struct net *net)
 	if (refcount_dec_and_test(&net->passive)) {
 		kfree(rcu_access_pointer(net->gen));
 
+#ifdef CONFIG_REF_TRACKER
 		/* There should not be any trackers left there. */
 		ref_tracker_dir_exit(&net->notrefcnt_tracker);
+		if (!net->refcnt_tracker.dead)
+			ref_tracker_dir_exit(&net->refcnt_tracker);
+#endif
 
 		/* Wait for an extra rcu_barrier() before final free. */
 		llist_add(&net->defer_free_list, &defer_free_list);
-- 
2.53.0



