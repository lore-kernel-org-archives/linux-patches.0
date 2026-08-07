Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC3746C851;
	Fri,  7 Aug 2026 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117043; cv=none; b=fRVBMWdkwdB3O0unUtS5RRC2CGPUIZptobKSOe/rvh/hjfh8WM7adItle3nFoKV3WNJtk1kmSdM5Ff7XjNyqf6G+GKlnVBxQfVvKGfzpeVxikdVXzNXBz9McjSs4LTJ0m2bxivZp3gZ/FjS5oWh04YR7CWVsQchMOu4Ett7IPo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117043; c=relaxed/simple;
	bh=ldqqvdK8Vz3PTy+OH5IrQgCvK45HjUyIxF5d3KiuiD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTCsM0OuVR8mxhTZAYNdUMSBV/0UG8b9sKwytqlA9vtETQEvl3nidqCRwQAtX+P/W3EGdpuuZ8RQhnfXwb7Gm7cMHRQazftyHdLcxvMtJxMqe7nQqITP3oU/4ocXmw9sRcJFMNyMwpWyiXNf2/0kMmE4XDb2uPsByZI4UkB6DVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2R//0hQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2R//0hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999851F000E9;
	Fri,  7 Aug 2026 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117042;
	bh=qhOEG9vKmCvHQMcMtnhM/6+pzRpeQcW35nhLOlZU5UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2R//0hQA2NYDCFnf/d7thjzxzltwvwEY2r0emZS6zDYCZahGBHRunXBJJgpYh7qP
	 apmfmA6i7f5o/uksdyPd3RHQBMVRrCeTe2pCZb6k8l9Pn30nSS8Xk6uwnhoI4JSEMS
	 3woqOsJvdIpkRySGAsHLr/fSdXKfm2iVfdY1FSPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 181/438] net: libwx: fix FDIR ATR queue mismatch for software VLAN packets
Date: Fri,  7 Aug 2026 16:36:17 +0200
Message-ID: <20260807143431.891186353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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
index 5c2cd5756f8a9..a553365b69943 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1606,6 +1606,8 @@ static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
 	if (skb_vlan_tag_present(skb)) {
 		tx_flags |= skb_vlan_tag_get(skb) << WX_TX_FLAGS_VLAN_SHIFT;
 		tx_flags |= WX_TX_FLAGS_HW_VLAN;
+	} else if (eth_type_vlan(skb->protocol)) {
+		tx_flags |= WX_TX_FLAGS_SW_VLAN;
 	}
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-- 
2.53.0



