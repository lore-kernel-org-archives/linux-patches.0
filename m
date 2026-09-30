Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4AC4CA784;
	Wed, 30 Sep 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788848; cv=none; b=KzIdOD3edEx+R4bEaSaQxfsLZ+GTXc/+ktq/3ec1LY63SBHz6Q2LZAql3KeAsrSXmujJeSSrXKvoZ6gcenFLrjsOd4lJCw5HwYYXSAYiYJmT0r8eugIc2KGT0XI6zOyHs0QtpnHH/TKWqpTqbq3C0JXN8vdldVZfQd3/3yXGxpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788848; c=relaxed/simple;
	bh=E1jE1g8h317lB7TkY7Wfv9MgJcoyLGy6cgfQG/L7KMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQNFCoJI/pFpgfJxS9iqpzIGmk+5IX08qVrl4fQE+XL89bnhzvFPJDM1wAmt/865dOSFvdfUjzs0S0fGnTLWtTeB2+8QlVZdVN9Ja7oZ7uCkxpb8mv9EShoUYYRuEmvurvFgJRRVWEk1Wcq/tAVP8q/d77GTMxDZcwZxXWwFQKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvQ4/v+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvQ4/v+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9731F000FF;
	Wed, 30 Sep 2026 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788844;
	bh=gu2eNIpHR4tCYzU6XnMJlVAL5FUNpCN9bOSG5mP8a4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvQ4/v+clXQfKglK/Lr2HPbgu7Uo7JpGv3aQGBkNIt+OHj7AKBwnAn9EFz3yqTFxn
	 2B2oYZBJBMu8EnYGEzQGVCsSiLyNX03IMyfu1r794u0Rp/z2U3vgobYdkNsBG2MU3e
	 ZGyR/9rA8u3l2kbvZmo34PQ8EBDhH0uHLtUCVLzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 269/877] wifi: mwifiex: validate scan response extents
Date: Wed, 30 Sep 2026 17:19:40 +0200
Message-ID: <20260930152420.528258935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -2117,6 +2117,7 @@ int mwifiex_ret_802_11_scan(struct mwifi
 	u32 bytes_left;
 	u32 idx;
 	u32 tlv_buf_size;
+	size_t fixed_size;
 	struct mwifiex_ie_types_chan_band_list_param_set *chan_band_tlv;
 	struct chan_band_param_set *chan_band;
 	u8 is_bgscan_resp;
@@ -2132,6 +2133,14 @@ int mwifiex_ret_802_11_scan(struct mwifi
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
@@ -2149,8 +2158,6 @@ int mwifiex_ret_802_11_scan(struct mwifi
 		    "info: SCAN_RESP: bss_descript_size %d\n",
 		    bytes_left);
 
-	scan_resp_size = le16_to_cpu(resp->size);
-
 	mwifiex_dbg(adapter, INFO,
 		    "info: SCAN_RESP: returned %d APs before parsing\n",
 		    scan_rsp->number_of_sets);
@@ -2158,15 +2165,17 @@ int mwifiex_ret_802_11_scan(struct mwifi
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


