Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9353752F6E;
	Mon,  8 Apr 2024 14:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585069; cv=none; b=hi/lk/hDxTCv+AD4DIiOZ/eFnqON90oDS8l0JwEDwPVPHp14SW8eStl84gbf1wRCUl7njC+XTgYNiJv48PV8+hgqPtlGwaeA8olrWjUGTg0RCjuKeoPVAqgv/ICBVCXW2LfJWHPjZZ01geExMXSZztV6lWNUJkFgik5alDre8lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585069; c=relaxed/simple;
	bh=PToZ77PxY5OkzF+DTWSnfA3IEdNfywPzXLZXk7g/yVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+lur7dR80VJBhvP7g5x4j87ZkRX69SVdfJxJ3DYqGGr9QYmy5/d29ljg6Y/VInX6xn8KHf6VCtftiWBjKuGShX0DCRsExrDpkWZIBJI9JOXEXySqItXekq+EkkRQ2HEp3ldIKtpuLtXgfxdOyIA1XKi0rsyMU7Wm8Kj6Qpda5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHxr6ZQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHxr6ZQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C652C433F1;
	Mon,  8 Apr 2024 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585069;
	bh=PToZ77PxY5OkzF+DTWSnfA3IEdNfywPzXLZXk7g/yVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHxr6ZQ8roDzqk2hTGpeEZU5n6WnQ3tavk+N51A0PBXubuIfBUPz90E742XDJ/Mx/
	 HcKMXhIbpH6stDCAsGDBhjcpQYwD8JbNcYyFPhsh9e/Rp7n1jC4vsmzApXi0+A0Cmr
	 Xk0ayQO2ZAuP0J/cVgpL5zmoMG5KXwmgPaHgfUpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH 5.15 612/690] wifi: iwlwifi: mvm: rfi: fix potential response leaks
Date: Mon,  8 Apr 2024 14:57:58 +0200
Message-ID: <20240408125421.776781435@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1954b4cdb90b4..4deb242df7b37 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -104,13 +104,17 @@ struct iwl_rfi_freq_table_resp_cmd *iwl_rfi_get_freq_table(struct iwl_mvm *mvm)
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



