Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D2E3BD22C;
	Wed, 30 Sep 2026 19:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796478; cv=none; b=MqzHK4MGeCdmCiFyBBUXIRzHakYFbJ73ktZPIxK3mQSvOSnV0ls4PH6wF6mDWSdedcVfKkV49FgkBJURLdqsFERpV/My1aPJYg1EzYDaaLVOkpoKMU5ljGe3c3nmACKMLuPpotrj6yh3xg2dQhmGmtgDBtTBztHosYZyCnoWts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796478; c=relaxed/simple;
	bh=2UDylT+CqGnan1pz1NXtnURRbf1gko6PRjLES65KNj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcA3qtuAD2oNSBaujdQhMLvo6CPaqpZzgWCc/rAH+f96PGWqzYjLdi4I2yXsmXFdW48zJgT5DRGsI965yFJdsbT4/E9UPuVco/Efdz3fxHeia8Y7DSyEYr/LlqE0NE2al4dVAbslR+rFtZRWazi0gizsN+7xrKmxyAT4qMV8L5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRz5qeeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRz5qeeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ED71F000FF;
	Wed, 30 Sep 2026 19:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796476;
	bh=P0kIodtzvCLfBuhrhOWUlYX3rrTsAnFrPZkleG1c5co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRz5qeeJQTHYtN4ewUEO9RaEM6f32+bbAXnMI4yejJF4AMeKSjSJgMwX7duASI8b5
	 YSa0Lnja8054xf79OtSlep3RXnZcziUdb2yPEKvmVbS295brRdQneqf78mjZZfbw/9
	 p44bQNstQmy3mryyyX3GxIjLKg/BpYyD5UVZmOsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0927/1193] wifi: mwifiex: validate scan response extents
Date: Wed, 30 Sep 2026 17:26:51 +0200
Message-ID: <20260930152454.836667115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2125,6 +2125,7 @@ int mwifiex_ret_802_11_scan(struct mwifi
 	u32 bytes_left;
 	u32 idx;
 	u32 tlv_buf_size;
+	size_t fixed_size;
 	struct mwifiex_ie_types_chan_band_list_param_set *chan_band_tlv;
 	struct chan_band_param_set *chan_band;
 	u8 is_bgscan_resp;
@@ -2140,6 +2141,14 @@ int mwifiex_ret_802_11_scan(struct mwifi
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
@@ -2157,8 +2166,6 @@ int mwifiex_ret_802_11_scan(struct mwifi
 		    "info: SCAN_RESP: bss_descript_size %d\n",
 		    bytes_left);
 
-	scan_resp_size = le16_to_cpu(resp->size);
-
 	mwifiex_dbg(adapter, INFO,
 		    "info: SCAN_RESP: returned %d APs before parsing\n",
 		    scan_rsp->number_of_sets);
@@ -2166,15 +2173,17 @@ int mwifiex_ret_802_11_scan(struct mwifi
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


