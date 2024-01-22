Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720146313F;
	Tue, 23 Jan 2024 01:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975023; cv=none; b=ehKGiDdevh1/OfxFVbTvlU/gw+lzdq3XnquE2yHikEggTQqKATD8oJbfJm4MpFEtbdcf468aQqejr5AmBXFuwv72VRYm2rFNMe/O9pRYGFRf/mMnnXpicLv+B4kAGj7NAcCIR/LXaXLGpF9OLFYBBaw86AVk+r13wVFkwiI2ISo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975023; c=relaxed/simple;
	bh=XPfTA+i3GHvfhF7NBB/wYJWva0qowgjgMlxbg2+3xfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUzl9sSdzLE1ffpW9HJ0q444FvF5l68kk8D8d3izWisBAkuJbeva9MGW2I9Sp5BvPqU2pJxjSyIzliyNIm7z0rjbyu9sjH6SWNyT5YvqG8YOc7BHvqLcszOADsnXaR2XpDcX8bNmF8kcjSPDiOeAUbj6ybt1euO8TA8jGXwT1jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDb+B2yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDb+B2yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC710C43390;
	Tue, 23 Jan 2024 01:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975022;
	bh=XPfTA+i3GHvfhF7NBB/wYJWva0qowgjgMlxbg2+3xfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDb+B2yr6w+Z+58aXwzD9DN/k7Cel10UCligH/C0BE05cSvqjHj+hkejDCiEBfH7f
	 8itkJs2s1FZVolKgqhxqYVCBAj/Q74IZPHrIsPdpB+U2Z5PukkbRkwl91Vmje+0tZm
	 Vd2QIX69l1T8/kt7+qRUE2fqpKV+kAFAgGxibiK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/583] wifi: iwlwifi: mvm: send TX path flush in rfkill
Date: Mon, 22 Jan 2024 15:54:11 -0800
Message-ID: <20240122235818.099906747@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 177a4628a913..6fdb2c38518e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2236,7 +2236,7 @@ int iwl_mvm_flush_sta_tids(struct iwl_mvm *mvm, u32 sta_id, u16 tids)
 	WARN_ON(!iwl_mvm_has_new_tx_api(mvm));
 
 	if (iwl_fw_lookup_notif_ver(mvm->fw, LONG_GROUP, TXPATH_FLUSH, 0) > 0)
-		cmd.flags |= CMD_WANT_SKB;
+		cmd.flags |= CMD_WANT_SKB | CMD_SEND_IN_RFKILL;
 
 	IWL_DEBUG_TX_QUEUES(mvm, "flush for sta id %d tid mask 0x%x\n",
 			    sta_id, tids);
-- 
2.43.0



