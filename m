Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7463430CC6;
	Thu, 30 Jul 2026 14:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421749; cv=none; b=HUEw5Q4BSYSp3Z5g4ApoGe40uC0yQX+c48iO+uukz6/qXhkDNZAQuaSjFV9O8J/R2ZumHKd57fH2Fe84jLiMIgZuJhuhgfTQ8BlUMpNKfCgty8xI3Fb5OMZWSISidHYUfQhEy7LLIOCEPZvSEmEOqVwhMDsgKo+UhfJV/lr4QtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421749; c=relaxed/simple;
	bh=4+nlB6pi8YJHScAw/uEzVdbcOJ8bJlCstk6zq37hLII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YodKMuqZM/pGeSfrbPLgxyrjsPJHzoH0fXYPgSso7WdciL6cFyYxiZFVDRzPMNRrC6PeNcv3+9HLZf9EFGCw0NUcVr1bGJ9pKf3nYRslKXzuyYkqZ9/ID8d7NTX/kQYmE1dNyTnUnLPmXefnjs7+jj3UsJvCQzZDk6x3gasHgiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUXYts/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUXYts/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307E11F000E9;
	Thu, 30 Jul 2026 14:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421748;
	bh=9Ckeg+Hs1uakYsgnoa6i9SQBzM1llyrRCIJdiQau5Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUXYts/XQwtxi9+Uor06HdhOR0+7N4wwqNKzqyTn/JJbOeR7QEN+MOEVj0x2DmWlG
	 hmPgUcqnTNVqW9KRiwW2j/JGz+sBNcEYltJtJz9fewPDlJU9s9cvjf1jtvB060UQQt
	 J2O0cRW6WA/rXHk1yS2Bitg6VuMLqUAGHCLkgy/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 207/744] wifi: iwlwifi: mvm: validate SAR GEO response payload size
Date: Thu, 30 Jul 2026 16:08:00 +0200
Message-ID: <20260730141448.678526516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6e507d6dcdd2a1..fa523be91d8ad3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -964,12 +964,22 @@ int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
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



