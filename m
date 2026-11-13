Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590073;
	b=JlCk/I4Jz/RpZ3n4hLJL9eod6S4W21dVjRFlNV//72+zz/CAJd+mhKj9dQx7I7Zkamu/
	 RVk1gmvfR2Jim11WlFxryPaf0ORRMbp7cH5mgUN5RKzrWbaDcHn+wfyO7hr7R+Z7eJqQ9
	 3Z55dXWJ1m99izml8834a/1X1Scac3qRzvDtdLtEK3OKJE6mFNkWDsCIlz0aUKwNwZcaX
	 qHtNN/9aatkOik9cOFc6mYj4sVpCryfOOilh0I6iwscga6I024j4bg91wP2p0Thg/F4dZ
	 V0X3MEEp5IDiaIFo1QaWRMI2KrHS9iNGYKHWYFcWV1i6rk/haR0dJHXg0HYF5GBSAng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sAahtSaFaWk/SYcYGjyqpYNSHUc0G5C0JsbrOsNcHQ4=;
	b=zd4wQzI7R79KZAOEDsCZ+BBSzmgcS5dCd/Fjig9qFLCEEHda6PostPlFpjMietYf/BCy
	 D8sxqrSgMPUVAyHmnI7kQbpmfWWT9OxdeBPd0wbMRUZEVATB5aTTfFVMaxoN5ClGztiJC
	 VyE1I1679eHQHCtU7+JOYPBV0kUXsdawhAYPjB0NwsClqLXUAM/tBlRJoVjSyTLpCy2vE
	 GxabZ99WFzzlrkRSELfBUDiZgPQNdHLz6P9cMoCjFFPHgIDRW8qeQtBOh09NKlQCW7nhq
	 RgKKfzIcDamtPVqwXix0wJSousTecqD0Q/cgwmGJi3KM48jfr7M0dVNhck4TC2shwTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6BhAbez;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1F2606C086;
	Fri, 13 Nov 2026 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6BhAbez
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFE41F000C4;
	Fri, 13 Nov 2026 17:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590073;
	bh=sAahtSaFaWk/SYcYGjyqpYNSHUc0G5C0JsbrOsNcHQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6BhAbezQwiGYu8Y+D9wg9CWD3jW3lUqnq08oFivnAhoPt+HxfUXEUIULLNUk5gK2
	 duXx6VrUjzu9/06Beq98YLmSSdCmQ2IRfeYRxBsINVpkkpwY3WWjiklsMMxjjhj4Ry
	 Xg4yjPgwlYUMbeAmaKPYdZpF9R+wWdmGszG5IvJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/686] mkiss: size the frame buffers for worst-case KISS escaping
Date: Fri, 13 Nov 2026 10:43:57 -0500
Message-ID: <20261113153824.382885906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

ax_encaps() accepts a frame for transmission as long as it is not
longer than dev->mtu + 73 bytes, and KISS escaping can double every
byte of it (END and ESC are each sent as two bytes). The transmit
buffer, however, is only max(2 * dev->mtu, 1152) + 4 bytes long, so the
73 bytes of header allowance are not covered once they are doubled.

With the default MTU of 236 the 1152 byte floor hides the problem. As
soon as the MTU is raised above 502, a maximum length frame made of END
or ESC bytes makes kiss_esc() or kiss_esc_crc() write up to 148 bytes
past the end of xbuff. The content of the frame does not have to come
from the local machine: it can be traffic forwarded for another
station, a routed IP datagram for instance.

Reproduced under KASAN on 6.12.94 with the MTU set to 1024 and a
1097 byte UI frame whose payload is all 0xC0:

  BUG: KASAN: slab-out-of-bounds in kiss_esc+0x316/0x390 [mkiss]
  Write of size 1 at addr ffff888001c9c804 by task init/1
   kiss_esc+0x316/0x390 [mkiss]
   ax_xmit+0x346/0xcd5 [mkiss]
   dev_hard_start_xmit+0xf8/0x580
   sch_direct_xmit+0x131/0xa10
   __dev_queue_xmit+0x27f6/0x34b0
   packet_sendmsg+0x30c5/0x4a10
  The buggy address is located 0 bytes to the right of
   allocated 2052-byte region [ffff888001c9c000, ffff888001c9c804)

In addition the driver sets no upper bound on the MTU. An MTU of 2^30
or more makes "dev->mtu * 2" negative, which leaves the buffers at
their minimum size while the length check in ax_encaps() no longer
rejects anything.

Compute the buffer length in one place, from the largest frame that
ax_encaps() accepts, and allocate six more bytes for the two END
delimiters and the two CRC bytes, which may need escaping too. Set
max_mtu so that the computation cannot overflow.

With the change the same test produces no KASAN report, the frames
found on the serial line are identical to those sent, with and without
CRC (SMACK and FlexNet), and an MTU above 65535 is refused.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 1d80a1c3a4591b20182a8adb3bcb0427f85331a5)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/mkiss.c | 49 ++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 5f38a002bd9e3..05c7a234de6ca 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -30,6 +30,7 @@
 #include <net/ax25.h>
 
 #define AX_MTU		236
+#define AX_MAX_MTU	65535
 
 /* some arch define END as assembly function ending, just undef it */
 #undef	END
@@ -355,13 +356,19 @@ static int ax_set_mac_address(struct net_device *dev, void *addr)
 
 /*---------------------------------------------------------------------------*/
 
-static void ax_changedmtu(struct mkiss *ax)
-{
-	struct net_device *dev = ax->dev;
-	unsigned char *xbuff, *rbuff, *oxbuff, *orbuff;
-	int len;
+/*
+ * Length of the frame buffers for the current MTU.
+ *
+ * ax_encaps() accepts frames of up to dev->mtu + 73 bytes and KISS escaping
+ * can double every one of them.  The buffers are allocated AX_BUF_SLACK bytes
+ * larger than this, for the two END delimiters and the two CRC bytes, which
+ * can need escaping as well.
+ */
+#define AX_BUF_SLACK	6
 
-	len = dev->mtu * 2;
+static int ax_buflen(const struct net_device *dev)
+{
+	int len = (dev->mtu + 73) * 2;
 
 	/*
 	 * allow for arrival of larger UDP packets, even if we say not to
@@ -371,8 +378,19 @@ static void ax_changedmtu(struct mkiss *ax)
 	if (len < 576 * 2)
 		len = 576 * 2;
 
-	xbuff = kmalloc(len + 4, GFP_ATOMIC);
-	rbuff = kmalloc(len + 4, GFP_ATOMIC);
+	return len;
+}
+
+static void ax_changedmtu(struct mkiss *ax)
+{
+	struct net_device *dev = ax->dev;
+	unsigned char *xbuff, *rbuff, *oxbuff, *orbuff;
+	int len;
+
+	len = ax_buflen(dev);
+
+	xbuff = kmalloc(len + AX_BUF_SLACK, GFP_ATOMIC);
+	rbuff = kmalloc(len + AX_BUF_SLACK, GFP_ATOMIC);
 
 	if (xbuff == NULL || rbuff == NULL)  {
 		printk(KERN_ERR "mkiss: %s: unable to grow ax25 buffers, "
@@ -581,20 +599,12 @@ static int ax_open(struct net_device *dev)
 	 * rbuff	Receive buffer.
 	 * xbuff	Transmit buffer.
 	 */
-	len = dev->mtu * 2;
-
-	/*
-	 * allow for arrival of larger UDP packets, even if we say not to
-	 * also fixes a bug in which SunOS sends 512-byte packets even with
-	 * an MSS of 128
-	 */
-	if (len < 576 * 2)
-		len = 576 * 2;
+	len = ax_buflen(dev);
 
-	if ((ax->rbuff = kmalloc(len + 4, GFP_KERNEL)) == NULL)
+	if ((ax->rbuff = kmalloc(len + AX_BUF_SLACK, GFP_KERNEL)) == NULL)
 		goto norbuff;
 
-	if ((ax->xbuff = kmalloc(len + 4, GFP_KERNEL)) == NULL)
+	if ((ax->xbuff = kmalloc(len + AX_BUF_SLACK, GFP_KERNEL)) == NULL)
 		goto noxbuff;
 
 	ax->mtu	     = dev->mtu + 73;
@@ -640,6 +650,7 @@ static void ax_setup(struct net_device *dev)
 {
 	/* Finish setting up the DEVICE info. */
 	dev->mtu             = AX_MTU;
+	dev->max_mtu         = AX_MAX_MTU;
 	dev->hard_header_len = AX25_MAX_HEADER_LEN;
 	dev->addr_len        = AX25_ADDR_LEN;
 	dev->type            = ARPHRD_AX25;
-- 
2.53.0



