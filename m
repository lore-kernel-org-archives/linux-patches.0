Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15EE30FA4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22665C433C9;
	Wed, 20 Sep 2023 12:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212421;
	bh=hVVyI+FR7oT75Irs9BSvWIZQAqWdO8pJMy5cL88k/Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smFWaEOYVlvxicf1YKCkvy4Z+kwKdeuiACUYnadpeMe61btBzO3zK2dIGVrtUqtRo
	 JBvggGx/s0zoOc2DkBf+ONSWC4DX6DmqjN16Np7UPdcnwUg0GzGv/saGBBlkmsXFdf
	 55TbVJSUqxCfsPUFmGmWILjVISjIyw4t/9W1lz9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/273] wifi: mwifiex: fix fortify warning
Date: Wed, 20 Sep 2023 13:31:23 +0200
Message-ID: <20230920112853.843876541@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit dcce94b80a954a8968ff29fafcfb066d6197fa9a ]

When compiling with gcc 13.1 and CONFIG_FORTIFY_SOURCE=y,
I've noticed the following:

In function ‘fortify_memcpy_chk’,
    inlined from ‘mwifiex_construct_tdls_action_frame’ at drivers/net/wireless/marvell/mwifiex/tdls.c:765:3,
    inlined from ‘mwifiex_send_tdls_action_frame’ at drivers/net/wireless/marvell/mwifiex/tdls.c:856:6:
./include/linux/fortify-string.h:529:25: warning: call to ‘__read_overflow2_field’
declared with attribute warning: detected read beyond size of field (2nd parameter);
maybe use struct_group()? [-Wattribute-warning]
  529 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The compiler actually complains on:

memmove(pos + ETH_ALEN, &mgmt->u.action.category,
	sizeof(mgmt->u.action.u.tdls_discover_resp));

and it happens because the fortification logic interprets this
as an attempt to overread 1-byte 'u.action.category' member of
'struct ieee80211_mgmt'. To silence this warning, it's enough
to pass an address of 'u.action' itself instead of an address
of its first member.

This also fixes an improper usage of 'sizeof()'. Since 'skb' is
extended with 'sizeof(mgmt->u.action.u.tdls_discover_resp) + 1'
bytes (where 1 is actually 'sizeof(mgmt->u.action.category)'),
I assume that the same number of bytes should be copied.

Suggested-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230629085115.180499-2-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index b6b7bbe168ebc..12cfc95f02598 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -737,6 +737,7 @@ mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv,
 	int ret;
 	u16 capab;
 	struct ieee80211_ht_cap *ht_cap;
+	unsigned int extra;
 	u8 radio, *pos;
 
 	capab = priv->curr_bss_params.bss_descriptor.cap_info_bitmap;
@@ -755,7 +756,10 @@ mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv,
 
 	switch (action_code) {
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
-		skb_put(skb, sizeof(mgmt->u.action.u.tdls_discover_resp) + 1);
+		/* See the layout of 'struct ieee80211_mgmt'. */
+		extra = sizeof(mgmt->u.action.u.tdls_discover_resp) +
+			sizeof(mgmt->u.action.category);
+		skb_put(skb, extra);
 		mgmt->u.action.category = WLAN_CATEGORY_PUBLIC;
 		mgmt->u.action.u.tdls_discover_resp.action_code =
 					      WLAN_PUB_ACTION_TDLS_DISCOVER_RES;
@@ -764,8 +768,7 @@ mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv,
 		mgmt->u.action.u.tdls_discover_resp.capability =
 							     cpu_to_le16(capab);
 		/* move back for addr4 */
-		memmove(pos + ETH_ALEN, &mgmt->u.action.category,
-			sizeof(mgmt->u.action.u.tdls_discover_resp));
+		memmove(pos + ETH_ALEN, &mgmt->u.action, extra);
 		/* init address 4 */
 		memcpy(pos, bc_addr, ETH_ALEN);
 
-- 
2.40.1



