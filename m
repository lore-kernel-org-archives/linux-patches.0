Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F016121;
	Tue, 23 Jan 2024 01:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974103; cv=none; b=Te4dRyzYxvL3NrBmbT9fIV/7rD/wptgzZQBzQGiK/DMt4O3rOJH3PHVmkfyQYOEmUdtkeiGzKDGS2l3mqztNGCfOFkRCTJjJWSil5qIxNYIyP9jf/NR123V/537lTjLT74qNZjTlOHOK5iCYGMZBriqr6b2w3qdp90SVVjvo69Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974103; c=relaxed/simple;
	bh=Qgdw7wh5rZlb0tPq4YriUCT/DRUPU65nECWCAmwBEjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcsxxeltSZp+nhyoOS42YiCWQBovpUiFysYDFb0Jijw98vk+jm54C6Dnm/vM+es2mFS55+6cgm9F4VpeZ4pSO/b3Or1PU/XUnhSpDjPSUzlUfQdrscxDjkx6nBut5cZTPVFXiULxFHHJO6yhjntpmARn9x3ijBKlQo7ZK2LgHts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f50ihqj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f50ihqj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD54C433C7;
	Tue, 23 Jan 2024 01:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974103;
	bh=Qgdw7wh5rZlb0tPq4YriUCT/DRUPU65nECWCAmwBEjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f50ihqj2GJ76Tup59cxRBiq7sClEr9wf3MQlLU/ZAROPQ32zBrdDMjWT8HZAO9jGl
	 lbjx6ZEQCEpeciTIENhspaPdGnAyt4ldzsuO3vRYOM5k7nqBzqtOFpQUa2hpM3+Vbj
	 viTmPr3krIHNbUrMNoYwgIEm6pWf8IXPOiOSYzV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/374] wifi: iwlwifi: mvm: send TX path flush in rfkill
Date: Mon, 22 Jan 2024 15:57:00 -0800
Message-ID: <20240122235750.314454066@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

[ Upstream commit 2afc3dad39ea84a072d04ff40a417234326adc47 ]

If we want to drop packets, that's surely a good thing to
do when we want to enter rfkill. Send this command despite
rfkill so we can successfully clean up everything, we need
to handle it separately since it has CMD_WANT_SKB, so it's
not going to automatically return success when in rfkill.

Fixes: d4e3a341b87b ("iwlwifi: mvm: add support for new flush queue response")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231219215605.c528a6fa6cec.Ibe5e9560359ccc0fba60c35e01de285c376748a2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 08dd227bad4b..266d1e9a89f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2054,7 +2054,7 @@ int iwl_mvm_flush_sta_tids(struct iwl_mvm *mvm, u32 sta_id, u16 tids)
 	WARN_ON(!iwl_mvm_has_new_tx_api(mvm));
 
 	if (iwl_fw_lookup_notif_ver(mvm->fw, LONG_GROUP, TXPATH_FLUSH, 0) > 0)
-		cmd.flags |= CMD_WANT_SKB;
+		cmd.flags |= CMD_WANT_SKB | CMD_SEND_IN_RFKILL;
 
 	IWL_DEBUG_TX_QUEUES(mvm, "flush for sta id %d tid mask 0x%x\n",
 			    sta_id, tids);
-- 
2.43.0



