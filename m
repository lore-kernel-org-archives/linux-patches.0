Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2545F25E836;
	Tue, 11 Mar 2025 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706433; cv=none; b=GN4OE13AfvCoUoHhQ1vsTmgJ32MIBDlq0dbnbTLkqIbqzxIqcxyY4qIHF1/Xe0fo6QXoT3mBRAakV812iGqbHBRfZRMw/9tf7k/K8YAVXPQ/5kaygFl7l5LN6b0nWakRzQuLeJn3Sqg8yfNXhlazO0jvZRS/Uv3Z51cC9GSDDUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706433; c=relaxed/simple;
	bh=Z2kzIBaGahJzObU+ChHWQQvWwjr8QhsJmyVlpmCm53w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoDbIW2nm7zPM99L29lfeqfpgoLrPu2dZukZadyOB/Rmj7XKLgKKXP9H0nOxa5AIRQcKmQd/mQgIAOfZY9N/6nSd4kEbs4GDQ9oFeLU8RYtNMdgFWcq+2KTG8oTiADEEppdT+0hxX5lykHgpGrqEfSlCqrat3tCUNGDyy1SVZZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyWZ8c0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyWZ8c0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4B4C4CEE9;
	Tue, 11 Mar 2025 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706433;
	bh=Z2kzIBaGahJzObU+ChHWQQvWwjr8QhsJmyVlpmCm53w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyWZ8c0oiDv4GqsHd6JEgK5mfSLIhwT1AZKCzv9ymCYu6O+7lT/9ypcGWAEsriKkC
	 bhpb+1NXWdlkQBXtRpUIPEixoBqFve2uKSuNe3SFwVqDGJ4MV2Bp5qAzSMc33bI3g0
	 tmyrCfebnRp8f83ttkjmW4yop2SnFEOxk/tI97NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/462] wifi: rtlwifi: fix init_sw_vars leak when probe fails
Date: Tue, 11 Mar 2025 15:54:42 +0100
Message-ID: <20250311145758.993102276@linuxfoundation.org>
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

[ Upstream commit 00260350aed80c002df270c805ca443ec9a719a6 ]

If ieee80211_register_hw fails, the memory allocated for the firmware will
not be released. Call deinit_sw_vars as the function that undoes the
allocationes done by init_sw_vars.

Fixes: cefe3dfdb9f5 ("rtl8192cu: Call ieee80211_register_hw from rtl_usb_probe")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-5-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 087e398da36d9..66af56a79dbe5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1081,6 +1081,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 
 error_init_vars:
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
+	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
 	rtl_deinit_core(hw);
 error_out2:
-- 
2.39.5



