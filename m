Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2560B1DFD98;
	Wed, 19 Feb 2025 09:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956021; cv=none; b=C9yMk5z59ZruUwfnK2lfeo+8nnxESPABPecQWZZhJ6LhKC/Z8FhYqFy5oQvypNz6B2KiAOEvjgi3zy11G/XPqGuJ+taWDWi+1yoFAaJgVrzcvkvfeW4BURZ8lbpmd5fEKlzqHI7iyWRyfwZER9+Bm7ZQ2FIDE9IbPobVV+3N2ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956021; c=relaxed/simple;
	bh=M9mF09UZaoJ3YJ+ZqiAynFoa6COc3JEXAM2Kg9z/wTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RURGWxE6rN7Guhd5Re8AtRq9M8rmA6i7KSCsMAlELRZk3Gtuh6JTK5G5RLX+SgwgVMusL6MJnx2HoJoXgBF7d6J0/c7U6PBstBnpxIw+UJsp/zoCpjQNIeYCFo/6YTraG3/laRTHq4Y38kdQH6+DUHalI2+EAyBPSWMj51yglcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TASEJ8K5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TASEJ8K5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC42C4CED1;
	Wed, 19 Feb 2025 09:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956021;
	bh=M9mF09UZaoJ3YJ+ZqiAynFoa6COc3JEXAM2Kg9z/wTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TASEJ8K5t+VESwmGwkwlie6a0AqhnJirVDrhfUAG3nfeysXV3mhZusrlBXWyDK92v
	 bG3CEziRD+tyMZkv7dyTKIJpVgb9i7Y+mQe2F5bf/H6ttIDNgS+Lf7lExxlBnZOf5T
	 I1Uz4guc2EnedGKYFlzSDawAPZjqGPKUAfHKmVQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/578] wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step
Date: Wed, 19 Feb 2025 09:20:41 +0100
Message-ID: <20250219082654.354264130@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



