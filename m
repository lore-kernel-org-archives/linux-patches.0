Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BCC25F7BD;
	Tue, 11 Mar 2025 15:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706424; cv=none; b=BXT/+1UBd3BetI8aj4UGaUMVtZCcevc5yLgV8yKinBjoYRyR3xtWryvSWov14bFEfQHi5wt78hg8UH3tN9gjEld+FC2iA4HDzzy61FvRTimMl+ePTwuGt4LD/7uOMB+DYgq4GCy24Ugxx2mkqoQbCts+WB8tEsDvakaHuV0rPrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706424; c=relaxed/simple;
	bh=j7QGGTn0ZjmlBmYpdBthIdoiGKqaMW8h+bNZ8Vtnr4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soEo5kIVaCDWcD33XJUjj0mFdNq6avtuOvWCx6fZOZTxZqRd1eBujCtGBqSkPQymNPQwOVcs8o7DY8nnVK6eG2Xh1iZwHn+A+IoOvRO41ecj6cuxTXJHkqxIh4FpVtUbog0WRaS5txLR4qwIrcXfRIkEgZrntupT7Tagt6/JpY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUGZeIik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUGZeIik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1284C4CEED;
	Tue, 11 Mar 2025 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706424;
	bh=j7QGGTn0ZjmlBmYpdBthIdoiGKqaMW8h+bNZ8Vtnr4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUGZeIikiGvirZC/vALwLt5NB1zHAfVcFKqBvHW0+Z49Og1hFCSmDdDKXkpWJHYdJ
	 wprAyItCZoBhdQ9R9n/3wNKYYMseP7pCv/yNl9ThzrQvIke8D+tqdMzFQ8qeXQN2p9
	 zZH6F82pNQjYIyVZxKRzsCb/7R0pCTzcVuNUYHQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/462] wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step
Date: Tue, 11 Mar 2025 15:54:39 +0100
Message-ID: <20250311145758.874085432@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6d352a3161b8f..60d97e73ca28e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -67,22 +67,23 @@ static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
 
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



