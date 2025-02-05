Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B053214D2A2;
	Wed,  5 Feb 2025 14:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764812; cv=none; b=NT6VksiecM2KrDqM9fPpMPiDspM/oOcTpSsRv3vRtNbCAgGuKaMdW2VXDCwas0bLfNG7/TTcQU80ftqei2lYQ5hp4GgHM4VPBmsfd/5jQT/sMsgoZEAsuT8Od351Z1meyMjeddGbzH2S3iXScCNRrKV4hJuiB4oNGmowsXd7TbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764812; c=relaxed/simple;
	bh=x6rTJQ9NN0n/UlO9nP7auI0YAefnaiHuBibs8xjDDLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHK66v4Y628lVP45HcK3ViP3ENqXCk/uwTxsC+WsnWRM3VPIKCJXGGOjNa8P1G1sMg9MJCmrtqh9797YtY6/802pmd80GKH7UXAjlwgCtHY6RTwOpMgCc4ZNfDz3cLmMpCGoJH4lPInRba574lJZ/MZZg7JN7oZeFjG9XnunUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVULitpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVULitpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EA1C4CED1;
	Wed,  5 Feb 2025 14:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764812;
	bh=x6rTJQ9NN0n/UlO9nP7auI0YAefnaiHuBibs8xjDDLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVULitpF8SVkX3jEwoOIeKXBFyXxyJmJ/Jan8CnR0WBiSxmNh3AwwckMx3DRibK6w
	 Tbsb0+tDSDQBc+YILbfWwasx/Atat4GfPCyUTBWzx7h7OSPVPk4pyJpno52Syt8Yma
	 Jxn9/q/ddJyrCvpShx9vM8dba8/LjBMe9ehTgW7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/590] wifi: iwlwifi: mvm: dont count mgmt frames as MPDU
Date: Wed,  5 Feb 2025 14:38:35 +0100
Message-ID: <20250205134501.406085497@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit 76260267ba26a6e513acefa5e7de1200fbeb5b5d ]

When handling TX_CMD notification, for mgmt frames tid is equal
to IWL_MAX_TID_COUNT, so with the current logic we'll count
that as MPDU, fix that.

Fixes: ec0d43d26f2c ("wifi: iwlwifi: mvm: Activate EMLSR based on traffic volume")
Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241229164246.80b119bb5d08.I31b1e8ba25cce15819225e5ac80332e4eaa20c13@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ca026b5256ce3..5f4942f6cc68e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1880,7 +1880,9 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 				IWL_DEBUG_TX_REPLY(mvm,
 						   "Next reclaimed packet:%d\n",
 						   next_reclaimed);
-				iwl_mvm_count_mpdu(mvmsta, sta_id, 1, true, 0);
+				if (tid < IWL_MAX_TID_COUNT)
+					iwl_mvm_count_mpdu(mvmsta, sta_id, 1,
+							   true, 0);
 			} else {
 				IWL_DEBUG_TX_REPLY(mvm,
 						   "NDP - don't update next_reclaimed\n");
-- 
2.39.5



