Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C2F25A355;
	Tue, 21 Oct 2025 20:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077370; cv=none; b=FiSSfiHvgPZWIu/maBsnyhh0ALPr3cRzIZN25MeBD6bzSq7agFifLWhW40gVIlnWgxMeSkPZ9IZF9tBgwLTJ4iLK1zsZpnXF4vjSBB3UbzFWuwws4/O5JbtoTqe1gMyBR8T42innAI6cPoTa3wik57iC4+xB7QrrU4ddk8wyAXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077370; c=relaxed/simple;
	bh=ilLaYYpiee2a+PTtzeDuYrEfiApAFtnasrChE8+QbyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2bcpjmRapRFl8iF9/+6ARbxZuVxM/1PxtgZhFZA2BetqR7VJtuhIlIgrOAszDdz/Iavdujnxgirsl2LqMDv78iEdki0tIWzff8vDzs01hayiyY/MLNsWsDOEyPUSkAHMrQdZm4PBAtabvkka4pvNog2eyuFrsVC4QNRyAULRII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL5wBP3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL5wBP3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F08C4CEF1;
	Tue, 21 Oct 2025 20:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077370;
	bh=ilLaYYpiee2a+PTtzeDuYrEfiApAFtnasrChE8+QbyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL5wBP3XhpE/K9A6/BTSVy7sW8gZOhIpOeoT2B7YMOGq6qCCVkWixZOTLomcXDOfG
	 j6eLPejAb3erc1Jz3fQ0J+6n45vjpd19vwVem3NSmDP+CoR2xBoGW7HlT15ksgvbeH
	 CKxLiw6VYYQSWy3Of3kXCOCTp6qQUgfXV98rla7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 082/159] net: core: fix lockdep splat on device unregister
Date: Tue, 21 Oct 2025 21:50:59 +0200
Message-ID: <20251021195045.168180087@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7f0fddd817ba6daebea1445ae9fab4b6d2294fa8 ]

Since blamed commit, unregister_netdevice_many_notify() takes the netdev
mutex if the device needs it.

If the device list is too long, this will lock more device mutexes than
lockdep can handle:

unshare -n \
 bash -c 'for i in $(seq 1 100);do ip link add foo$i type dummy;done'

BUG: MAX_LOCK_DEPTH too low!
turning off the locking correctness validator.
depth: 48  max: 48!
48 locks held by kworker/u16:1/69:
 #0: ..148 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work
 #1: ..d40 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work
 #2: ..bd0 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net
 #3: ..aa8 (rtnl_mutex){+.+.}-{4:4}, at: default_device_exit_batch
 #4: ..cb0 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: unregister_netdevice_many_notify
[..]

Add a helper to close and then unlock a list of net_devices.
Devices that are not up have to be skipped - netif_close_many always
removes them from the list without any other actions taken, so they'd
remain in locked state.

Close devices whenever we've used up half of the tracking slots or we
processed entire list without hitting the limit.

Fixes: 7e4d784f5810 ("net: hold netdev instance lock during rtnetlink operations")
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://patch.msgid.link/20251013185052.14021-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8d49b2198d072..5194b70769cc5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -12088,6 +12088,35 @@ static void dev_memory_provider_uninstall(struct net_device *dev)
 	}
 }
 
+/* devices must be UP and netdev_lock()'d */
+static void netif_close_many_and_unlock(struct list_head *close_head)
+{
+	struct net_device *dev, *tmp;
+
+	netif_close_many(close_head, false);
+
+	/* ... now unlock them */
+	list_for_each_entry_safe(dev, tmp, close_head, close_list) {
+		netdev_unlock(dev);
+		list_del_init(&dev->close_list);
+	}
+}
+
+static void netif_close_many_and_unlock_cond(struct list_head *close_head)
+{
+#ifdef CONFIG_LOCKDEP
+	/* We can only track up to MAX_LOCK_DEPTH locks per task.
+	 *
+	 * Reserve half the available slots for additional locks possibly
+	 * taken by notifiers and (soft)irqs.
+	 */
+	unsigned int limit = MAX_LOCK_DEPTH / 2;
+
+	if (lockdep_depth(current) > limit)
+		netif_close_many_and_unlock(close_head);
+#endif
+}
+
 void unregister_netdevice_many_notify(struct list_head *head,
 				      u32 portid, const struct nlmsghdr *nlh)
 {
@@ -12120,17 +12149,18 @@ void unregister_netdevice_many_notify(struct list_head *head,
 
 	/* If device is running, close it first. Start with ops locked... */
 	list_for_each_entry(dev, head, unreg_list) {
+		if (!(dev->flags & IFF_UP))
+			continue;
 		if (netdev_need_ops_lock(dev)) {
 			list_add_tail(&dev->close_list, &close_head);
 			netdev_lock(dev);
 		}
+		netif_close_many_and_unlock_cond(&close_head);
 	}
-	netif_close_many(&close_head, true);
-	/* ... now unlock them and go over the rest. */
+	netif_close_many_and_unlock(&close_head);
+	/* ... now go over the rest. */
 	list_for_each_entry(dev, head, unreg_list) {
-		if (netdev_need_ops_lock(dev))
-			netdev_unlock(dev);
-		else
+		if (!netdev_need_ops_lock(dev))
 			list_add_tail(&dev->close_list, &close_head);
 	}
 	netif_close_many(&close_head, true);
-- 
2.51.0



