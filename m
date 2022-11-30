Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2D179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61424C433D6;
	Wed, 30 Nov 2022 18:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833707;
	bh=cgXQrMsTEYl76HiYtky5TCUyXRmQmGWJY9whWklzyRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcTYjQMB9x6RH9iTMsEpEVKEctTTepElfOYRd1CX8ZCJuCiexWJfwJ4KL0yKfn87H
	 GrhtQbnJEv1rCv1UzOh9XwzzuMejFybIJFv2rUjpQAwBtkcG9S+ISLnM9aUTE6WmSA
	 pyYQg/Ew5+smSmhpPq8TaWJfPQIDxB8t5zW3FMpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Turnbull <philipturnbull@github.com>,
	Ajay Kathat <ajay.kathat@microchip.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 191/206] wifi: wilc1000: validate number of channels
Date: Wed, 30 Nov 2022 19:24:03 +0100
Message-Id: <20221130180537.875904832@linuxfoundation.org>
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

commit 0cdfa9e6f0915e3d243e2393bfa8a22e12d553b0 upstream.

There is no validation of 'e->no_of_channels' which can trigger an
out-of-bounds write in the following 'memset' call. Validate that the
number of channels does not extends beyond the size of the channel list
element.

Signed-off-by: Phil Turnbull <philipturnbull@github.com>
Tested-by: Ajay Kathat <ajay.kathat@microchip.com>
Acked-by: Ajay Kathat <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221123153543.8568-5-philipturnbull@github.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   23 +++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -961,19 +961,30 @@ static inline void wilc_wfi_cfg_parse_ch
 	}
 
 	if (ch_list_idx) {
-		u16 attr_size;
-		struct wilc_ch_list_elem *e;
-		int i;
+		unsigned int i;
+		u16 elem_size;
 
 		ch_list = (struct wilc_attr_ch_list *)&buf[ch_list_idx];
-		attr_size = le16_to_cpu(ch_list->attr_len);
-		for (i = 0; i < attr_size;) {
+		/* the number of bytes following the final 'elem' member */
+		elem_size = le16_to_cpu(ch_list->attr_len) -
+			(sizeof(*ch_list) - sizeof(struct wilc_attr_entry));
+		for (i = 0; i < elem_size;) {
+			struct wilc_ch_list_elem *e;
+
 			e = (struct wilc_ch_list_elem *)(ch_list->elem + i);
+
+			i += sizeof(*e);
+			if (i > elem_size)
+				break;
+
+			i += e->no_of_channels;
+			if (i > elem_size)
+				break;
+
 			if (e->op_class == WILC_WLAN_OPERATING_CLASS_2_4GHZ) {
 				memset(e->ch_list, sta_ch, e->no_of_channels);
 				break;
 			}
-			i += e->no_of_channels;
 		}
 	}
 


