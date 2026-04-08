Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8FBB67E;
	Wed,  8 Apr 2026 18:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672208; cv=none; b=Ffl3Buq5e/3L2cp4SSHd8snQ983o5aVi2hCU3KlpDETBM55RMNe09oO5/be9r73pbStmUoTfR/S3A4EZaYUiWTc6J/NbRhgPALIJCFLBsEgmo8zvWA3yussOnvi5BtIWFpNqosQ/oJCeoe8efToPShzHCYUVZvM9cE9b1SYOos0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672208; c=relaxed/simple;
	bh=vW6i+iXet3S0NAPrP7Xwvq35d175UJdypOaCVO34+M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InGiaSCzFFmYMoIE0mpqW+eHLe28xVSYFZm7wJ08OEt3rfempJSU4mg9ywoWJJnAjxEH9l8r45wfxpCE+qrC/q/ooYcsVIZUzOeJTAyNsv+xQjZM/krD3RofaCJYBatla+C9jQmi9nbUo+Lo00ZYWHBok5TTPTmiq3aNGY68Cbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqAk4sDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqAk4sDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36925C19421;
	Wed,  8 Apr 2026 18:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672208;
	bh=vW6i+iXet3S0NAPrP7Xwvq35d175UJdypOaCVO34+M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqAk4sDO2tk+FDeSAkZjF+9XmxTv0KP93XwjM9n+sxB6TmYbn0W7UMiHGYFOMYGCH
	 OCBUpQiE/ZoeVogaubFPsuECreYpj8ZZFFBXj0d8ID8yIebhuGWTZP+8KCBB+VFQmy
	 awFQOy02rGW6wjYCqDHylUzHDqa16v1oOoSXUMpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 199/312] wifi: wilc1000: fix u8 overflow in SSID scan buffer size calculation
Date: Wed,  8 Apr 2026 20:01:56 +0200
Message-ID: <20260408175941.191304416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasuaki Torimaru <yasuakitorimaru@gmail.com>

commit d049e56b1739101d1c4d81deedb269c52a8dbba0 upstream.

The variable valuesize is declared as u8 but accumulates the total
length of all SSIDs to scan. Each SSID contributes up to 33 bytes
(IEEE80211_MAX_SSID_LEN + 1), and with WILC_MAX_NUM_PROBED_SSID (10)
SSIDs the total can reach 330, which wraps around to 74 when stored
in a u8.

This causes kmalloc to allocate only 75 bytes while the subsequent
memcpy writes up to 331 bytes into the buffer, resulting in a 256-byte
heap buffer overflow.

Widen valuesize from u8 to u32 to accommodate the full range.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yasuaki Torimaru <yasuakitorimaru@gmail.com>
Link: https://patch.msgid.link/20260324100624.983458-1-yasuakitorimaru@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/hif.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -162,7 +162,7 @@ int wilc_scan(struct wilc_vif *vif, u8 s
 	u32 index = 0;
 	u32 i, scan_timeout;
 	u8 *buffer;
-	u8 valuesize = 0;
+	u32 valuesize = 0;
 	u8 *search_ssid_vals = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 


