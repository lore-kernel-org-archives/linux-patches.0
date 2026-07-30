Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A598143CE68;
	Thu, 30 Jul 2026 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423871; cv=none; b=tsMXGivmln3qCe5yGpGPvhk8/AWdH/4d0HxfSiYqMnqZ5Jt47JdQWpaxzBgu7hkZoqW16EFk4DU/yOO9L9dX37rD9fqV8iOg7wcMDn1epco1B4z7Y3CiArszZ3QzTWpJ10HYQWEHCsCgkZhF4eoJhUC6VvvpNO3pp9T91V9XAo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423871; c=relaxed/simple;
	bh=iz/2tIKJsrperHi1z6Oj9Vsjh8kThHYzSFqOnmEbCkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWl7qhPF2+txCT+ikmkaaUAsd5d+1HVO9zF5LzDkhJPtc5LLKldivpTFEi6+wDmMf1YhRAiSU8ODUcJoFQPb4/ISXTV8U3o7/RxtSgFFNamD3lE0SUucm/iZqHluT507mYTkxqS3gk4A3LC5LrPNnMUpRZ+BAzheOARuQja/sS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEKW/cyX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEKW/cyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43F51F000E9;
	Thu, 30 Jul 2026 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423870;
	bh=GqV8ag4qLw21wUVVf+R8MwlsQUOPrCLRrp2IYyUyV4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEKW/cyX6hzkEF3//GjTakFwTlsTss5zqxG2paIgxIepKEybP7r/0e5fmJ/eU+fNa
	 srwCQ7iLlcF3smM4b8T1aly8LZRsdJPdFtrtprzCn3DoG/oppFk94X9u89Nq7qGbBT
	 YUG1jouPaOH86tw7qeQMq2dSFwqB5xSenf8fxdmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/675] wifi: iwlwifi: mvm: validate SAR GEO response payload size
Date: Thu, 30 Jul 2026 16:08:45 +0200
Message-ID: <20260730141449.288773872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aa517978fc7a35..cfca5a3ee78ec8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -955,12 +955,22 @@ int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
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



