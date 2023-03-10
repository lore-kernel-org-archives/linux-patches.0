Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98BD882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277F9C433D2;
	Fri, 10 Mar 2023 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460713;
	bh=aBTK91m/ieuhx9HbMFfXk6la8zJZQZs1D8LBY/VfEW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJVXDMtrMVqmpfmGuHWZU8pQRpgjAveBm9w9/+pFyGf9OimbysFqDO+jZFiUfbqtc
	 Ysil0E8aMwBRkRwQdTHvenZUSlGuDMjFLQ3Nz9aCWvM2Qqfw5PjeEu22ETOcsWbh6K
	 9tDKdKCycudEZYD6oE9gs/riG7joPxPN7jYb7T84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 427/529] wifi: ath9k: use proper statements in conditionals
Date: Fri, 10 Mar 2023 14:39:30 +0100
Message-Id: <20230310133824.757753553@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit b7dc753fe33a707379e2254317794a4dad6c0fe2 upstream.

A previous cleanup patch accidentally broke some conditional
expressions by replacing the safe "do {} while (0)" constructs
with empty macros. gcc points this out when extra warnings
are enabled:

drivers/net/wireless/ath/ath9k/hif_usb.c: In function 'ath9k_skb_queue_complete':
drivers/net/wireless/ath/ath9k/hif_usb.c:251:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
  251 |                         TX_STAT_INC(hif_dev, skb_failed);

Make both sets of macros proper expressions again.

Fixes: d7fc76039b74 ("ath9k: htc: clean up statistics macros")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221215165553.1950307-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/htc.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -327,9 +327,9 @@ static inline struct ath9k_htc_tx_ctl *H
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-#define __STAT_SAFE(hif_dev, expr)	((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
-#define CAB_STAT_INC(priv)		((priv)->debug.tx_stats.cab_queued++)
-#define TX_QSTAT_INC(priv, q)		((priv)->debug.tx_stats.queue_stats[q]++)
+#define __STAT_SAFE(hif_dev, expr)	do { ((hif_dev)->htc_handle->drv_priv ? (expr) : 0); } while (0)
+#define CAB_STAT_INC(priv)		do { ((priv)->debug.tx_stats.cab_queued++); } while (0)
+#define TX_QSTAT_INC(priv, q)		do { ((priv)->debug.tx_stats.queue_stats[q]++); } while (0)
 
 #define TX_STAT_INC(hif_dev, c) \
 		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c++)
@@ -378,10 +378,10 @@ void ath9k_htc_get_et_stats(struct ieee8
 			    struct ethtool_stats *stats, u64 *data);
 #else
 
-#define TX_STAT_INC(hif_dev, c)
-#define TX_STAT_ADD(hif_dev, c, a)
-#define RX_STAT_INC(hif_dev, c)
-#define RX_STAT_ADD(hif_dev, c, a)
+#define TX_STAT_INC(hif_dev, c)		do { } while (0)
+#define TX_STAT_ADD(hif_dev, c, a)	do { } while (0)
+#define RX_STAT_INC(hif_dev, c)		do { } while (0)
+#define RX_STAT_ADD(hif_dev, c, a)	do { } while (0)
 
 #define CAB_STAT_INC(priv)
 #define TX_QSTAT_INC(priv, c)


