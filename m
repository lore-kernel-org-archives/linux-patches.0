Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022702;
	b=pdINvWvEnoPTM3HVRy8yOKillGHs3zA0laEOVe8ZoJ3JMHICLMbmk1laP2h3QQUEKhEi
	 XDbP80TuQymbmVyisuvelbRqCTIQ7M+mREafk0LXrUPxOH6jcIyT/n5oCrichaahYPia6
	 ZlDAdIlI0w6/92tzpOH0+E8sK7QR4jSzpEoZiZrPDpJD5w5bgujBoj6RmxBmSCnv/Bywl
	 Rdso21gQ+wR+kwFB5G/zopcXUAtL9kLZPmNyXOEXrsSS1ufeslcKyGeOYUFkCo+gnoif1
	 DTR8JleTna7u6Eh7663xf7qwQa/9v+wuCCOz0zKd5dcS1gv8Suq4xXTqA7MQ8ebk1aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdZ7tpjLJ518DV8cyNcexoNWiJ0ivlGe2eRp2e+bHME=;
	b=pOVn/9jfVmO8r21A6kAv90nYy6DEHCYUMxqO60+VHISAlyzQIunSoXwT10c2DgtXxMsL
	 T8nreylt6S7ej6LSH1QY7dvQsAznscjKG6q0DuU1sKSfBmbG4apEsrnqHd0P5Hv6k9rRY
	 SnVCvfstn9fPg+J2Huho/Ehc25zEK7jG5mRmP82MFSbZn+6lqisKmg+px8o2fmFsqE/KE
	 BKGBeLlHoEvibiN++P8phw9vnJg5NOdDsJPc04ThIsEkFIv/+IJUkaPDOSer/Yv6+XwwN
	 eK+PIiyjDM4oh5tY1R4GFNzYQeIr/WjiXtp4wB7wHuTAufYbhFu/A5KKBwElhFyMUYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o2HXxXQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5132A606A330;
	Wed, 18 Nov 2026 17:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o2HXxXQ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97D71F000C4;
	Wed, 18 Nov 2026 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022702;
	bh=bdZ7tpjLJ518DV8cyNcexoNWiJ0ivlGe2eRp2e+bHME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2HXxXQ9lgsBWSqS+9aZrNfjsk80aoc6VVwR2lWgp1aDEgggkd4OviZVBuwT85jHC
	 3hQKpxJOY1FgvfEsuGgSGteDZbN5NOy2Zf2y1gaEJyu33TxGbjCOsf2k/FqVrSUg3U
	 /83y/CfMv9E95We+YEJJ4HV1MheglYZLkGegmeIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0108/2151] rose: hold RTNL while a route is added or deleted
Date: Wed, 18 Nov 2026 15:30:43 +0100
Message-ID: <20261118150125.732104361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_ax25_dev_find() says it is called with RTNL, but rose_rt_ioctl()
does not take it for SIOCADDRT and SIOCDELRT. __dev_get_by_name() is
then used without RTNL or RCU, and the device can go down between the
IFF_UP check and rose_add_node(): the NETDEV_DOWN notifier runs
rose_rt_device_down(), finds no neighbour on the device yet, and the
neighbour added right after keeps a pointer to a device that may be
unregistered and freed, since rose_neigh->dev holds no reference.

Commit b4ec82402149 ("rose: device refcount leak") stopped taking a
reference on the device because RTNL would be held, which the ioctl
never did.

Take RTNL around the lookup of the device and the change of the
tables. The notifier runs under RTNL too, so a neighbour is either on
the list before the device goes down, where rose_rt_device_down()
removes it, or not added at all.

Fixes: b4ec82402149 ("rose: device refcount leak")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 1b9d3d721a9d334e7cd8ab21a2885fe1fa271a80)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 70ed72f4a11cb..7044496bb214e 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -17,6 +17,7 @@
 #include <net/ax25.h>
 #include <linux/inet.h>
 #include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
 #include <net/arp.h>
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
@@ -829,23 +830,29 @@ int rose_rt_ioctl(unsigned int cmd, void __user *arg)
 	case SIOCADDRT:
 		if (copy_from_user(&rose_route, arg, sizeof(struct rose_route_struct)))
 			return -EFAULT;
-		if ((dev = rose_ax25_dev_find(rose_route.device)) == NULL)
-			return -EINVAL;
 		if (rose_dev_exists(&rose_route.address)) /* Can't add routes to ourself */
 			return -EINVAL;
 		if (rose_route.mask > 10) /* Mask can't be more than 10 digits */
 			return -EINVAL;
 		if (rose_route.ndigis > AX25_MAX_DIGIS)
 			return -EINVAL;
-		err = rose_add_node(&rose_route, dev);
+		/*
+		 * RTNL keeps the device up until the neighbour that uses it
+		 * is on the list, where rose_rt_device_down() finds it.
+		 */
+		rtnl_lock();
+		dev = rose_ax25_dev_find(rose_route.device);
+		err = dev ? rose_add_node(&rose_route, dev) : -EINVAL;
+		rtnl_unlock();
 		return err;
 
 	case SIOCDELRT:
 		if (copy_from_user(&rose_route, arg, sizeof(struct rose_route_struct)))
 			return -EFAULT;
-		if ((dev = rose_ax25_dev_find(rose_route.device)) == NULL)
-			return -EINVAL;
-		err = rose_del_node(&rose_route, dev);
+		rtnl_lock();
+		dev = rose_ax25_dev_find(rose_route.device);
+		err = dev ? rose_del_node(&rose_route, dev) : -EINVAL;
+		rtnl_unlock();
 		return err;
 
 	case SIOCRSCLRRT:
-- 
2.53.0



