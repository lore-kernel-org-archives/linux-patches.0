Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106F6432E60;
	Fri,  7 Aug 2026 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114191; cv=none; b=VdoVU7ovQ+EBe4fJgiu8tdAYyKF7RgmCDQuyavq/awNKBQVspuaWcqFCLAZt6n5JIqOHtIVScu0jwMr+XM5BH89doPh1pY83L8H9Rev24WVvdNvY5E7TExAj1Q6enqI5uARS/We0wqwn7URyoV29HoYDoareWuX5+82kUY3U4MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114191; c=relaxed/simple;
	bh=E8GUTYe6gUnlWdMbVOQVcY6WxsAikMcd8EWOgGqFTAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psQszBMTtMjCl6kB/B92NN3KXrogaXvBezN9hRlC6DZS+WPZIhaBEe3XPsNdmju+9cpGOA0W4VrsePHCpWftmsQTVO/tZZR/ReoW4bofIQc2dNkZb2tEUZIY6hgrN01oOZEYQtApj8T5ETut3bWY2k+2csi4EwYheDb5oAp+Eq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIvUUTMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIvUUTMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD6D1F000E9;
	Fri,  7 Aug 2026 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114190;
	bh=3jIUdluz4Kq7Zi/RvFAtNBI8hBIXnjwuchwMn6iAz8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIvUUTMVKFQ8snEwazkFydgR90Ww7JRJf4XbXP6m3tr6n9OUUM/IWuaSS4x5gSMzF
	 jxucsCXq3IOdAOJtF46eMLg7bvqOFcyFXBMUsbW8Zku930pPZwDwIzz6GMn/Xce2Nb
	 6ukouKpgmBoakNeM1I7yA83MiIcBlhe+qY7QBqE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/337] net: libwx: fix FDIR ATR queue mismatch for software VLAN packets
Date: Fri,  7 Aug 2026 16:35:25 +0200
Message-ID: <20260807143421.175202060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4c203f4afd689..3666302e3401b 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1481,6 +1481,8 @@ static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
 	if (skb_vlan_tag_present(skb)) {
 		tx_flags |= skb_vlan_tag_get(skb) << WX_TX_FLAGS_VLAN_SHIFT;
 		tx_flags |= WX_TX_FLAGS_HW_VLAN;
+	} else if (eth_type_vlan(skb->protocol)) {
+		tx_flags |= WX_TX_FLAGS_SW_VLAN;
 	}
 
 	/* record initial flags and protocol */
-- 
2.53.0



