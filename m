Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E654D9EA;
	Wed, 19 Jun 2024 13:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803592; cv=none; b=XQVomJdTmrnf1xul8GMeZ0Ekge1Xs0+De/iSke8eMkUF3Ua0crkyaVgIif1A6wDym0na0xA8u6Rbfzc1paCyBjdb31CkV6iN8x9cqKjwp6pRZQga+9jtXqMYgfCw2IjvXclMcrbvxQ9oGbXxR85hwWsjO+lbt389/Nn5la5oQ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803592; c=relaxed/simple;
	bh=/f6swVG0/fVGY1JfxjP8qfMLkUkyZeJaj7nfNbGT/tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLXWLBDWXpHU0BP+b4NuzBfLV+6vPZ35wk/XUet+7jmsPsyQnbELYsyThREOiVAZDQHNfEJVsXo7uqXchsxMvFCXH9cJxJ7hJqgae39xkzMITIvlsJOoEQL5n4Etc/W3JjjLGWAVTrloJvHgVlOX3iesjI+kHwDERxSB7G4+1co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHdlZvR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHdlZvR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2D7C2BBFC;
	Wed, 19 Jun 2024 13:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803592;
	bh=/f6swVG0/fVGY1JfxjP8qfMLkUkyZeJaj7nfNbGT/tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHdlZvR3ZgkEu9GK0IcHI4yas9oOyPS/RdVX0XF67zN6V4N6x1Gz7+r2mCu26H1S4
	 2qtBQgzjK0LJWv8Ytql3gKzNRmNYYdsIlpQjRA54D6/ptdwzCVFf9gTSElp1iBjCx7
	 arNnWi0u1Wv3eU7y4V1wj6VHuLw1yKNcdFr9ced8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/217] wifi: iwlwifi: mvm: check n_ssids before accessing the ssids
Date: Wed, 19 Jun 2024 14:54:11 +0200
Message-ID: <20240619125556.825827510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b20d64dbba1ad..a7a29f1659ea6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1298,7 +1298,7 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 		if (IWL_MVM_ADWELL_MAX_BUDGET)
 			cmd->v7.adwell_max_budget =
 				cpu_to_le16(IWL_MVM_ADWELL_MAX_BUDGET);
-		else if (params->ssids && params->ssids[0].ssid_len)
+		else if (params->n_ssids && params->ssids[0].ssid_len)
 			cmd->v7.adwell_max_budget =
 				cpu_to_le16(IWL_SCAN_ADWELL_MAX_BUDGET_DIRECTED_SCAN);
 		else
@@ -1400,7 +1400,7 @@ iwl_mvm_scan_umac_dwell_v11(struct iwl_mvm *mvm,
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



