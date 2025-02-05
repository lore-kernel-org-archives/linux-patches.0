Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7ACFC0B;
	Wed,  5 Feb 2025 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764518; cv=none; b=rKs2jKt5ybyt719CJl98kWvA4Ceaa1RQDKjH5M9ejjKWEXjF/kY3SZ0LOZuWaWF6Z21upW/MtEamS5mf4E2yVmXfDsq6j2HYu1qlW2YXGTHpS1bHdSuJjIbQSKyhYRRSuWYhyKBC6JqYLVOyfITeks6/r6X5xqdmNKFsSedb4cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764518; c=relaxed/simple;
	bh=gqcCr5QyGWKOxdDnwRZuhtdlEIBwgLIVL23+qeJUQCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8bvBKEDg0l+Ag292UCW35wu2t9w17zKV8XqJXwb1rFGcfDEGzMixYRXEWPY2MCbTrgociISiLd1amyVEwRG3hS1XY+wbQDyKdfdgOQ/FvmJv8Wj0ckPrg27pInXlu/s/up48Zr6qyA/cHwb03cdzwVm1xSbOBa9PqNQwphYt/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMCSHqj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMCSHqj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197D1C4CED1;
	Wed,  5 Feb 2025 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764518;
	bh=gqcCr5QyGWKOxdDnwRZuhtdlEIBwgLIVL23+qeJUQCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMCSHqj0DPSasFQId9/iZNeFsZz7VUnLU4XNazw0+NLSuzYrABL7MsqspvndJcotM
	 U3bZK6lbOXjugv77kBwnD6EKKQPcSVkYqAh7UNcMkfrYMV2H2/ApdPeD/bEQyHf3VS
	 Abk5gxuf/e6Qhuyj/Aqj5DmXjVF2hK2UKOC7hotw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 087/623] wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step
Date: Wed,  5 Feb 2025 14:37:09 +0100
Message-ID: <20250205134459.553099380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



