Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F9914A0A0;
	Wed, 19 Jun 2024 12:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801886; cv=none; b=oAr4WaUNR/iFpR7NWYqaN6Yzypeuj13BZR7HI7B70dLIpLYltXlFiKIqQU1cH+Qn15uQHn61M48rFDvJ4rJFdAQ9rxhXZ6gb22JFlDkV2S9VkHQo7URnqD64KqzCeYLTO+e4hqXHJOFNw+jLnfo1FnRfOglBNgtWeBD+HLlOu+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801886; c=relaxed/simple;
	bh=8G+X74WuWT7fGQuTj/14DyYr5yKJYh03hiP8MXKTl+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHb+lK1LcU/LCQJZmmOMWstqkccrrW+9djg6+MttJzEu+j06VTqtUf5HtLE4qESeYzY3HePKtxElTj9yQpjNvbiWDx4fD+rdC161eVuDGtDmlLGWIcj06gALMhVawa0eE2hNUfvkcUqut2d1yny5BeFvEjWZLRVYULWFghJDLho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJ3Gq0Ih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJ3Gq0Ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB51FC2BBFC;
	Wed, 19 Jun 2024 12:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801886;
	bh=8G+X74WuWT7fGQuTj/14DyYr5yKJYh03hiP8MXKTl+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJ3Gq0Ih1O5qfEloKkhc3f94WWuP0itriMCNFZTnT4j3mkQN/nfuG6lCO6ErH/eMB
	 HX5et34VCT74v5LDLkcNdxTFkw6+WwyJzn2bM5jje4UeCQdVtmhHj8zN/+u4EntYa8
	 zFnpNHUL6IRLTpQmJkF58d/ljTSBz+V7ds4r7dbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/267] wifi: iwlwifi: mvm: check n_ssids before accessing the ssids
Date: Wed, 19 Jun 2024 14:52:41 +0200
Message-ID: <20240619125606.749005246@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 60d62757df30b74bf397a2847a6db7385c6ee281 ]

In some versions of cfg80211, the ssids poinet might be a valid one even
though n_ssids is 0. Accessing the pointer in this case will cuase an
out-of-bound access. Fix this by checking n_ssids first.

Fixes: c1a7515393e4 ("iwlwifi: mvm: add adaptive dwell support")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://msgid.link/20240513132416.6e4d1762bf0d.I5a0e6cc8f02050a766db704d15594c61fe583d45@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 03ec900a33433..0841f1d6dc475 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1304,7 +1304,7 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 		if (IWL_MVM_ADWELL_MAX_BUDGET)
 			cmd->v7.adwell_max_budget =
 				cpu_to_le16(IWL_MVM_ADWELL_MAX_BUDGET);
-		else if (params->ssids && params->ssids[0].ssid_len)
+		else if (params->n_ssids && params->ssids[0].ssid_len)
 			cmd->v7.adwell_max_budget =
 				cpu_to_le16(IWL_SCAN_ADWELL_MAX_BUDGET_DIRECTED_SCAN);
 		else
@@ -1406,7 +1406,7 @@ iwl_mvm_scan_umac_dwell_v11(struct iwl_mvm *mvm,
 	if (IWL_MVM_ADWELL_MAX_BUDGET)
 		general_params->adwell_max_budget =
 			cpu_to_le16(IWL_MVM_ADWELL_MAX_BUDGET);
-	else if (params->ssids && params->ssids[0].ssid_len)
+	else if (params->n_ssids && params->ssids[0].ssid_len)
 		general_params->adwell_max_budget =
 			cpu_to_le16(IWL_SCAN_ADWELL_MAX_BUDGET_DIRECTED_SCAN);
 	else
-- 
2.43.0



