Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0262C3806BD;
	Thu, 30 Jul 2026 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425702; cv=none; b=bkkWYUSE8o5DSgC7MpGhT4Ei3syMOiO/N7JR8tNws/X0afcDbx2QnTMyAjUVx+1/UXYwJD6ma0xwiqim2PWCuM9yZiY4O6UHX2tBN3ZlG8okjV2zjN0npee/+URQJ0Yb4ATHUp3bTE9t7PI7UTdX4WU2Oz1ZCL8hkOuUBxnu6Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425702; c=relaxed/simple;
	bh=FuerJPYkN9hFB6CZNy7c0q/+wbq1dPFS5mUDMsn/EHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbQwS4vRX9bbaBSOO7xDpay7M7K0WoFV79loipQJ5DIvMzLMqEcm/S9wZ9wVYNhzlz+Gq9AWPNXfaECWQM5gzgUt+VmOohL3WkC/2FfR75VPi1pssyrUkW7nxIKPeEGOQZ37gaSlqFH8dtIlAmxYKYB697jUYVzPWCoGgzPzfP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHy0Ai8k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHy0Ai8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A83C1F000E9;
	Thu, 30 Jul 2026 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425700;
	bh=21DsyLkN4Uz40wwUI6ijX+JztND2f03s0cOVT9XEfnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHy0Ai8kr91L5R92+69oRdVXDCtemFviodbTC8VctvHJUqmQLrHy5xd0c1l/LmQfK
	 RDlRhJWHl9yMaeCB0Q3n55+/WDZ2g+uL0MlzSXkhKhInED0X4sEKWLjV2dq0GoyXHt
	 0FfzqHXCOsx+y3IuSBDwEsM6aFeXb9LpVTFf64/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/602] wifi: iwlwifi: mvm: validate SAR GEO response payload size
Date: Thu, 30 Jul 2026 16:09:13 +0200
Message-ID: <20260730141439.356065382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit 408d7da38272ce48e2db79b8a9895999f94d7655 ]

The SAR GEO command response is cast to
iwl_geo_tx_power_profiles_resp without verifying the payload length.
A malformed or unexpected firmware response can lead to reading an
invalid structure layout.

Add an explicit size check before accessing the response data and
return -EIO when the payload size is wrong.

Fixes: f604324eefec ("iwlwifi: remove iwl_validate_sar_geo_profile() export")
Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.7e749b7d374a.I4ef54548bff6c6e7c7a57bee771ac12508aad677@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 2b9a684cf61d57..4bad012472e1e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -976,12 +976,22 @@ int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
 		return ret;
 	}
 
+	if (IWL_FW_CHECK(mvm,
+			 iwl_rx_packet_payload_len(cmd.resp_pkt) !=
+			 sizeof(*resp),
+			 "Wrong size for iwl_geo_tx_power_profiles_resp: %d\n",
+			 iwl_rx_packet_payload_len(cmd.resp_pkt))) {
+		ret = -EIO;
+		goto out;
+	}
+
 	resp = (void *)cmd.resp_pkt->data;
 	ret = le32_to_cpu(resp->profile_idx);
 
 	if (WARN_ON(ret > BIOS_GEO_MAX_PROFILE_NUM))
 		ret = -EIO;
 
+out:
 	iwl_free_resp(&cmd);
 	return ret;
 }
-- 
2.53.0



