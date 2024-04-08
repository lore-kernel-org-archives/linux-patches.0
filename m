Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBE970CDA;
	Mon,  8 Apr 2024 13:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581914; cv=none; b=HpgMWqNtqtZPcruaqaa7ZDPAV5MA95d6wjoSuyIoMSiDHvjF7hujtljuq93Cm8mOMBirBqlNFUbLQLyHSiUYviqtZ+UJcPGOCQ+FhY3TrOKPa4od4Tsz076FAr4kwybKsJAj07eayseE3r9Uu1QixQeQI2c7jy0BcseCqNZTbg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581914; c=relaxed/simple;
	bh=NVfFyy0YxwWT3tzFXNeXwwnX9SEvbRg8mN+qDlNtS68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkD4qWqx1MEJizJ5yLWL+pd5o6vKIK0HZqd6h17b0gmP/pL3mDYikwc3nZgILc7sKYEiVcOlks8v0VG+Nmp1TzqcVywUgWknscOG7t7FTzyPuJR9kVgv0KjXrTYlFybZ6wX0cxxKWUAJeADjzDu34FN+boS+tOG07vxfJzP5P7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MFJP0z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MFJP0z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B917C433F1;
	Mon,  8 Apr 2024 13:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581913;
	bh=NVfFyy0YxwWT3tzFXNeXwwnX9SEvbRg8mN+qDlNtS68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MFJP0z4XU6H7wG+gqbJNfXikdo7eKUgTeNvIZQQtWKcMd9TOBKHs7/T0U/WS2STB
	 hrxq4jnVJI/pRcjhCOrwOUyLgP46lsMvMDwnRVxL8AalAyiyT4pgfzvCOxqAWC5ckm
	 TtBUCS9JUqE9Qc+RQmye6qG9eEiFg87bHLd7SHrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH 6.8 012/273] wifi: iwlwifi: mvm: rfi: fix potential response leaks
Date: Mon,  8 Apr 2024 14:54:47 +0200
Message-ID: <20240408125309.667810965@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 06a093807eb7b5c5b29b6cff49f8174a4e702341 ]

If the rx payload length check fails, or if kmemdup() fails,
we still need to free the command response. Fix that.

Fixes: 21254908cbe9 ("iwlwifi: mvm: add RFI-M support")
Co-authored-by: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240319100755.db2fa0196aa7.I116293b132502ac68a65527330fa37799694b79c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
index 2ecd32bed752f..045c862a8fc4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -132,14 +132,18 @@ struct iwl_rfi_freq_table_resp_cmd *iwl_rfi_get_freq_table(struct iwl_mvm *mvm)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (WARN_ON_ONCE(iwl_rx_packet_payload_len(cmd.resp_pkt) != resp_size))
+	if (WARN_ON_ONCE(iwl_rx_packet_payload_len(cmd.resp_pkt) !=
+			 resp_size)) {
+		iwl_free_resp(&cmd);
 		return ERR_PTR(-EIO);
+	}
 
 	resp = kmemdup(cmd.resp_pkt->data, resp_size, GFP_KERNEL);
+	iwl_free_resp(&cmd);
+
 	if (!resp)
 		return ERR_PTR(-ENOMEM);
 
-	iwl_free_resp(&cmd);
 	return resp;
 }
 
-- 
2.43.0



