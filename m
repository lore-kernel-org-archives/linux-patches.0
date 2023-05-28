Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0737611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0A5C433EF;
	Sun, 28 May 2023 19:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301441;
	bh=pzrIXfi7gV7ykgOMQStKn2hAyn6kw7nxxYZ9R2tI8qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6okCUJkv3eT530BtSoSiGQDkd6gjXai6ZC4KlNbBd8qUqgdphpt71hShOLJXpkCY
	 1ia5H/+5Lf7Kw9RvrWVKwLIuXgdlp0Mynamq7oomsGYLJCXTG0EqxclmRGL/HX7Cux
	 +ZLLWd38zhdAVXHgI1c92lcY+8ijpaTgCo2VT4hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/132] wifi: iwlwifi: dvm: Fix memcpy: detected field-spanning write backtrace
Date: Sun, 28 May 2023 20:09:30 +0100
Message-Id: <20230528190834.532433504@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ef16799640865f937719f0771c93be5dca18adc6 ]

A received TKIP key may be up to 32 bytes because it may contain
MIC rx/tx keys too. These are not used by iwl and copying these
over overflows the iwl_keyinfo.key field.

Add a check to not copy more data to iwl_keyinfo.key then will fit.

This fixes backtraces like this one:

 memcpy: detected field-spanning write (size 32) of single field "sta_cmd.key.key" at drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1103 (size 16)
 WARNING: CPU: 1 PID: 946 at drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1103 iwlagn_send_sta_key+0x375/0x390 [iwldvm]
 <snip>
 Hardware name: Dell Inc. Latitude E6430/0H3MT5, BIOS A21 05/08/2017
 RIP: 0010:iwlagn_send_sta_key+0x375/0x390 [iwldvm]
 <snip>
 Call Trace:
  <TASK>
  iwl_set_dynamic_key+0x1f0/0x220 [iwldvm]
  iwlagn_mac_set_key+0x1e4/0x280 [iwldvm]
  drv_set_key+0xa4/0x1b0 [mac80211]
  ieee80211_key_enable_hw_accel+0xa8/0x2d0 [mac80211]
  ieee80211_key_replace+0x22d/0x8e0 [mac80211]
 <snip>

Link: https://www.alionet.org/index.php?topic=1469.0
Link: https://lore.kernel.org/linux-wireless/20230218191056.never.374-kees@kernel.org/
Link: https://lore.kernel.org/linux-wireless/68760035-7f75-1b23-e355-bfb758a87d83@redhat.com/
Cc: Kees Cook <keescook@chromium.org>
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index de6ec9b7ace45..f30bac02d32ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -1101,6 +1101,7 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
 {
 	__le16 key_flags;
 	struct iwl_addsta_cmd sta_cmd;
+	size_t to_copy;
 	int i;
 
 	spin_lock_bh(&priv->sta_lock);
@@ -1120,7 +1121,9 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
 		sta_cmd.key.tkip_rx_tsc_byte2 = tkip_iv32;
 		for (i = 0; i < 5; i++)
 			sta_cmd.key.tkip_rx_ttak[i] = cpu_to_le16(tkip_p1k[i]);
-		memcpy(sta_cmd.key.key, keyconf->key, keyconf->keylen);
+		/* keyconf may contain MIC rx/tx keys which iwl does not use */
+		to_copy = min_t(size_t, sizeof(sta_cmd.key.key), keyconf->keylen);
+		memcpy(sta_cmd.key.key, keyconf->key, to_copy);
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
-- 
2.39.2



