Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0EF312834;
	Sat, 12 Sep 2026 09:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205143; cv=none; b=jRMAKE7vUf0vg5uMPS/Jj9XlJRl0j8tJ1Yvrnum4vym8cTtdpJ6BhTDU2BSCGDvay8jYj4wNFEQnecDROeXoiiVW7jjStNTMC3dZcfUIIUkCQua0GHMpLAOVvxFHjwuUfbW396S+2tDNYeJZ8CnsmmOSFb78CB6lZ9H9suVpmgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205143; c=relaxed/simple;
	bh=cOhm1VM+KHS+FcjK4Hsxj/9Jnba3/jSisNKsC4rqiTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/zwDY2l3D33XM95Fh/oksHB6ouVZo36zg2dFGx5lZoqXbwsnr0+DCNZtzPBy4IGWlnJERKQADJJIRIjoVARO523Js9Z1WkmdR6M2Jv8OUSe27Ba7y0tOltkvrPrTel+wGUzVfVjGvWiA7XrqOk0jBMLnfRpg/h5aWuIbccAAjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2T7dio1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2T7dio1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AE11F000FF;
	Sat, 12 Sep 2026 09:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205142;
	bh=wVKQeagqdRyApRdmQPRerHxnkSOyIDQqDVJvvX10LHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2T7dio1sSQPs3onM+mU7rRD0LnUCAmfcucTblbJrUroRhRFyORH58H6wEZr0sqlJ
	 7LRLsb0aLESGP8+rQKqHHTXyct2YGLSwsSLu2HX4NsZciUTp8i6bu8BEdB2xXWZBrV
	 yGB9Mzs4dt6gdgs+W21MoSWRJLxB4E0+/2m5P6F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1757/1815] net: fix a resource leak in copy_net_ns() error handling path
Date: Sat, 12 Sep 2026 08:58:27 +0200
Message-ID: <20260912065730.236012512@linuxfoundation.org>
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
index 21fdda9c20c18..af26bb77991b2 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -399,14 +399,8 @@ static __net_init void preinit_net_sysctl(struct net *net)
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
@@ -427,7 +421,6 @@ static __net_init int preinit_net(struct net *net, struct user_namespace *user_n
 	INIT_LIST_HEAD(&net->ptype_all);
 	INIT_LIST_HEAD(&net->ptype_specific);
 	preinit_net_sysctl(net);
-	return 0;
 }
 
 /*
@@ -570,12 +563,14 @@ struct net *copy_net_ns(u64 flags,
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
@@ -587,6 +582,7 @@ struct net *copy_net_ns(u64 flags,
 	if (rv < 0) {
 put_userns:
 		ns_common_free(net);
+put_userns_no_common:
 #ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
 #endif
@@ -1289,7 +1285,8 @@ void __init net_ns_init(void)
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



