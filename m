Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43CB412276;
	Sat, 12 Sep 2026 11:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212353; cv=none; b=U3IfsCToh+fafud6EMxESB3wjzwoLkwvPRHHWdQFu7JSBDgXRhV8D9uuDdU58uS9Xb5TkUgjBIVLCJrwADpzG4RBYrApFRCfPmXc5umSAy7YXCZLwy+sb3MoE/TJA11taVAwyCWBr7jO7UBVIhhu9jURj0De/6yYb/bREnx9gvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212353; c=relaxed/simple;
	bh=jVstaJPwq5asAFfyzwxGungoYsbAhTZJX60lXUawkF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaO9ZO0DQtNAYW0IdIzx2Q2DcaWo7GLH5Z3uFtneesoBpCIs6Nct+vZseEE1x6o2iKL+BewIbJrtrW/B3cg5HoeCGLhFe7ydFWfH80wzkrL4ZoEw2AbOQUBWP466fBBzX2Eq1MEsNI6ujAEPxhWlKzQ/XG1YtENBjhmwgQN6tj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/Xcp7ug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/Xcp7ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DB11F000FF;
	Sat, 12 Sep 2026 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212351;
	bh=lTu0v+b0oK0UaDni0HwU28Lgg6Jv4NK8/NRP57tSpsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/Xcp7ugdrrEYq0OjQrBcvhZ5s0MZmsuaMfjc4cMwgIi34dGrszYU1wzjo8iNj0Wz
	 Hjo0GhCIFll9dBotRyccuYW0wfibnRdg+J3EacLn8gAcZafohgDHAcMN0ZQNrz7O1q
	 hJive4r9T9l9Chfs7VipBf5WxRdoYIK2l1N6lZhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1417/1518] net: fix a resource leak in copy_net_ns() error handling path
Date: Sat, 12 Sep 2026 08:59:46 +0200
Message-ID: <20260912065655.606814674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3220b62fbb8a55feebd2a826d5ead0f49f09ed5a ]

Currently, preinit_net() does two things:

  (1) call ns_common_init() which might fail
  (2) initialize resources which does not fail

However, preinit_net() is returning early when (1) fails, and copy_net_ns()
is jumping to the dec_ucounts: label. As a result, resources allocated by
net_alloc() are leaking. We need to call key_remove_domain() and
net_passive_dec() in order to release resources allocated by net_alloc().

We cannot simply jump to the put_userns: label when preinit_net() failed,
for (2) is not yet done. But we can reorder (1) and (2), for there is no
dependency between (1) and (2). Therefore, this patch decouples (1) from
preinit_net() and changes preinit_net() back to a void function, and calls
ns_common_init() after preinit_net() succeeded. Then, we can jump to
immediately after ns_common_free() of the put_userns: label.

Reported-by: sashiko (no mail address)
Closes: https://sashiko.dev/#/patchset/af7dabf3-d0d7-46dc-a878-e1715b3c9ac6%40I-love.SAKURA.ne.jp
Fixes: 08027f6b790b ("net: use ns_common_init()")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://patch.msgid.link/c182cf90-1ed7-435b-88f7-9f00e88a0487@I-love.SAKURA.ne.jp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index abc9a6b39dff1..4bece5eda9d1a 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -398,14 +398,8 @@ static __net_init void preinit_net_sysctl(struct net *net)
 }
 
 /* init code that must occur even if setup_net() is not called. */
-static __net_init int preinit_net(struct net *net, struct user_namespace *user_ns)
+static __net_init void preinit_net(struct net *net, struct user_namespace *user_ns)
 {
-	int ret;
-
-	ret = ns_common_init(net);
-	if (ret)
-		return ret;
-
 	refcount_set(&net->passive, 1);
 	ref_tracker_dir_init(&net->refcnt_tracker, 128, "net_refcnt");
 	ref_tracker_dir_init(&net->notrefcnt_tracker, 128, "net_notrefcnt");
@@ -426,7 +420,6 @@ static __net_init int preinit_net(struct net *net, struct user_namespace *user_n
 	INIT_LIST_HEAD(&net->ptype_all);
 	INIT_LIST_HEAD(&net->ptype_specific);
 	preinit_net_sysctl(net);
-	return 0;
 }
 
 /*
@@ -571,12 +564,14 @@ struct net *copy_net_ns(u64 flags,
 		goto dec_ucounts;
 	}
 
-	rv = preinit_net(net, user_ns);
-	if (rv < 0)
-		goto dec_ucounts;
+	preinit_net(net, user_ns);
 	net->ucounts = ucounts;
 	get_user_ns(user_ns);
 
+	rv = ns_common_init(net);
+	if (rv)
+		goto put_userns_no_common;
+
 	rv = down_read_killable(&pernet_ops_rwsem);
 	if (rv < 0)
 		goto put_userns;
@@ -588,6 +583,7 @@ struct net *copy_net_ns(u64 flags,
 	if (rv < 0) {
 put_userns:
 		ns_common_free(net);
+put_userns_no_common:
 #ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
 #endif
@@ -1285,7 +1281,8 @@ void __init net_ns_init(void)
 	 * This currently cannot fail as the initial network namespace
 	 * has a static inode number.
 	 */
-	if (preinit_net(&init_net, &init_user_ns))
+	preinit_net(&init_net, &init_user_ns);
+	if (ns_common_init(&init_net))
 		panic("Could not preinitialize the initial network namespace");
 
 	down_write(&pernet_ops_rwsem);
-- 
2.53.0



