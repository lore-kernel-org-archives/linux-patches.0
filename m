Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B7B26E158;
	Tue, 11 Nov 2025 01:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825386; cv=none; b=PLSpRV/nlGAp5N0K3+QcYg1QsdbHgLPJJ4JZSSZ/vCMVNCmTXpba3itOMNSD/VH4Abo4M+QSHBONj4jx7lsXA8CZ+XLX8UpUTvSXb+Vz3jzEh+BJ/ga2yzxnotbiQSdksQ5Jut0UCro9i+EdKCuT7SYXHmzLwSaUuY8JZi6Q1o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825386; c=relaxed/simple;
	bh=Yc1+suwgxImf7lazx5u78wKoBwsOAhuoGZMjCeiTt8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdGGqT2zw8GkkknQ8VNohhnJRPBGKEWzSWO6KmyEVg6RFEMBhVKEfaeB06rgQpj/M32+c3M4Xal7yvXsUEVB7MhEbqLT6kF5jUbFv59TPt1jTIPOg9IEdVkAMH55k1n0oimE/UoEfDYXxVBbPQE3kqx0pIJnhXulpqmQYyIvUAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kw3u9onF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kw3u9onF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31218C113D0;
	Tue, 11 Nov 2025 01:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825386;
	bh=Yc1+suwgxImf7lazx5u78wKoBwsOAhuoGZMjCeiTt8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kw3u9onF310CMPAVZj3SmXjUu+MA9xwgBXXgxXnfI+EOgdViqrpirQ4KGO9CgnmV9
	 4u/Go1KatNqOeOMr7UYY2fAVRSVMYFB+I3WMibtPf7WxpVkqEO2g4VcYzHOZcKcK4Z
	 GNywrWwjxDfaj+tRPPNOyb7gOgiZO/NfSufOFX1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qendrim Maxhuni <qendrim.maxhuni@garderos.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 780/849] net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup
Date: Tue, 11 Nov 2025 09:45:50 +0900
Message-ID: <20251111004555.285842327@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 11352d85475ae..3a4985b582cb1 100644
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



