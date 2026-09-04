Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575D73EC6AE;
	Fri,  4 Sep 2026 05:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500204; cv=none; b=sFjHgnIfq94Mdamkm1cHaKRh6K6NP9TBuB6rHg1vYNDhFuvoPjoGAoShbbsfieb34bWFBkdJUaXUpHa2z6XE2qNbieBMHfXbIf3EIxIx+v6vYebGAzzbJ5Y+7TUZEJYCws0lLf+GIQ7HopfGtkaJ/gTR5zV34Pch7xOPD1d3z+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500204; c=relaxed/simple;
	bh=Iw+ia2OnKR/JexBuGliP/LBzdpg5djrfTxuWtaxEImA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU4PmzeX1nWtkwev//BnbG2rnADgrGZ5xGhCZ+oDli6dWLfdvon/O0cRtX4On9qkbpoD76NUbnXJ97uJEF4NBSWHDKCo0AfcSFQpzGShdVloudPsa1q4M5EBP7rfDj57Oz3+fLlDXmQa2MHKbjZ2BNyHiLVzf6p+zSUSq4sYPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fN7IJfuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fN7IJfuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751331F00A3D;
	Fri,  4 Sep 2026 05:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500203;
	bh=RM73ezDd3x+zxZPOg7bAd1rvafgj8Xz4FUrDLLLKdCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fN7IJfuV6f2kxyJLIzMhV2b1eXZKJ9sZ5Qlc90xChLDs1+IM383TCiNeUmvpQmpr/
	 mcX5jJSg0AOZBwvVoQEcxO05pUFkif9cRNMTLFjrp6NAOAgWAgYPkXEjdTbDUuV8d1
	 ChGX11X5gr2N3olN7qHxlFHrE6kl2c5t3ddVU2RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 7.2 688/713] wifi: rtlwifi: rtl8192du: Fix possible memory leak in rtl92du_init_sw_vars()
Date: Fri,  4 Sep 2026 07:00:56 +0200
Message-ID: <20260904045819.263946630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,8 +145,10 @@ static int rtl92du_init_sw_vars(struct i
 
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
@@ -160,10 +162,14 @@ static int rtl92du_init_sw_vars(struct i
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


