Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901A81E8855;
	Thu, 30 Jan 2025 14:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247341; cv=none; b=caAT8MtPR3ZLl2Ua1q6k1AWJCfoXJNsg9cizHDm766Q+royqWHH5fp074ZOda10hhezUYOCjgnQU7yUq+XEU46MCj2rz/nWhIPT1yB+oOzVj1E9KVE67tCwYoBcdbGK1nRGsaUgi6gzgDD7ng44Nknv2BF8Bk0s3aaM9nVlg4sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247341; c=relaxed/simple;
	bh=LMFZ6vnB7VoWJXH+i7mA9wpQTkaRqfbbi1Ywfuh/T0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGFoFVgKXOqu7lloNBRRIeffvZPqiiho536ewUSHaC2CjvkkN5ZOFLIrSf40dWLbnSyU5EtlUiBi5NUppv8sdzvw6nCTNarHb5F0h05fkRNlilbLeIZU48aPMxDhjJp7EjfyZ2xCCXzxRqBeAZpiSxuBcUTYSbfRrta0BbxAHR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJKDlkeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJKDlkeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CF7C4CED2;
	Thu, 30 Jan 2025 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247341;
	bh=LMFZ6vnB7VoWJXH+i7mA9wpQTkaRqfbbi1Ywfuh/T0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJKDlkeLIeNTkOjP7Ycaipgpa8AkZUIc6iW9mUhaY17k2fEQKDsGuvFLB+4PwzFCw
	 2COQA66ICov2+WWhNbjh/5kebMlrMaWcjmsfNWCauPcJkcEXUbD4+8AwPDBPr1PKyV
	 B0qCe2BTTJ7ixr7ti+mpHJ8JDmc7db0AmKOvNXs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 18/24] wifi: iwlwifi: add a few rate index validity checks
Date: Thu, 30 Jan 2025 15:02:10 +0100
Message-ID: <20250130140128.022505906@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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

From: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

commit efbe8f81952fe469d38655744627d860879dcde8 upstream.

Validate index before access iwl_rate_mcs to keep rate->index
inside the valid boundaries. Use MCS_0_INDEX if index is less
than MCS_0_INDEX and MCS_9_INDEX if index is greater then
MCS_9_INDEX.

Signed-off-by: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230614123447.79f16b3aef32.If1137f894775d6d07b78cbf3a6163ffce6399507@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c |    7 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c |    9 ++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -130,7 +130,7 @@ static int iwl_hwrate_to_plcp_idx(u32 ra
 				return idx;
 	}
 
-	return -1;
+	return IWL_RATE_INVALID;
 }
 
 static void rs_rate_scale_perform(struct iwl_priv *priv,
@@ -3151,7 +3151,10 @@ static ssize_t rs_sta_dbgfs_scale_table_
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
 		index = iwl_hwrate_to_plcp_idx(
 			le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags));
-		if (is_legacy(tbl->lq_type)) {
+		if (index == IWL_RATE_INVALID) {
+			desc += sprintf(buff + desc, " rate[%d] 0x%X invalid rate\n",
+				i, le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags));
+		} else if (is_legacy(tbl->lq_type)) {
 			desc += sprintf(buff+desc, " rate[%d] 0x%X %smbps\n",
 				i, le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags),
 				iwl_rate_mcs[index].mbps);
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1119,10 +1119,13 @@ static void rs_get_lower_rate_down_colum
 
 		rate->bw = RATE_MCS_CHAN_WIDTH_20;
 
-		WARN_ON_ONCE(rate->index < IWL_RATE_MCS_0_INDEX ||
-			     rate->index > IWL_RATE_MCS_9_INDEX);
+		if (WARN_ON_ONCE(rate->index < IWL_RATE_MCS_0_INDEX))
+			rate->index = rs_ht_to_legacy[IWL_RATE_MCS_0_INDEX];
+		else if (WARN_ON_ONCE(rate->index > IWL_RATE_MCS_9_INDEX))
+			rate->index = rs_ht_to_legacy[IWL_RATE_MCS_9_INDEX];
+		else
+			rate->index = rs_ht_to_legacy[rate->index];
 
-		rate->index = rs_ht_to_legacy[rate->index];
 		rate->ldpc = false;
 	} else {
 		/* Downgrade to SISO with same MCS if in MIMO  */


