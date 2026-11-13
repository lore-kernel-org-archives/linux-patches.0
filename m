Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590941;
	b=1Kb2pHW9EjGYGvULSf+LLS2bPVvU6ZdnqYOGW2QnhtsSVClprEOSNj8mZ/+eygUcNq8F
	 theHrRORQuoUQy4oQqUUO44xaZVUCqMiD8EG+t89gBrpfBYI7jbiNa1PcMEfUbikInKjF
	 7VCRf3L0In2IROSVA/PGXVRkHdalOxOUgeWSc5Qzgu9ntalnJlrzqifENYQ43eJxfQEUo
	 eSGVX5OzInjLrhm/LqyobQe4XmtryksMsg8toHRBiO3iXh8F//a6roznzgWm0t1JHjnmC
	 HnSAhnBUQGlx4WuCELfI5XXJjzzQLyyd5/ZX5lsxsnhH9aes4HIzJvNPRO2r3Zrm0Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OOiBP3FtdVY4NYj3pcI7T/EKhUh1qkyw3OFiE9LiLqI=;
	b=hjLjB2hgNQT8pz8HjVz0kH2cNTDmERa+4BL2tRm99timsphlJKwpxwJ7Uh6nq3AfmflA
	 fS2RFCmmJrsFsGUiPD7J0XXCO/8RrhQdYWkxld+T31dfJaHNfXfKvodO4HHgC9LdwumTE
	 pINgehPjNEfTVFiEwQ6jxnW0Z37RcS2U0OVP1bjry4xN34Zbmh22FUmTTkNr2SpiZB44a
	 xCqYR3Z4/U97GoVOcxeRdFbblPEih0pxZ8xxehW9t6OgPj2MHE11LVt5GuqsHgWnG6HWu
	 zJgJA5V6NG9ZI6tOxWCXHpKH5fU5RfqpgEiCt89DdQy2qAaIlIbYmVswn1aQ7nR6hZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JtnN/Hj/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2268606A8A1;
	Fri, 13 Nov 2026 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JtnN/Hj/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F94C1F000C4;
	Fri, 13 Nov 2026 17:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590941;
	bh=OOiBP3FtdVY4NYj3pcI7T/EKhUh1qkyw3OFiE9LiLqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtnN/Hj/jZip1eI3OQI1gf4o15cK77t7GpVYokfRMTeVlYOf8UBuHtqJ2THToRaM/
	 UVLCJ4S2Ix86jYc4mkYluN121BfnEFDLzaoaL3oKhI8shZXrPBZim9PVTsS+gx4cmm
	 PIEQkNCPaWxPhfwFPPv8rBB+E/4HqLzG2dzWda6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/670] netrom: dont leak frames in nr_route_frame()
Date: Fri, 13 Nov 2026 10:44:49 -0500
Message-ID: <20261113153816.052133153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

nr_route_frame() leaks a frame in two cases.

When the frame comes from AX.25 and nr_add_node() fails, it returns the
error. AX.25 calls it as a protocol function and takes any non-zero
value as "frame consumed", so the frame is never freed. nr_add_node()
fails with -EINVAL when the source of the frame is one of our own
NET/ROM callsigns, which is what a node sees when its own frames come
back through a routing loop, and with -ENOMEM.

When the frame is forwarded, it is sent from a copy, nskb. If
ax25_send_frame() returns NULL (device going down, no memory), it has
not taken the copy, and nr_route_frame() only frees the original.

Return 0 when nr_add_node() fails, so that AX.25 frees the frame, and
free the copy when ax25_send_frame() returns NULL.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS: A
opens an AX.25 link to the NET/ROM callsign of B and sends 400 NET/ROM
frames with A's callsign as source, then 400 with B's own callsign as
source. Live skbs on B (skbuff_head_cache objects, KASAN quarantine
shrunk), 20 s after the last frame:

                    normal source   B's own callsign
  before the fix         12              412
  after the fix          12               12

No kernel report in either run. The second leak (ax25_send_frame()
returning NULL) was checked by reading only.

Fixes: 58bc57471514 ("[AX.25]: Fix unchecked nr_add_node uses.")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 51c59de17ab51364241f4b0bf4399b0f2c5dde5a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 288c4a91ea9b7..821697f222d6a 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -774,11 +774,16 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	nr_dest = (ax25_address *)(skb->data + 7);
 
 	if (ax25 != NULL) {
-		ret = nr_add_node(nr_src, "", &ax25->dest_addr, ax25->digipeat,
-				  ax25->ax25_dev->dev, 0,
-				  READ_ONCE(sysctl_netrom_obsolescence_count_initialiser));
-		if (ret)
-			return ret;
+		/*
+		 * A frame that cannot be noted here (it claims to come from
+		 * one of our own callsigns, or memory is short) is dropped.
+		 * Return 0, not the error: AX.25 takes any other value as
+		 * "frame consumed" and would never free it.
+		 */
+		if (nr_add_node(nr_src, "", &ax25->dest_addr, ax25->digipeat,
+				ax25->ax25_dev->dev, 0,
+				READ_ONCE(sysctl_netrom_obsolescence_count_initialiser)))
+			return 0;
 	}
 
 	if ((dev = nr_dev_get(nr_dest)) != NULL) {	/* Its for me */
@@ -848,8 +853,14 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	spin_unlock_bh(&nr_route_lock);
 	nr_node_put(nr_node);
 
+	/*
+	 * ax25_send_frame() only returns NULL before taking the frame:
+	 * free our copy then; the caller frees the original.
+	 */
 	if (ret)
 		kfree_skb(oskb);
+	else
+		kfree_skb(skb);
 
 	return ret;
 }
-- 
2.53.0



