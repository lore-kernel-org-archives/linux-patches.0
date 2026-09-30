Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B75D35CB91;
	Wed, 30 Sep 2026 15:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783647; cv=none; b=BhaCStSvYBDeTV5ZB2Vbkahh4Cq7G9uIRoJjSw9JLnnzohrbBzll1UvOxn1V5FrTr2gGu1Z2Z6+S4Xecl/F5NgswaxqwyaIjZ0VCkX7ZXNLc6eTbOmaICk1reCPwKcB6cwfYkweIHHejdRqIwvay6NIw20FPELNCSJiB0sZ3XGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783647; c=relaxed/simple;
	bh=MT7s1HoZHUoa8FpvOMht4u7W4BnrcQC4urdYGR5kvvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjm+ojXH50czRAYpPzkCdA9AQiBdTMYnhcfscsxCAMvZSFs+B6FHcppIlD67wRfHm6bGVO4Lwrw6iaoQvSNgkcfY4IDI8FCCSNH2A8JBYIsBQvtAR68LZVEpk9uVmW6bV0a/q25QHxTJK4An5NLp/L1x2xqmlLwyR509Xgc8QoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pO0CPFmM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pO0CPFmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEEC1F000FF;
	Wed, 30 Sep 2026 15:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783642;
	bh=4p8afCCb8NMdL9Q7+mONCjyMX6bYYZVuLXAauA9/qQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pO0CPFmM/sLhnK5xmQ1Rk9MyFkPWCA14mpjPN/PZGcTy7tAwR91k1zXt2kVK8jp4X
	 CzVPC2zYtq5t5Se6vdLbSe8FGEt3MLMtg48mT85hsmXMSGiAFXwd2sj7+1n0USnPk8
	 Hcgbf5HzemC2dJZ7mH/OwQo0uLM/IdfZSgq5AHWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 471/595] wifi: mwifiex: validate scan response extents
Date: Wed, 30 Sep 2026 17:26:04 +0200
Message-ID: <20260930152357.809609120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 3687d7d48070838cc2953431b3a27717cab0aaf6 upstream.

mwifiex_ret_802_11_scan() subtracts the fixed response fields and the
firmware-provided BSS length from resp->size without first proving that
either extent fits. A short response or oversized BSS length can
therefore underflow tlv_buf_size and make the TLV parser walk beyond the
command response.

Compute the fixed extent from the selected normal or background scan
response. Validate that the fixed fields and BSS data fit before deriving
the TLV extent and entering the parser.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260815135227.50392-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c |   29 ++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2143,6 +2143,7 @@ int mwifiex_ret_802_11_scan(struct mwifi
 	u32 bytes_left;
 	u32 idx;
 	u32 tlv_buf_size;
+	size_t fixed_size;
 	struct mwifiex_ie_types_chan_band_list_param_set *chan_band_tlv;
 	struct chan_band_param_set *chan_band;
 	u8 is_bgscan_resp;
@@ -2158,6 +2159,14 @@ int mwifiex_ret_802_11_scan(struct mwifi
 	else
 		scan_rsp = &resp->params.scan_resp;
 
+	scan_resp_size = le16_to_cpu(resp->size);
+	fixed_size = scan_rsp->bss_desc_and_tlv_buffer - (u8 *)resp;
+	if (scan_resp_size < fixed_size) {
+		mwifiex_dbg(adapter, ERROR,
+			    "SCAN_RESP: response is too short\n");
+		ret = -1;
+		goto check_next_scan;
+	}
 
 	if (scan_rsp->number_of_sets > MWIFIEX_MAX_AP) {
 		mwifiex_dbg(adapter, ERROR,
@@ -2175,8 +2184,6 @@ int mwifiex_ret_802_11_scan(struct mwifi
 		    "info: SCAN_RESP: bss_descript_size %d\n",
 		    bytes_left);
 
-	scan_resp_size = le16_to_cpu(resp->size);
-
 	mwifiex_dbg(adapter, INFO,
 		    "info: SCAN_RESP: returned %d APs before parsing\n",
 		    scan_rsp->number_of_sets);
@@ -2184,15 +2191,17 @@ int mwifiex_ret_802_11_scan(struct mwifi
 	bss_info = scan_rsp->bss_desc_and_tlv_buffer;
 
 	/*
-	 * The size of the TLV buffer is equal to the entire command response
-	 *   size (scan_resp_size) minus the fixed fields (sizeof()'s), the
-	 *   BSS Descriptions (bss_descript_size as bytesLef) and the command
-	 *   response header (S_DS_GEN)
+	 * The TLV buffer follows the command-specific fixed fields and the BSS
+	 * descriptions. Background-scan responses have an additional fixed
+	 * field before scan_rsp, which is included in fixed_size.
 	 */
-	tlv_buf_size = scan_resp_size - (bytes_left
-					 + sizeof(scan_rsp->bss_descript_size)
-					 + sizeof(scan_rsp->number_of_sets)
-					 + S_DS_GEN);
+	if (bytes_left > scan_resp_size - fixed_size) {
+		mwifiex_dbg(adapter, ERROR,
+			    "SCAN_RESP: BSS data exceeds response\n");
+		ret = -1;
+		goto check_next_scan;
+	}
+	tlv_buf_size = scan_resp_size - fixed_size - bytes_left;
 
 	tlv_data = (struct mwifiex_ie_types_data *) (scan_rsp->
 						 bss_desc_and_tlv_buffer +


