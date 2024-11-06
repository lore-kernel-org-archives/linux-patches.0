Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851AA6088F;
	Wed,  6 Nov 2024 12:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896206; cv=none; b=ssSXg6CPAIfUj9g2AvqFyhcPdWTqrw85qgcZPKkR4DJbn5Y0zbj4kMkIXU5KjnoREUP+UZIb3pDxC0YUtm1D0Gq4uyGYRuZRI0Z4JajkL/Cy2DGgF/yLmYjBsO4TBoiND6Z9AGOM7L59ySkbIm3tm+g+01Qopd23HALzkmG1fQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896206; c=relaxed/simple;
	bh=7Hno4yU4rf8cfCtFHPXYTzaoT7q93ccF494RNYs6XN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQtvd3x/XNztAeF4D77/O/6s51Bg7WAQBPC0ILR7NQJpYP1uHH0HMP7V8VaXy1lRYuiTrZiEfPa7fOgrGfDu7hDdK4UoBPBawmqKPfEXlgro2tWBiPrC0TOtFwlpFvsy/xCDVl3j75itaST49OStIkdeViVF0dlowGneu9SgCns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lw2INMBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lw2INMBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D44C4CECD;
	Wed,  6 Nov 2024 12:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896206;
	bh=7Hno4yU4rf8cfCtFHPXYTzaoT7q93ccF494RNYs6XN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lw2INMBGFX5ZDFeffkbhupByMC4DmjbUp7RHRlPctBc6im1cO4TOI/aGZhqOaYD3Y
	 rT5OMCcitMTV1kTtL6SD+9CYS2aZMIMdtMfOUAFnVTAwpKDtCOTofoL5A09wBPASjG
	 gTR49wdIMORmx9Vip4x2AjyryHpEL/sDncQ47a3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.11 126/245] wifi: iwlwifi: mvm: fix 6 GHz scan construction
Date: Wed,  6 Nov 2024 13:02:59 +0100
Message-ID: <20241106120322.324642756@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7245012f0f496162dd95d888ed2ceb5a35170f1a upstream.

If more than 255 colocated APs exist for the set of all
APs found during 2.4/5 GHz scanning, then the 6 GHz scan
construction will loop forever since the loop variable
has type u8, which can never reach the number found when
that's bigger than 255, and is stored in a u32 variable.
Also move it into the loops to have a smaller scope.

Using a u32 there is fine, we limit the number of APs in
the scan list and each has a limit on the number of RNR
entries due to the frame size. With a limit of 1000 scan
results, a frame size upper bound of 4096 (really it's
more like ~2300) and a TBTT entry size of at least 11,
we get an upper bound for the number of ~372k, well in
the bounds of a u32.

Cc: stable@vger.kernel.org
Fixes: eae94cf82d74 ("iwlwifi: mvm: add support for 6GHz")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219375
Link: https://patch.msgid.link/20241023091744.f4baed5c08a1.I8b417148bbc8c5d11c101e1b8f5bf372e17bf2a7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1774,7 +1774,7 @@ iwl_mvm_umac_scan_cfg_channels_v7_6g(str
 			&cp->channel_config[ch_cnt];
 
 		u32 s_ssid_bitmap = 0, bssid_bitmap = 0, flags = 0;
-		u8 j, k, n_s_ssids = 0, n_bssids = 0;
+		u8 k, n_s_ssids = 0, n_bssids = 0;
 		u8 max_s_ssids, max_bssids;
 		bool force_passive = false, found = false, allow_passive = true,
 		     unsolicited_probe_on_chan = false, psc_no_listen = false;
@@ -1799,7 +1799,7 @@ iwl_mvm_umac_scan_cfg_channels_v7_6g(str
 		cfg->v5.iter_count = 1;
 		cfg->v5.iter_interval = 0;
 
-		for (j = 0; j < params->n_6ghz_params; j++) {
+		for (u32 j = 0; j < params->n_6ghz_params; j++) {
 			s8 tmp_psd_20;
 
 			if (!(scan_6ghz_params[j].channel_idx == i))
@@ -1873,7 +1873,7 @@ iwl_mvm_umac_scan_cfg_channels_v7_6g(str
 		 * SSID.
 		 * TODO: improve this logic
 		 */
-		for (j = 0; j < params->n_6ghz_params; j++) {
+		for (u32 j = 0; j < params->n_6ghz_params; j++) {
 			if (!(scan_6ghz_params[j].channel_idx == i))
 				continue;
 


