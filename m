Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDCC8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81C4C433C8;
	Sun, 16 Jul 2023 19:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537468;
	bh=5dAIn7Nr+d7M9/hyO4N8LiqjnNv8Yzt4wctCtt/euJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLxDa4OhMa2wKF8KVd5b76DCJxBy4Hlln8ZeH6TkIlAogoER9WLTG/jDYQR31tluB
	 Ead+e8FOSMW/QZmmXulNLv6tbQ9Cgw50BhvY6xiik0AOA4HeECqkWS+adgAQ4OnDN6
	 4DEsSHn6lheQ39K8j5IIU/CU9OiskU61aKrbu5pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
Subject: [PATCH 6.4 106/800] wifi: ath9k: avoid referencing uninit memory in ath9k_wmi_ctrl_rx
Date: Sun, 16 Jul 2023 21:39:19 +0200
Message-ID: <20230716194951.575786311@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit f24292e827088bba8de7158501ac25a59b064953 ]

For the reasons also described in commit b383e8abed41 ("wifi: ath9k: avoid
uninit memory read in ath9k_htc_rx_msg()"), ath9k_htc_rx_msg() should
validate pkt_len before accessing the SKB.

For example, the obtained SKB may have been badly constructed with
pkt_len = 8. In this case, the SKB can only contain a valid htc_frame_hdr
but after being processed in ath9k_htc_rx_msg() and passed to
ath9k_wmi_ctrl_rx() endpoint RX handler, it is expected to have a WMI
command header which should be located inside its data payload.

Implement sanity checking inside ath9k_wmi_ctrl_rx(). Otherwise, uninit
memory can be referenced.

Tested on Qualcomm Atheros Communications AR9271 802.11n .

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230424183348.111355-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 19345b8f7bfd5..d652c647d56b5 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -221,6 +221,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	if (unlikely(wmi->stopped))
 		goto free_skb;
 
+	/* Validate the obtained SKB. */
+	if (unlikely(skb->len < sizeof(struct wmi_cmd_hdr)))
+		goto free_skb;
+
 	hdr = (struct wmi_cmd_hdr *) skb->data;
 	cmd_id = be16_to_cpu(hdr->command_id);
 
-- 
2.39.2



