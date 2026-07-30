Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79813C2785;
	Thu, 30 Jul 2026 14:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421305; cv=none; b=O61zUTLXmU/ceaGLDcUIijGBuAUwdlzCJGB1yeYDwdZPODOelELtGuzFMJHCwvY0AxWzBGq9bIPKRZvsNHP+jHzoSqPQ9LWfND3hzQdUdBMSXv1E7ikHUjX9zOygH+KZerbUN1XaSEVIRn7tAkab4xsBK502bdzs/Lhs1f/xzso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421305; c=relaxed/simple;
	bh=0aI71tSDe0GV7swUETt9nkF6yWSqcoKn8rux3mNC1aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HybDu5Tj4tgK3JZemHLSedEXeyngwc/Rt6d3S42yYVPB9BbMVL0LiS4+FW/3cT3pZdwPJ9A9yB3uTSMPCN97nbV3N4LsI8f5GoSPzuzSLCvYaixmHvc90GLdQShK/6G1O04qmZroCBYIYShVU65DWMfBDfj22OwJii39oUSRehI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGpZcaY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGpZcaY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6191F000E9;
	Thu, 30 Jul 2026 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421303;
	bh=rdqIrGOO9HpuA9puu4FppT98eOntOZ/NU7qXsb9n5TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGpZcaY4Zr7MOZ6eFWGEjfni7bqFyvn21Mf6C5Ea9QjF8luEXhWr+E3Ur5WUX1Ib6
	 J+8X86aRtfYTGzInm9EgxAJoBdmZzDwNkQjBDgYbebKGHn8eMnTN5g/RoLvtXtdAQu
	 XCarZGwuwwi9LvakL58O6Av85v1/RhhMentxqv/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Christian Lamparter <chunkeey@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 058/744] wifi: p54: validate RX frame length in p54_rx_eeprom_readback()
Date: Thu, 30 Jul 2026 16:05:31 +0200
Message-ID: <20260730141445.508638886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit ebd6d37fa94bee929e0b4c9ca19fdf9b1dcf6cea ]

p54_rx_eeprom_readback() copies the requested EEPROM slice out of a
device-supplied readback frame without checking that the skb actually holds
that many bytes. Commit da1b9a55ff11 ("wifi: p54: prevent buffer-overflow in
p54_rx_eeprom_readback()") closed the destination overflow by copying a
fixed priv->eeprom_slice_size (and rejecting a mismatched advertised len),
but the source side is still unbounded: nothing verifies the frame is long
enough to supply that many bytes.

A malicious USB device can send a short frame whose advertised len matches
priv->eeprom_slice_size while the payload is truncated. The equality check
passes and memcpy() reads past the end of the skb, leaking adjacent heap:

  BUG: KASAN: slab-out-of-bounds in p54_rx (drivers/net/wireless/intersil/p54/txrx.c:507)
  Read of size 1016 at addr ffff88800f077114 by task swapper/0/0
  Call Trace:
   <IRQ>
   ...
   __asan_memcpy (mm/kasan/shadow.c:105)
   p54_rx (drivers/net/wireless/intersil/p54/txrx.c:507)
   p54u_rx_cb (drivers/net/wireless/intersil/p54/p54usb.c:163)
   __usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1657)
   dummy_timer (drivers/usb/gadget/udc/dummy_hcd.c:2005)
   ...
   </IRQ>

  The buggy address belongs to the object at ffff88800f0770c0
   which belongs to the cache skbuff_small_head of size 704
  The buggy address is located 84 bytes inside of
   allocated 704-byte region [ffff88800f0770c0, ffff88800f077380)

Check that the slice fits in the skb before copying.

Fixes: 7cb770729ba8 ("p54: move eeprom code into common library")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Link: https://patch.msgid.link/20260628000510.4152481-1-xmei5@asu.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intersil/p54/txrx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
index 1294a1d6528e2c..9f491334c8d043 100644
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -499,11 +499,19 @@ static void p54_rx_eeprom_readback(struct p54_common *priv,
 		if (le16_to_cpu(eeprom->v2.len) != priv->eeprom_slice_size)
 			return;
 
+		if (eeprom->v2.data + priv->eeprom_slice_size >
+		    skb_tail_pointer(skb))
+			return;
+
 		memcpy(priv->eeprom, eeprom->v2.data, priv->eeprom_slice_size);
 	} else {
 		if (le16_to_cpu(eeprom->v1.len) != priv->eeprom_slice_size)
 			return;
 
+		if (eeprom->v1.data + priv->eeprom_slice_size >
+		    skb_tail_pointer(skb))
+			return;
+
 		memcpy(priv->eeprom, eeprom->v1.data, priv->eeprom_slice_size);
 	}
 
-- 
2.53.0



