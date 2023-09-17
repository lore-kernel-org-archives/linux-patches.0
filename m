Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96A96FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE244C433C7;
	Sun, 17 Sep 2023 20:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981808;
	bh=t5glHwnkzYNf+tRWGVe75DJYnyxEruDdfVgx8/qfuQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1hrNa8UOp/ml2vF1YFJ5pJErpAB3rmIHz/cYGDuI9msoXy7Zzwyg8xzxXJfogP4Q
	 1jP+U++nKzMhDCG6Y2ybWsR9rFSs60y40HRIjJ454fHh6N7eQAtpw79bZrbFblEsmO
	 BeZSXyWQTFYIzNmf7OZrGLz4tJpZ484zZ5/A2ow4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Polaris Pi <pinkperfect2021@gmail.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/511] wifi: mwifiex: Fix missed return in oob checks failed path
Date: Sun, 17 Sep 2023 21:08:56 +0200
Message-ID: <20230917191116.491664499@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Polaris Pi <pinkperfect2021@gmail.com>

[ Upstream commit 2785851c627f2db05f9271f7f63661b5dbd95c4c ]

Add missed return in mwifiex_uap_queue_bridged_pkt() and
mwifiex_process_rx_packet().

Fixes: 119585281617 ("wifi: mwifiex: Fix OOB and integer underflow when rx packets")
Signed-off-by: Polaris Pi <pinkperfect2021@gmail.com>
Reported-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230810083911.3725248-1-pinkperfect2021@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_rx.c   | 1 +
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_rx.c b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
index 685a5b6697046..3c555946cb2cc 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
@@ -104,6 +104,7 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 			    skb->len, rx_pkt_off);
 		priv->stats.rx_dropped++;
 		dev_kfree_skb_any(skb);
+		return -1;
 	}
 
 	if ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index b3915bfd38693..d6493638e7028 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -122,6 +122,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 			    skb->len, le16_to_cpu(uap_rx_pd->rx_pkt_offset));
 		priv->stats.rx_dropped++;
 		dev_kfree_skb_any(skb);
+		return;
 	}
 
 	if ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
-- 
2.40.1



