Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BFB14A4E9;
	Wed,  5 Feb 2025 13:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763981; cv=none; b=RhLcOBOpOjp07jU/zqaM3mMAEFKfCceVqzIrV/Bxob3+mL+YKVYfvoeKEiSY2V95kypBW9mV/iwoXNfVCGBOCdzCA/xjU4LjxrbAcIkLFrbqkQV+vF/xOG+UnzqaznkseFdqXYX0feU/UeEdeazwVWC7ghTW4D4+fBTSLPeIolM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763981; c=relaxed/simple;
	bh=bZe1f/lvjUlByHb4hVFe+IL7gAlraaTdcNMtpaqPW4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyqsliqVD2W13u6I+dJ+sbZhZVb5xoZANifXj7nQc3OIKrfrMdybHV8UD89J9zOZC0bc1VD2PJPRfh9iVNaB5ZryhJc2coY6IVQ9oGIiNAyISeAo8ZH9lEHtjj7ULpA+Oq7etEz4OJG1CD4KzVLighGADATANFD3RjTslpurP6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7uItu6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7uItu6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA3AC4CED6;
	Wed,  5 Feb 2025 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763980;
	bh=bZe1f/lvjUlByHb4hVFe+IL7gAlraaTdcNMtpaqPW4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7uItu6zAiLxEhZb3HhxFwpSEp7vvMd5kSqEWM4QvwD//UT395HFD1oV+RkVXL/DP
	 ppDdsUq5lPAtYkkkFGUr7ygg5qtqBM35X+KwUM0S1dn/e1noxjYtncw8Z7aV0hyFjF
	 JcocYESjVuLqBSPwwHWDrXjXvWav/SARQYCuuG9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/590] wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step
Date: Wed,  5 Feb 2025 14:37:13 +0100
Message-ID: <20250205134458.238450874@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 8559a9e0c457729fe3edb3176bbf7c7874f482b0 ]

Just like in commit 4dfde294b979 ("rtlwifi: rise completion at the last
step of firmware callback"), only signal completion once the function is
finished. Otherwise, the module removal waiting for the completion could
free the memory that the callback will still use before returning.

Fixes: b0302aba812b ("rtlwifi: Convert to asynchronous firmware load")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-3-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index bbf8ff63dcedb..e63c67b1861b5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -64,22 +64,23 @@ static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
 
 	rtl_dbg(rtlpriv, COMP_ERR, DBG_LOUD,
 		"Firmware callback routine entered!\n");
-	complete(&rtlpriv->firmware_loading_complete);
 	if (!firmware) {
 		pr_err("Firmware %s not available\n", fw_name);
 		rtlpriv->max_fw_size = 0;
-		return;
+		goto exit;
 	}
 	if (firmware->size > rtlpriv->max_fw_size) {
 		pr_err("Firmware is too big!\n");
 		rtlpriv->max_fw_size = 0;
 		release_firmware(firmware);
-		return;
+		goto exit;
 	}
 	pfirmware = (struct rt_firmware *)rtlpriv->rtlhal.pfirmware;
 	memcpy(pfirmware->sz_fw_tmpbuffer, firmware->data, firmware->size);
 	pfirmware->sz_fw_tmpbufferlen = firmware->size;
 	release_firmware(firmware);
+exit:
+	complete(&rtlpriv->firmware_loading_complete);
 }
 
 static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
-- 
2.39.5



