Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20894132111;
	Wed,  5 Feb 2025 13:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763365; cv=none; b=um58Jsu9KQhczWo5XQZohN5A00S22bAmNJuK0Jn2ocRn4ZsfiS/DNkLycm/4CRvpuIxO/ckZqcC1YfA/0m6OF9KuvGNUFaFyz0Gmg3MLMyXNZi4gg/JfQyu+eJoiUQva3ZXWoxYsG0kbZjjpSuY14SqhdGBf3fTylgAr5jVFzVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763365; c=relaxed/simple;
	bh=IYWHa2dEJHV+vlKLIVxBFyp7UeTvCdwSyXSmwDFvNJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1HUmjRbmwq/CaMjmpkQ9XwbQEJyHIPz10X/UOrQxwtBPAZmy38dptQNmWfmVMUur1+BL+3RbfdZtixsGsxXr5ZWXOA2Nx1Jl1t1CldixGzhNXOQV8DMH9n+I3VDChDZRo6/JRMclgckyV9ArEWdqfjv/T+VlHsSH9ZJJWCF1uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ig3XbCZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ig3XbCZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DD4C4CED1;
	Wed,  5 Feb 2025 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763365;
	bh=IYWHa2dEJHV+vlKLIVxBFyp7UeTvCdwSyXSmwDFvNJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ig3XbCZuFIvvZ+nFI04IoHjWaL7aO3sM/6FXIUgVaUEgkuvfSzSYmvwOPKH5AhGRy
	 kWJuI7WoTk1XJV2R7ZNW8t/kD51wz6+4tB2F58YljfGJwYg8Pw3WEt5jRfxZuvtXYQ
	 A4eV8S/UO8svNgew0LjdeG32cm356FYDCTtcklLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/393] wifi: rtlwifi: fix init_sw_vars leak when probe fails
Date: Wed,  5 Feb 2025 14:39:31 +0100
Message-ID: <20250205134422.291377947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e2948732a16cb..0a934adcef012 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1063,6 +1063,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 
 error_init_vars:
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
+	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
 	rtl_deinit_core(hw);
 error_out2:
-- 
2.39.5



