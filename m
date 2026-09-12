Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56EF3803E1;
	Sat, 12 Sep 2026 09:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204762; cv=none; b=ChwI5LhStnjMcBJYuxtmFfaf9RRDgpajvlFzAteBpQWr76sX3S8YlI0XNUXwZmxs02atK+TCN4fpxwLC35cSZ6J3BOewjqMeB2DJdgj5VkM9ryE5AIdsLof4ukKMpyUcCTCGYmGmifC1kTInEMv4f3HtKfPKkKlkoelGt9xint0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204762; c=relaxed/simple;
	bh=qBi0SOg9jLlkbcFchwJ+O5q4ssRI6/aCwrCIxiMPa+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfLUFllSyaSX8eb8qSaMZ1K6gfL9scF6mokiGXEIRjA33CRORGt56s1Pj2rejYe7slf10IHaGnJNdNd3ADvUl5Ke4uRXhUBdPlr9MsJq9gRXHm1SCq6iGUnYA7iWSOiQN0R295Ig+kqDeEVKLNJuxTMoXFIGRDVLnFmxTs06ChE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJw9Hr44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJw9Hr44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0AF1F000FF;
	Sat, 12 Sep 2026 09:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204759;
	bh=I+6/x2McAmHiZJI0/XJf+u3dj/sEc1EzW+oFxCvcodk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJw9Hr44JC2lusqIq3FT8mHrzOIt/8qAa6Rv+DCR6ZnfCKRynp8WiBo/CoJ3pFwu1
	 pcJR6ROo60TMs7vs24I99tTc7BNf/AWLSd2HAx9TS3iP0jWoKeyu4lb8QUvIqkwv5O
	 nrxwtztswhcGs9m6dpDwGTAZGO4yqnJlZI+qeQK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1678/1815] net: add missing ref_tracker_dir_exit() to net_passive_dec()
Date: Sat, 12 Sep 2026 08:57:08 +0200
Message-ID: <20260912065728.378910107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d9dafe24f57e3..21fdda9c20c18 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -532,8 +532,12 @@ void net_passive_dec(struct net *net)
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



