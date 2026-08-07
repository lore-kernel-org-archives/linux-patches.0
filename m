Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1163438B9;
	Fri,  7 Aug 2026 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115196; cv=none; b=iFQ9hAN48Xau4EAV+XR6qf7p427A1u22Iyy3+ErthiA44eHamoosNNgjjcyA64d0eLvFPxGluyBmYcj3NNQkWB5/59PDGRCUDRNpBX2rGJRhQi2ns1rYJFpxqCYG9Ta5NS1sTAz0h79XtvuElOJ8aH8uTAE1uNHyrFljiJQWZ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115196; c=relaxed/simple;
	bh=fSdo6PmW9G7t+3XkMqeECo2b+cgzU5vxh6CB4idgZaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcRhdQZAkI27/BcssNasdfQ9fd1imE0IOj6hL5GZL+H/4CWGbgonojYj501FI6afZqhnbDdvlA9Xdz+kvG0EWLSTKGxc+XCx8e2cSaJ7vOLWQmMrlCvnZPnB/wnK371CuqFKFhDHQDVP+VnHh0M5HIXuc4GrUYVvCQ3m0IEb1L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bInUhTIO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bInUhTIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EC91F000E9;
	Fri,  7 Aug 2026 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115194;
	bh=kXCd7J9gKHhUba4WMgapJCxdSJxVHyk/sL3WQO+v6l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bInUhTIOM+U1YOf64UdnNuO83jUjg2gdXp7a0uXiBPCt+WTJNtpLVhNuwP8kN+cX5
	 Jki1lx6sWgpPgsQSIYbWNikg13vUjq4YFY1m5qREEAlJldUOWeono6CxtSgNGzsQpX
	 x/83I4bbpYt3Em5Hp3nP6KMIgCIEWBTfH9lGh18Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/396] net: libwx: fix FDIR ATR queue mismatch for software VLAN packets
Date: Fri,  7 Aug 2026 16:35:07 +0200
Message-ID: <20260807143427.481058514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 732ed8f75ce583d115716f668dc80d730f3ad610 ]

When TX VLAN hardware offload is disabled, VLAN tags are embedded in
the packet payload (software VLAN). Previously, the driver failed to
set the WX_TX_FLAGS_SW_VLAN flag for these packets during transmission.

This missing flag caused the txgbe FDIR ATR logic to fall through to the
default hash calculation path. This resulted in asymmetric hash values
for Tx and Rx flows, preventing return packets from being steered to the
same queue as the transmit packets.

Fix this by detecting software VLANs via eth_type_vlan(skb->protocol)
and setting WX_TX_FLAGS_SW_VLAN. This ensures the ATR feature selects
the correct hashing algorithm to maintain Tx/Rx queue symmetry.

Fixes: b501d261a5b3 ("net: txgbe: add FDIR ATR support")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/0879DA38A8E32701+20260724074657.10773-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 678dce480f156..380edc64e45e4 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1549,6 +1549,8 @@ static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
 	if (skb_vlan_tag_present(skb)) {
 		tx_flags |= skb_vlan_tag_get(skb) << WX_TX_FLAGS_VLAN_SHIFT;
 		tx_flags |= WX_TX_FLAGS_HW_VLAN;
+	} else if (eth_type_vlan(skb->protocol)) {
+		tx_flags |= WX_TX_FLAGS_SW_VLAN;
 	}
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-- 
2.53.0



