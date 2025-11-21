Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8969C34D4C2;
	Fri, 21 Nov 2025 13:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733195; cv=none; b=XmTp2xG3y+ACAropehmfPs4C7hLMulgRZG6YeHUcYQEfJgJsa6885Sya1RPLh+RZts5crfQs4Ne3kvzM906AYcKrvWBUchryBgtj4YqoTP2NhiytoOs1KxWF+UTpLF5Gpq57kNTkBviR8te6ah2FFNb218mIVKyOcBS0LcmrH8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733195; c=relaxed/simple;
	bh=wkyvTf3u6Wz4hAgdM5jcoWRbD0EQxc8lDN35CRltYdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+M4qCRY1kH5khtaAKTaX3KB1rQNzjBl/sCN/na5pPXzZIRNyy2xGg7c3LgfgEIr/o129uPCNTmGuZCIG6A72HPrwoCQffcYCBQr2/ujuJplwEZHLXAKXJZujpQXUAWwvFlezGKs0TLhP/m7U8hzn/t+M6OyclshkPSqk3Zhf3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/oTmrYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/oTmrYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB21FC4CEF1;
	Fri, 21 Nov 2025 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733195;
	bh=wkyvTf3u6Wz4hAgdM5jcoWRbD0EQxc8lDN35CRltYdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/oTmrYutL+1VHVLqwGBS2F7UaJJs+BCORcXWeoRZm7pmdmwnQNzHx1I2dIxgiYWV
	 FveKGo4dQts8aO/5nScVUY482p3OCuamJctEms7sxjv5TvWV0Q1HbWzp0iiV5MRJJE
	 JRC0ndf0bk2qbf1z/53zGGH6uWW+D2cqOSzDSASM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qendrim Maxhuni <qendrim.maxhuni@garderos.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/529] net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup
Date: Fri, 21 Nov 2025 14:10:50 +0100
Message-ID: <20251121130243.519755003@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qendrim Maxhuni <qendrim.maxhuni@garderos.com>

[ Upstream commit e120f46768d98151ece8756ebd688b0e43dc8b29 ]

Raw IP packets have no MAC header, leaving skb->mac_header uninitialized.
This can trigger kernel panics on ARM64 when xfrm or other subsystems
access the offset due to strict alignment checks.

Initialize the MAC header to prevent such crashes.

This can trigger kernel panics on ARM when running IPsec over the
qmimux0 interface.

Example trace:

    Internal error: Oops: 000000009600004f [#1] SMP
    CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.34-gbe78e49cb433 #1
    Hardware name: LS1028A RDB Board (DT)
    pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
    pc : xfrm_input+0xde8/0x1318
    lr : xfrm_input+0x61c/0x1318
    sp : ffff800080003b20
    Call trace:
     xfrm_input+0xde8/0x1318
     xfrm6_rcv+0x38/0x44
     xfrm6_esp_rcv+0x48/0xa8
     ip6_protocol_deliver_rcu+0x94/0x4b0
     ip6_input_finish+0x44/0x70
     ip6_input+0x44/0xc0
     ipv6_rcv+0x6c/0x114
     __netif_receive_skb_one_core+0x5c/0x8c
     __netif_receive_skb+0x18/0x60
     process_backlog+0x78/0x17c
     __napi_poll+0x38/0x180
     net_rx_action+0x168/0x2f0

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Signed-off-by: Qendrim Maxhuni <qendrim.maxhuni@garderos.com>
Link: https://patch.msgid.link/20251029075744.105113-1-qendrim.maxhuni@garderos.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index eba755b584a45..73df808978b20 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -192,6 +192,12 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		if (!skbn)
 			return 0;
 
+	       /* Raw IP packets don't have a MAC header, but other subsystems
+		* (like xfrm) may still access MAC header offsets, so they must
+		* be initialized.
+		*/
+		skb_reset_mac_header(skbn);
+
 		switch (skb->data[offset + qmimux_hdr_sz] & 0xf0) {
 		case 0x40:
 			skbn->protocol = htons(ETH_P_IP);
-- 
2.51.0



