Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA4630B517;
	Mon, 17 Aug 2026 14:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976564; cv=none; b=nhG7ZImR0whi7lPwXZCcQa4QbthM2WoZvBGijtFJFbKgkbNRRu55vf2v9cnJgN728xIoRJUUNA/Z3B5mHzEKa5YoTt8wfnp2KpArKoEjAESDlG9rZ00u8VU8jZxwEuRyAMtTUSlO+1svnhQnFVfidyRhE0zepjJG0XmvVwGfBBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976564; c=relaxed/simple;
	bh=75JY6Gf3QPoTR9PqZOhUiQKhbkHQrjT3iiJQooLnBCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgLBCXTQPTXTWnCe2Zd4+3js1jpslhcM6ziMTCelsBjEMTQvKBSkhLjB93ph2kDVOy3Rv1gDJvrHC83T1A+Ixo7s44wDmic4KyaiRzj0S4VKmBZpk0wgEdFHo+cGZhJKBKRakoAMIxthxKiXfV3K+nSAzKpyZOnWJ9pv8N8t2eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUnvnaRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUnvnaRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3AD1F000E9;
	Mon, 17 Aug 2026 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976562;
	bh=XaWli9XDZFX7dMdvrgEaJLCs4IF8ZRP1CwxnXG+gl+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUnvnaRZm4xKUArVbK7ZC6AobxHDWCm3wWCJ2baia4qU1eARnPb92I2E5kDePkwWs
	 uVx27zUrALzRn2xFRxJQ7EotbfWRMHkj8XyZMVpopwRJvS0VzHbs5x+tDLPbjPtmpL
	 9VW4fl0Lu1mJYbouWfoop6amwW1LZ7jtw0QynZjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Christian Lamparter <chunkeey@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/456] wifi: p54: validate RX frame length in p54_rx_eeprom_readback()
Date: Mon, 17 Aug 2026 15:26:57 +0200
Message-ID: <20260817132541.052397003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6333b1000f925b..303badbd53d9b0 100644
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -503,11 +503,19 @@ static void p54_rx_eeprom_readback(struct p54_common *priv,
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



