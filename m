Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028757;
	b=Hw6rl4+7j4vJn+SROl7PE62Q086Afa06WdVLbRMNoCBMxYeywlSXfXrQ03g9retvrK5i
	 oDPD6HvDHexcXhsCllFGhyNnB+rhkr9+YobexrEeEuIxnIFmw5LbusqyKGRr54pDJHYmi
	 x/e8yJc9TYLCO6+JCdoPk5eACp2p6Nk8eRl2Vctaho58ZoybuLUD5aZ29GaumdlfPMQMY
	 8o84DZESOs6JEvCZ3aJxwSGXI8CQ2+HVocgAdEF7qGg5nTQX7m/+zDxsqDYt2AnysKOss
	 8BXliOzJ/SXkoqkiQIAJLZXjo6GcPNhBA7uiI676fK14jp3Nd2EhSe+rykR3uWqbwqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ToVGelf/NOf01mdILrY3jZdzReywU8lq5cwI6yIAmbk=;
	b=FLzBnMFt1+Zk+UqXBQ/6lHy7w6puBHxvLJ8QLPXiuEzuDkJ1WOvSt0UJ/Dvuwj8DYxRN
	 BNxT/BUlqNGogN+alGWXcytvzzuy/WDH8yhCECX35amIIa/NcJelJgz9dYMzFU3zQBIDz
	 Zeu4Lada6j4CgbXjQUuNUHqq0lR3BLGI+pLlvNnwZgnEYbliZ9dWusJWD2/Z19GsQLrsV
	 oJswf9roFbI80eCAvGLmqZt97uEpPRS7U/I5q5Yn7/zrKs4pF/f4tVMeGQZQRLtvpybeL
	 AqMnMr5g0YMyVi/xk9+G9wuyWorpTc5wGkpyRFMToJj+3VOm4b2aBi7YI4U433FOjxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PSd/iQSA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0441606A337;
	Wed, 18 Nov 2026 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSd/iQSA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0F71F000C4;
	Wed, 18 Nov 2026 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028757;
	bh=ToVGelf/NOf01mdILrY3jZdzReywU8lq5cwI6yIAmbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSd/iQSAJPI8/V71b5Es1eM6Uqu1r5CUwizHcKHSvy5faBePijfUI1OPu1uDmyY1T
	 RQaO4/Y8TZED+xO9aKng6ydh62Zbgp7SHgYmDnSo+DZHETbYlclTMs06BeWPJOOUvh
	 zStKhj92mEntqJl7PY3XDNRFtUV+crBnoxg3Fato=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0107/1756] rose: hold RTNL while a route is added or deleted
Date: Wed, 18 Nov 2026 15:37:14 +0100
Message-ID: <20261118150012.473007828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



