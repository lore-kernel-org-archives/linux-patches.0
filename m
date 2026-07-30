Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1357B38DC40;
	Thu, 30 Jul 2026 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427472; cv=none; b=sp85uP4e8bNMkAlYuUeWRQVKO2tof78ekA/nldvMxM5S8MjIAwtb6iPLyrhRw8D6ltuSz1P+VQeovBWfH1y7Nz/Cp0kYHDia794d1NQYXwVaEM1Cw98FxtW2pyiGRDFzkc6Khmu5lqrFFJGv13B+dP4rxKr7dqW2DuQkJlBdUA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427472; c=relaxed/simple;
	bh=nhlV9bTTjTEukZkIE4rQYcRSSq6caL2DKzq8x3B4lAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnEAxjpp8K/GMUHXjJ+cgTR2jRL3Z7p+laZNIwowrnZhQv+cp0KLg4kHeTFThHQEpVrIn+UBmSuMvDjk/odmcT9JErP6ejYxwIKKPCGB1WKZjqtw8xyNn1zBUH+s8wh25cGlk//dmFaIQ+7/6lADfHjwmW6meXqHatr/0Ulst7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaUiwjGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaUiwjGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D66D1F000E9;
	Thu, 30 Jul 2026 16:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427471;
	bh=d8icm2DCLXvLKxeriUvIZqMfD9RUFat/iAUj7Dz/Q2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaUiwjGxwLr9eDHdENrFg3Cui/XPCefRvX8aZlai2SDeulxyJ8MpAHAgTWB2N+iBg
	 f7kEvPIZ0LtA2J5tiXphvt2HMYZ1gGokdhSvVZJy8w/jZiR58UsH3+uChpDFDCst9j
	 i8ATxrbdlwXsyAV/BFRhb97sMpYZqsGGf6ygitZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/484] wifi: iwlwifi: mvm: validate SAR GEO response payload size
Date: Thu, 30 Jul 2026 16:10:34 +0200
Message-ID: <20260730141426.434653915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index c597492668fad5..d2ff33366b3c6c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -908,12 +908,22 @@ int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
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
 
 	if (WARN_ON(ret > ACPI_NUM_GEO_PROFILES_REV3))
 		ret = -EIO;
 
+out:
 	iwl_free_resp(&cmd);
 	return ret;
 }
-- 
2.53.0



