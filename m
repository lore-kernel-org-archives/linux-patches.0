Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B72679C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE18C433C1;
	Wed, 30 Nov 2022 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833702;
	bh=wUHEcuPhjbOWnsQANITqCK4ALlB8zV71ZDKmna1AaNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jc5URmflp6Yle69BtY6+x0nxi45grKKv7wv4o1x0c6Or1q0BpMTo4+hLfP4MlyTTU
	 lSfZ3ulkDpHPobAIoHamE7+HTFlsrNDH1AjWPpVNe0diy8eqdEaalFB3PpNyKN7kYi
	 sDHZrpP7CH+6dRmf/ZgizvAqmAnmbxrfdW8MYMSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Turnbull <philipturnbull@github.com>,
	Ajay Kathat <ajay.kathat@microchip.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 189/206] wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_OPER_CHANNEL attribute
Date: Wed, 30 Nov 2022 19:24:01 +0100
Message-Id: <20221130180537.825238421@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Phil Turnbull <philipturnbull@github.com>

commit 051ae669e4505abbe05165bebf6be7922de11f41 upstream.

Validate that the IEEE80211_P2P_ATTR_OPER_CHANNEL attribute contains
enough space for a 'struct struct wilc_attr_oper_ch'. If the attribute is
too small then it triggers an out-of-bounds write later in the function.

Signed-off-by: Phil Turnbull <philipturnbull@github.com>
Tested-by: Ajay Kathat <ajay.kathat@microchip.com>
Acked-by: Ajay Kathat <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221123153543.8568-3-philipturnbull@github.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -939,14 +939,24 @@ static inline void wilc_wfi_cfg_parse_ch
 		return;
 
 	while (index + sizeof(*e) <= len) {
+		u16 attr_size;
+
 		e = (struct wilc_attr_entry *)&buf[index];
+		attr_size = le16_to_cpu(e->attr_len);
+
+		if (index + sizeof(*e) + attr_size > len)
+			return;
+
 		if (e->attr_type == IEEE80211_P2P_ATTR_CHANNEL_LIST)
 			ch_list_idx = index;
-		else if (e->attr_type == IEEE80211_P2P_ATTR_OPER_CHANNEL)
+		else if (e->attr_type == IEEE80211_P2P_ATTR_OPER_CHANNEL &&
+			 attr_size == (sizeof(struct wilc_attr_oper_ch) - sizeof(*e)))
 			op_ch_idx = index;
+
 		if (ch_list_idx && op_ch_idx)
 			break;
-		index += le16_to_cpu(e->attr_len) + sizeof(*e);
+
+		index += sizeof(*e) + attr_size;
 	}
 
 	if (ch_list_idx) {


