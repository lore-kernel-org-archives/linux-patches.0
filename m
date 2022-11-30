Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B1A79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9854C433D7;
	Wed, 30 Nov 2022 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833705;
	bh=e8tnRs15Y28gGNcWCugC3TKLZtItPij/5J1CUwYWG34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1ZyKV2iLLJgbGCmt6QSqilb7JhV09lYlfm4g6fMDS7aI3YASU4YInMSADHPdQ6Z1
	 ++jls41pGGqF7CtHY/JNfcT/gsLkjmXhx3dlP4SdwYmNt2ufJHBN8vdpkiW+H0An/f
	 HhDfT5UQrRLHjTLPq4eT35+IpjqUu8W1ueadds/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Turnbull <philipturnbull@github.com>,
	Ajay Kathat <ajay.kathat@microchip.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 190/206] wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_CHANNEL_LIST attribute
Date: Wed, 30 Nov 2022 19:24:02 +0100
Message-Id: <20221130180537.850389531@linuxfoundation.org>
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

commit f9b62f9843c7b0afdaecabbcebf1dbba18599408 upstream.

Validate that the IEEE80211_P2P_ATTR_CHANNEL_LIST attribute contains
enough space for a 'struct wilc_attr_oper_ch'. If the attribute is too
small then it can trigger an out-of-bounds write later in the function.

'struct wilc_attr_oper_ch' is variable sized so also check 'attr_len'
does not extend beyond the end of 'buf'.

Signed-off-by: Phil Turnbull <philipturnbull@github.com>
Tested-by: Ajay Kathat <ajay.kathat@microchip.com>
Acked-by: Ajay Kathat <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221123153543.8568-4-philipturnbull@github.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -947,7 +947,8 @@ static inline void wilc_wfi_cfg_parse_ch
 		if (index + sizeof(*e) + attr_size > len)
 			return;
 
-		if (e->attr_type == IEEE80211_P2P_ATTR_CHANNEL_LIST)
+		if (e->attr_type == IEEE80211_P2P_ATTR_CHANNEL_LIST &&
+		    attr_size >= (sizeof(struct wilc_attr_ch_list) - sizeof(*e)))
 			ch_list_idx = index;
 		else if (e->attr_type == IEEE80211_P2P_ATTR_OPER_CHANNEL &&
 			 attr_size == (sizeof(struct wilc_attr_oper_ch) - sizeof(*e)))


