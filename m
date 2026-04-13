Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBA7330B01;
	Mon, 13 Apr 2026 16:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099501; cv=none; b=H2BAxbQLHVOxea1jZyDfc+iTRCwwRC5tc2gG6l6ZRNdhOfHotkv+PFOPsQpJa9ECFGWcEuUSYOqmdcz3073nkaebKZm3nIwm1GNjz1q5V0bqdyaAVgw/R7shqtAbryv+to5x4HkTNk8XkQT9sknUmhE7hDm71dkIMM1YjQDAFcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099501; c=relaxed/simple;
	bh=FtC5gxyYOShMmS5T/c2BZtIbfp2QHkzSz/dgkK+ZOtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8nPuiiaRUi+vaUJbCgJ19iQsstf7kfSMtejuUwMUr7pqQno4jRtzQHQIWysc8UJaWNXKWLoNY8TYGVzTSJSy0/oFaldewL5yRh9OMh8n90UeWPLvsX1e4pfpKZunsi9CC40ylkGuFWFrJvi2DUikeE7T1wb0ooPpaJC4o+HeII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwMrsWDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwMrsWDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46321C2BCAF;
	Mon, 13 Apr 2026 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099501;
	bh=FtC5gxyYOShMmS5T/c2BZtIbfp2QHkzSz/dgkK+ZOtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwMrsWDXek9KRe15UFKa9BG+oGdN7n2eQhhDNtQZxREgywboSs+GcJllGim5yW7Hy
	 hsW0i4g1RKKwhlPn4P9VzwF4VgniIH+rdf0A1U4JOTChKFogM7TmvGEz/L7tsOKTMq
	 MPVoqQMOBSDh8scfWPKbZRo/NoKzXMIrXXLo6Wvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 365/491] wifi: wilc1000: fix u8 overflow in SSID scan buffer size calculation
Date: Mon, 13 Apr 2026 18:00:10 +0200
Message-ID: <20260413155832.699966475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -157,7 +157,7 @@ int wilc_scan(struct wilc_vif *vif, u8 s
 	u32 index = 0;
 	u32 i, scan_timeout;
 	u8 *buffer;
-	u8 valuesize = 0;
+	u32 valuesize = 0;
 	u8 *search_ssid_vals = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 


