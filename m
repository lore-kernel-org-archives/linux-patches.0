Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA0D79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7638C433B5;
	Wed, 30 Nov 2022 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834479;
	bh=Ztmm5tBxVU2YX1xM0/FeB5ZhroqaYvlHtXob7ShX+Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1d1da6zHHC6MGvSIMluvqxx1w2xLVo90+ADrr/oQCKLdDaWxjaTkLbGu8Il4K3pq7
	 PZNTfwqKuWy9Hd91r4nKK/49vp7jzBslF6oS6qu1UIn/8sGfytcFGtABD+cQRXuXFX
	 aaALghuLMjgYz++XGxchdrH9iMRMmSRyl+N9B8Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Turnbull <philipturnbull@github.com>,
	Ajay Kathat <ajay.kathat@microchip.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.0 269/289] wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_CHANNEL_LIST attribute
Date: Wed, 30 Nov 2022 19:24:14 +0100
Message-Id: <20221130180550.196420972@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
@@ -964,7 +964,8 @@ static inline void wilc_wfi_cfg_parse_ch
 		if (index + sizeof(*e) + attr_size > len)
 			return;
 
-		if (e->attr_type == IEEE80211_P2P_ATTR_CHANNEL_LIST)
+		if (e->attr_type == IEEE80211_P2P_ATTR_CHANNEL_LIST &&
+		    attr_size >= (sizeof(struct wilc_attr_ch_list) - sizeof(*e)))
 			ch_list_idx = index;
 		else if (e->attr_type == IEEE80211_P2P_ATTR_OPER_CHANNEL &&
 			 attr_size == (sizeof(struct wilc_attr_oper_ch) - sizeof(*e)))


