Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634AF2E405;
	Mon,  8 Apr 2024 13:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581489; cv=none; b=ubfSM5sJtEAgAjWVpct12T2T3XXcddOSKYu/P2jo5owj5q2ldyXwF/cjDhtAYCtUmOSsCuy3iAbEx6RdcWinNyZXA2bMWsqPYnNCfiSPw36DgbeM6oOiz4rkn8SntwujaphmCGJTMfdBA09G7wuv9z+C2KC6utvRAgXvmIYk0rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581489; c=relaxed/simple;
	bh=Wztw/SiwYAU+WaCoZl6RPnI71v2MuIXHoFsasqLN8Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us9W+k0J69d0q2adC/ZxsHwOMmfd0BIW8xIuQqHTyKGOxURPJLwny6/IUyWO8SKIvikN2+RkBiZU1uovtTzqcxvBDCcNNjwx42hWdx8j1iiNvupHg3JOUBdI0ywi1NesfcObP3DlTOR1Io0yh8MbaYjTdK4j6JLdhNbLYFKE4Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zi2Ixenw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zi2Ixenw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF762C433C7;
	Mon,  8 Apr 2024 13:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581489;
	bh=Wztw/SiwYAU+WaCoZl6RPnI71v2MuIXHoFsasqLN8Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zi2IxenwDZCqCOxZ1fIkjgClPk1StnxyBpFo5Ni+dxRz4RDX6yYSNBZ0sB12p0vD6
	 MQfO3xqBtxxu3ohuQu3OVKtyMKx95xFtG5R1TFAjEuriNHZ69rB0UcYR+AwJpQCeYL
	 yxKrj7wrsPPQAKbV/VA6aH8Dm0ZiVx4sT7Mdcna8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH 6.6 011/252] wifi: iwlwifi: mvm: rfi: fix potential response leaks
Date: Mon,  8 Apr 2024 14:55:10 +0200
Message-ID: <20240408125306.997494072@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



