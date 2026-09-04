Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE2F37DAD0;
	Fri,  4 Sep 2026 06:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502957; cv=none; b=PiSaFks7IZhntinB4XiWZqdOpGs+wYCtYNwChWhgB1/dnhxhpgPUxbVYz/JLKRdkBPN14mMNGnFSflHwMPjF1lDAG7BQ5tTE/Kc3ahhurwiS9cxUUDV3xwkcCiKPeStUzKGRTztt3NqxlH+yOSoSga7QlKTCkAKNYxn0khGowlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502957; c=relaxed/simple;
	bh=imT2EjiOKrbqC8Tgs1vBwkDv3hTc6jhaYI73JnagclU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QquOxHIptrFBPcAIbmJTiiTbd3i9Uo7uNNxJEwFYi6s/Xd+zaX81/XUW+hGGdxCatD2qc6VpU6hFP0Txl2kJdXfcDaoKtqzNeLDgbJY24+RynAfuVt6O+IE/JXt7M5HNeIA0EvIsypyZmd+kUzIWJvDwpFd2u8iZp4AKTHrGl4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXdMcxps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXdMcxps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8D91F00A3D;
	Fri,  4 Sep 2026 06:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502956;
	bh=N2d9UnlEJFFTLnsQVy572cDtaSJyiz5IWp9KfcgohvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXdMcxpsQV1jaK6Iucg5qJsJWxT+OuT2Xlzf0xS84zGJihedAZYQ+kzrfDdoQSjdA
	 dcqcTqjlYKR53e1LwX8Zf0VQaIeYPQTHv+fDUOCy0zWzNNOx5cF8Y7/zNaA+5AF6oY
	 8b4rFFhVTJqN9uMDHvVl9WtRpQzSeXdVqKAYb/YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 389/403] wifi: rtlwifi: rtl8192du: Fix possible memory leak in rtl92du_init_sw_vars()
Date: Fri,  4 Sep 2026 07:03:12 +0200
Message-ID: <20260904045743.634140824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 6496ce90845df2d22fb8e8ed235cd2936fad41c8 upstream.

The memory allocated inside rtl92du_init_shared_data() is not freed in
any of the subsequent error paths in rtl92du_init_sw_vars().
Fix that by adding a call to rtl92du_deinit_shared_data() in the error
path.

Fixes: b5dc8873b6ff ("wifi: rtlwifi: Add rtl8192du/sw.c")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260723114539.136986-1-nihaal@cse.iitm.ac.in
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
@@ -147,8 +147,10 @@ static int rtl92du_init_sw_vars(struct i
 
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = kmalloc(0x8000, GFP_KERNEL);
-	if (!rtlpriv->rtlhal.pfirmware)
-		return -ENOMEM;
+	if (!rtlpriv->rtlhal.pfirmware) {
+		err = -ENOMEM;
+		goto error;
+	}
 
 	rtlpriv->max_fw_size = 0x8000;
 	pr_info("Driver for Realtek RTL8192DU WLAN interface\n");
@@ -162,10 +164,14 @@ static int rtl92du_init_sw_vars(struct i
 		pr_err("Failed to request firmware!\n");
 		kfree(rtlpriv->rtlhal.pfirmware);
 		rtlpriv->rtlhal.pfirmware = NULL;
-		return err;
+		goto error;
 	}
 
 	return 0;
+
+error:
+	rtl92du_deinit_shared_data(hw);
+	return err;
 }
 
 static void rtl92du_deinit_sw_vars(struct ieee80211_hw *hw)


