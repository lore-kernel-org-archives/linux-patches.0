Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622215;
	b=xaz+0Ic9TiXDhj6bgpuEjwmp7UyvyyKf5vmLxtYrhDgPO4uM0bGGZytml7R6UKhglBsE
	 +5HetaaoUMq/QTdB3odvUpMC1KzPw9yqdElJQbzBIkvuYjY189WS0vt8s0lOfOQ/iD7kU
	 dkAT98oWNaO0/NmsjZpq+uW6iYQpThmBoEG4IA71/eS+ThV5b0jSG9o09nH392ENLe5q3
	 pF+tag2DkJR0PiWfiGgjHWZzijFSmmesUKqbKUVMz0hVJV58GxKx7jPtmbpKY9tLggvtb
	 2o2M0X3VhhCEAR+2SMzKVyxmDwvklKf33AcAEUDMi0QWPc1LAbIrZxCFkckXqUgDILQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQ5612uw8PkRGkFYu50sj27XoBqNhqAsLvTks83zjnA=;
	b=Ll9jVcUQG/S/wNp+diikA4cp90BJp620qT14UUvoJOkcer9qYqqA7yRIEHKPLb7+cFEl
	 7oFHSoZ2KLJMusWdPtacgNfv1FRBja+XwNopKiMBZwAiz1+woIyfHhuiMYaDSy/A1vjDG
	 gd6V08kOlkPTRhf0JfFPT/dUJ0rx7M1av1+fX+8f1Y8MWTqH7XwT1hxUh12riq+lw5OUM
	 j+7DqcPD6J4JZHJUy4blJv4uwg9HaOcOl81iNJrP/wwtx4taWpXjSdYCt2+reKgkaoa6b
	 jwOT2UY0Vr8ZUWAGT2Yrv9JZTmUTS+al9LEDAU5bo/1x6gLYkKuT0zT9JOFWKiZdyvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=peKBJEzb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50480606A321;
	Wed, 25 Nov 2026 15:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=peKBJEzb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9142A1F000C4;
	Wed, 25 Nov 2026 15:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622215;
	bh=bQ5612uw8PkRGkFYu50sj27XoBqNhqAsLvTks83zjnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peKBJEzbdhhYNOXKFdI1HtdEmvHmstgDqTL8XQSVpx5VAEo8vfN7hkxVh+Y4iAhuk
	 PyCy/rO6z05miHRor6LytVww23gQjR5W6N5dcKuzYdBDi+vCr6l736JoOsSGdt0DE1
	 Jcb4AeNbwHXba+4OSknDO1FaOr9aHCrohRQsNQyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Ramadan <omar@blockcast.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 449/990] amt: tear down every amt device on an unregistering lower
Date: Wed, 25 Nov 2026 15:30:16 +0100
Message-ID: <20261125143832.610252248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Ramadan <omar@blockcast.net>

[ Upstream commit 7262e999ebec0a10ecc97ba4739f12255b7c6da8 ]

amt_device_event() acts only on the amt device that
amt_lookup_upper_dev() returns, which is the first amt device bound to
the event's lower. Several amt devices can share one lower, for
example two gateways.

On NETDEV_UNREGISTER, only the first device is unlinked and
unregistered. The others stay upper-linked to the lower, and
unregister_netdevice_many_notify() warns, because the notifier chain
must detach every upper device. They also still hold a reference on
the lower, so each is torn down only when netdev_wait_allrefs_any(),
called from netdev_run_todo(), rebroadcasts NETDEV_UNREGISTER. By then
the lower's sysfs directory is gone, so unlinking it trips a kernfs
WARN, and unregistering it from inside the rebroadcast trips the WARN
in __rtnl_unlock(). On NETDEV_CHANGEMTU, only the first device is
resized.

Walk every amt device in the lower's netns and act on each one bound
to the lower. On NETDEV_UNREGISTER, queue them all and unregister them
in one batch. amt_dellink() unlinks each device but leaves it on the
netns device list until unregister_netdevice_many(), so the walk stays
valid under RTNL.

To reproduce:

  ip link add lower0 type dummy
  ip link add amtg1 type amt mode gateway local 192.0.2.1 \
          discovery 192.0.2.2 dev lower0
  ip link add amtg2 type amt mode gateway local 192.0.2.1 \
          discovery 192.0.2.2 dev lower0
  ip link del lower0

Without this patch, the last command logs:

  WARNING: net/core/dev.c:12773 at unregister_netdevice_many_notify+0x13e5/0x1940, CPU#3: ip/216
  kernfs: can not remove 'upper_amtg2', no directory
  WARNING: fs/kernfs/dir.c:1784 at kernfs_remove_by_name_ns+0xc9/0xd0, CPU#0: ip/216
  WARNING: net/core/rtnetlink.c:141 at __rtnl_unlock+0xb2/0xf0, CPU#0: ip/216
  WARNING: net/core/rtnetlink.c:141 at __rtnl_unlock+0xb2/0xf0, CPU#0: ip/216

With it, the commands log nothing and remove both amt devices, and
tools/testing/selftests/net/amt.sh passes on a KASAN and lockdep
kernel.

Found by a selftest for our upcoming AMT offload RFC, which deletes a
lower carrying two amt gateways, on our 6.18-based driver. The
commands above reproduce it on net.

Fixes: b9022b53adad ("amt: add control plane of amt interface")
Signed-off-by: Omar Ramadan <omar@blockcast.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261105232302.494171-1-omar@blockcast.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 56 ++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 96cde820237d3..2a8a0c0e78993 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3383,22 +3383,6 @@ static struct rtnl_link_ops amt_link_ops __read_mostly = {
 	.fill_info      = amt_fill_info,
 };
 
-static struct net_device *amt_lookup_upper_dev(struct net_device *dev)
-{
-	struct net_device *upper_dev;
-	struct amt_dev *amt;
-
-	for_each_netdev(dev_net(dev), upper_dev) {
-		if (netif_is_amt(upper_dev)) {
-			amt = netdev_priv(upper_dev);
-			if (amt->stream_dev == dev)
-				return upper_dev;
-		}
-	}
-
-	return NULL;
-}
-
 static int amt_device_event(struct notifier_block *unused,
 			    unsigned long event, void *ptr)
 {
@@ -3408,26 +3392,34 @@ static int amt_device_event(struct notifier_block *unused,
 	LIST_HEAD(list);
 	int new_mtu;
 
-	upper_dev = amt_lookup_upper_dev(dev);
-	if (!upper_dev)
-		return NOTIFY_DONE;
-	amt = netdev_priv(upper_dev);
+	/* amt_dellink() leaves each device on the netns device list until
+	 * unregister_netdevice_many(), so the walk stays valid.
+	 */
+	for_each_netdev(dev_net(dev), upper_dev) {
+		if (!netif_is_amt(upper_dev))
+			continue;
+		amt = netdev_priv(upper_dev);
+		if (amt->stream_dev != dev)
+			continue;
 
-	switch (event) {
-	case NETDEV_UNREGISTER:
-		amt_dellink(amt->dev, &list);
-		unregister_netdevice_many(&list);
-		break;
-	case NETDEV_CHANGEMTU:
-		if (amt->mode == AMT_MODE_RELAY)
-			new_mtu = dev->mtu - AMT_RELAY_HLEN;
-		else
-			new_mtu = dev->mtu - AMT_GW_HLEN;
+		switch (event) {
+		case NETDEV_UNREGISTER:
+			amt_dellink(amt->dev, &list);
+			break;
+		case NETDEV_CHANGEMTU:
+			if (amt->mode == AMT_MODE_RELAY)
+				new_mtu = dev->mtu - AMT_RELAY_HLEN;
+			else
+				new_mtu = dev->mtu - AMT_GW_HLEN;
 
-		dev_set_mtu(amt->dev, new_mtu);
-		break;
+			dev_set_mtu(amt->dev, new_mtu);
+			break;
+		}
 	}
 
+	if (event == NETDEV_UNREGISTER)
+		unregister_netdevice_many(&list);
+
 	return NOTIFY_DONE;
 }
 
-- 
2.53.0



