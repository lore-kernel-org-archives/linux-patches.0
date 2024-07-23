Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB29813D896;
	Tue, 23 Jul 2024 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759864; cv=none; b=uy1JXoLl8sS8F7ahFeZZdWzX80JQNmgbsHDmIP0p2Eivf4z8AcfBkmcoJKRqTen0wcmd5/xjjtaaWJ61MJI7CDEp2o31z2BJE4gg+bA9HqNfT3D8QRrvCQkbrLrHtgUxIBCsgMuQhGn8n/6NIE/XI8ZcYq9P308LLa/yu5RjlzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759864; c=relaxed/simple;
	bh=YOEm3XpObDPfufk9rg+IayPaynQTRlQlM6iPTO6FZVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcdoLdjd59IxfyCB41xWuqiWx+5T6E7agJnZXXcTihUR32LmsNDLvOk44qaoqXZz7s8GEpl+HXxSsh2YNV9vG2Bi9yGYADS28X2uhsg/X5WezRQEdHlV040rmTOWlhBSSIwX9UoM8W3TAXaTnBdb9C6DXifXPTDNXDrF0tTjNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWwf9ccf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWwf9ccf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C3AC4AF0B;
	Tue, 23 Jul 2024 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759863;
	bh=YOEm3XpObDPfufk9rg+IayPaynQTRlQlM6iPTO6FZVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWwf9ccfezGw7HVeEyuDaebEQIr/0Gz8b9JVqelCEjwtPa4lMNzC4C7niXq1eS2dg
	 fBysz8edcag14FCoRHlhhdl3bnh+F9fdrX0UTq83He0MNNerzsoSd6E3JSU4FZ+LOs
	 WcK55h9atFOaZbS0AeR5GzTbYXgIBWCUCdLCw21Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 023/163] wifi: iwlwifi: mvm: Fix scan abort handling with HW rfkill
Date: Tue, 23 Jul 2024 20:22:32 +0200
Message-ID: <20240723180144.365812682@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit e6dd2936ce7ce94a1915b799f8af8193ec628e87 ]

When HW rfkill is toggled to disable the RF, the flow to stop scan is
called. When trying to send the command to abort the scan, since
HW rfkill is toggled, the command is not sent due to rfkill being
asserted, and -ERFKILL is returned from iwl_trans_send_cmd(), but this
is silently ignored in iwl_mvm_send_cmd() and thus the scan abort flow
continues to wait for scan complete notification and fails. Since it
fails, the UID to type mapping is not cleared, and thus a warning is
later fired when trying to stop the interface.

To fix this, modify the UMAC scan abort flow to force sending the
scan abort command even when in rfkill, so stop the FW from accessing
the radio etc.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240513132416.8cbe2f8c1a97.Iffe235c12a919dafec88eef399eb1f7bae2c5bdb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index e8d40e4a2f2ff..aa5fa6c657c02 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -3254,10 +3254,11 @@ static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
 
 	ret = iwl_mvm_send_cmd_pdu(mvm,
 				   WIDE_ID(IWL_ALWAYS_LONG_GROUP, SCAN_ABORT_UMAC),
-				   0, sizeof(cmd), &cmd);
+				   CMD_SEND_IN_RFKILL, sizeof(cmd), &cmd);
 	if (!ret)
 		mvm->scan_uid_status[uid] = type << IWL_MVM_SCAN_STOPPING_SHIFT;
 
+	IWL_DEBUG_SCAN(mvm, "Scan abort: ret=%d\n", ret);
 	return ret;
 }
 
-- 
2.43.0



