Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923A014A4E9;
	Wed,  5 Feb 2025 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763994; cv=none; b=lbqANxJiolF1qwhKyVb4Pn1jqJ/Tpty8BJOVRUpduHsHrcQTcr34GRKAdyxQ5tG7Sdum7YER8yRBzOdBBhluwCgmQQanWhRnXbLC7rFFHL4Dj1fETRcfNc76XrqRMjhkuuwRwLiLpdGj8J1SLyf0yhAiQ6PFw2yWKCEDwNz+ZmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763994; c=relaxed/simple;
	bh=hVDW3DXTJw05+St/eDIR9EHXJXscr0SylFQdFoO2gug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2clEaTIUvoJqSVMvsiw/+wjk8gTvtcLCvnYLOVK8SkPqdvnfkLMU2Ul6PndEO3vdSfA5MuXadSCQikVlbv/9geM8F5b0mYG9pGYADEi5xYFhNble00VSK3LWwah2LBv49te+FKjfecrTtSr3OI7fUTMmpnI+Rxr5JpGWZQx1TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSiDnvSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSiDnvSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0034AC4CED1;
	Wed,  5 Feb 2025 13:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763994;
	bh=hVDW3DXTJw05+St/eDIR9EHXJXscr0SylFQdFoO2gug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSiDnvSgbRTjxMmPHPM77Q9AQqAnS05MgOqRT8hLpXVFoZl456PuX7XXipVQVE920
	 OrO0AlrfKTZBVnmrv+Wl9jVaRs0OvuwsgtnN7eWYgLafI/esTpdemnQwz6AEqaCSbb
	 WNNgcLZDmU5mZXcyDysv0eQbft+955RqjzngJTSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/590] wifi: rtlwifi: wait for firmware loading before releasing memory
Date: Wed,  5 Feb 2025 14:37:14 +0100
Message-ID: <20250205134458.275869474@linuxfoundation.org>
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

[ Upstream commit b4b26642b31ef282df6ff7ea8531985edfdef12a ]

At probe error path, the firmware loading work may have already been
queued. In such a case, it will try to access memory allocated by the probe
function, which is about to be released. In such paths, wait for the
firmware worker to finish before releasing memory.

Fixes: a7f7c15e945a ("rtlwifi: rtl8192cu: Free ieee80211_hw if probing fails")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-4-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index c3aa0cd9ff211..c27b116ccdff5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1028,13 +1028,15 @@ int rtl_usb_probe(struct usb_interface *intf,
 	err = ieee80211_register_hw(hw);
 	if (err) {
 		pr_err("Can't register mac80211 hw.\n");
-		goto error_out;
+		goto error_init_vars;
 	}
 	rtlpriv->mac80211.mac80211_registered = 1;
 
 	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 
+error_init_vars:
+	wait_for_completion(&rtlpriv->firmware_loading_complete);
 error_out:
 	rtl_deinit_core(hw);
 error_out2:
-- 
2.39.5



