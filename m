Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09C8223702;
	Mon, 10 Mar 2025 17:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628665; cv=none; b=uGWSPmBkZqhZTizU2PtWKXqrWNG+pAmi7L3SVSZoFlLZvwWJZZhkVGnoHh+oodDnXZfvWiuQthRCtfw0/rvcWDNHAXIb1ZDtKug3ByrVgTalrpIjHsS45y+ocVixgwbNneP+qbVtlUuhz+rraG+SotcZxwXiKPThlLcgCtdQJEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628665; c=relaxed/simple;
	bh=T5TBNB2KnCy7gIWQPZT0kcfVMtWV+Op0OMXgv394VfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4H+lasgUwnGgbAYto73OR1uM2RZcA3xUTTrYBsMZfFxbmmKsEaIZvFwVuRVNeRplRWxSnWPkbatJpKRhBtrGE8IWsD/2wYsmfY3kT6jUFPLdSD1XgP1DP5KpKJZkHFYZcQ0ZTfrco3Y7ZyYHJvtCWpmEWKruHk1oEoT1RfE6So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHH2zT8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHH2zT8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7FFC4CEF0;
	Mon, 10 Mar 2025 17:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628665;
	bh=T5TBNB2KnCy7gIWQPZT0kcfVMtWV+Op0OMXgv394VfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHH2zT8Ux2k8NQbwPUV0RgydzOOntNPQgBaKJ5wOwmEGuRjUl3Uwc0B/m66Vlq3Lq
	 ss2Uy+tsQcD7vpfcGoIF2aWjSSJYX5Opa2T+HN4M9DhT9NUHegsHrvvr8JhyXYUUdY
	 xaIMzzkOjCDsET2UCnLNPL0W1LdwOmJhoq6KlIxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/620] wifi: rtlwifi: fix init_sw_vars leak when probe fails
Date: Mon, 10 Mar 2025 17:57:53 +0100
Message-ID: <20250310170546.646248038@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 038d9bb652b64..1753eccbefdd9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1082,6 +1082,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 
 error_init_vars:
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
+	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
 	rtl_deinit_core(hw);
 error_out2:
-- 
2.39.5



