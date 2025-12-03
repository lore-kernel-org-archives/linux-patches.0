Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983D631355B;
	Wed,  3 Dec 2025 16:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778032; cv=none; b=HgzHc+TAEgbU1YroaHOikowZPg+3Yn+QiUhJY9B2Ml43wd/73VOLv4VLlQDmipOA7HmxOyARJdmjQeCcR4o6EkBYCCMQtwDBZngXQVwvv0biGaZP1NovA4GDLRYaIAxch40CYsAEjtFJrNCMKeYvWuT+tWv0BDK8IjrfA4Z5Dl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778032; c=relaxed/simple;
	bh=MPPkYaihi0nYClkSqZPBnBHhxa2BJV9WrDyEdzwO4L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZy2taS5p27cWvUs07bMWArmmJe5wRQO8kbfcWM24wO4GhwMExVS2l90kqp1czb3A7U5cAj5bAxr+V7UXhM0aElbk5Ie28FOqLqUDz56cw6jI3xCkFPN3B+mGnm2nYPo0PZAy1i9A9m+0PpB5LxCG/nfPL/6eedSB2Iz2IWsv2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jA9Z2wKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jA9Z2wKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247FFC4CEF5;
	Wed,  3 Dec 2025 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778032;
	bh=MPPkYaihi0nYClkSqZPBnBHhxa2BJV9WrDyEdzwO4L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jA9Z2wKfvWoIzwLRKJh7OIJG2fNjpNX/d6mGdjhZWLYWnmGymewCfHllNIpjsOFAd
	 gqbhnjsk5KZq8kVIuPg5NoDBcHN7D1Mk/0DIRJit0Y1QAxcMELzQtATcjIR5ut6+GV
	 aKuWXtq3ojbr/Fx9adO5mmyck2OTiuefO5upPS9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qendrim Maxhuni <qendrim.maxhuni@garderos.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/392] net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup
Date: Wed,  3 Dec 2025 16:26:12 +0100
Message-ID: <20251203152422.355096392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
index f574de58c1996..bd6d8c2b7e5d9 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -192,6 +192,12 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			return 0;
 		skbn->dev = net;
 
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



