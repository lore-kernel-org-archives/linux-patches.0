Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6836F15703D;
	Mon, 29 Jan 2024 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548308; cv=none; b=kKSQE0p4f4obaipOYjVCX82Av+79wPQsGocHguZTizaVLxmhY1/fr3wYT/uRN/efJK7uvA4LHXPz1Tzmb/aU7wJIlXO8SeFpGOyEejunklc/fJ0PtFjM9Z0wTIi5GxFtT8MPVtGVym2W+RJKZLF37ajBuRXw6KlfxelCSznOYpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548308; c=relaxed/simple;
	bh=CQxMez5WEmzXKaPJIjiHDnmr0EjxEMnq4u3IT1KpvGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FK78efx40wSgZiexrIvVRm+ubxcrZdZLIu6waYzh58VaxvrFAOD9o4BluqG9YxJqzsTrDOPgSBmH+qjK7krKgRhdgzwohEfgFdFKuISvpLRX8hHuwZF53G5ghSzpYUHTv6vbY9Q9RVZmiJ7qkvRlp3hNyNhHNQeqIJt/X/9lRPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkXdWI2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkXdWI2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310C1C433C7;
	Mon, 29 Jan 2024 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548308;
	bh=CQxMez5WEmzXKaPJIjiHDnmr0EjxEMnq4u3IT1KpvGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkXdWI2F5tbvS7EtnbY1jKCCAbONHkFwVBLRTMhWX4ZiIPHqEAfXd0aLwXDllJWx5
	 Swn05Brs4ZMg0jItfRVeGHbMnHVf/m5z8ZLxiZvsarDredfz/HLJPXmgJIqa3XyPUH
	 3W4Kp3OXZssV6dRt64N7MljK4VCSXwHjdbYLgYPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=D0=9C=D0=B0=D1=80=D0=BA=20=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= <socketpair@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/185] net: fix removing a namespace with conflicting altnames
Date: Mon, 29 Jan 2024 09:04:44 -0800
Message-ID: <20240129170001.300768409@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d09486a04f5da0a812c26217213b89a3b1acf836 ]

Mark reports a BUG() when a net namespace is removed.

    kernel BUG at net/core/dev.c:11520!

Physical interfaces moved outside of init_net get "refunded"
to init_net when that namespace disappears. The main interface
name may get overwritten in the process if it would have
conflicted. We need to also discard all conflicting altnames.
Recent fixes addressed ensuring that altnames get moved
with the main interface, which surfaced this problem.

Reported-by: Марк Коренберг <socketpair@gmail.com>
Link: https://lore.kernel.org/all/CAEmTpZFZ4Sv3KwqFOY2WKDHeZYdi0O7N5H1nTvcGp=SAEavtDg@mail.gmail.com/
Fixes: 7663d522099e ("net: check for altname conflicts when changing netdev's netns")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 9 +++++++++
 net/core/dev.h | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0a5566b6f8a2..1ba3662faf0a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11323,6 +11323,7 @@ static struct pernet_operations __net_initdata netdev_net_ops = {
 
 static void __net_exit default_device_exit_net(struct net *net)
 {
+	struct netdev_name_node *name_node, *tmp;
 	struct net_device *dev, *aux;
 	/*
 	 * Push all migratable network devices back to the
@@ -11345,6 +11346,14 @@ static void __net_exit default_device_exit_net(struct net *net)
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
 		if (netdev_name_in_use(&init_net, fb_name))
 			snprintf(fb_name, IFNAMSIZ, "dev%%d");
+
+		netdev_for_each_altname_safe(dev, name_node, tmp)
+			if (netdev_name_in_use(&init_net, name_node->name)) {
+				netdev_name_node_del(name_node);
+				synchronize_rcu();
+				__netdev_name_node_alt_destroy(name_node);
+			}
+
 		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
 			pr_emerg("%s: failed to move %s to init_net: %d\n",
diff --git a/net/core/dev.h b/net/core/dev.h
index 9ca91457c197..db9ff8cd8d46 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -63,6 +63,9 @@ int dev_change_name(struct net_device *dev, const char *newname);
 
 #define netdev_for_each_altname(dev, namenode)				\
 	list_for_each_entry((namenode), &(dev)->name_node->list, list)
+#define netdev_for_each_altname_safe(dev, namenode, next)		\
+	list_for_each_entry_safe((namenode), (next), &(dev)->name_node->list, \
+				 list)
 
 int netdev_name_node_alt_create(struct net_device *dev, const char *name);
 int netdev_name_node_alt_destroy(struct net_device *dev, const char *name);
-- 
2.43.0



