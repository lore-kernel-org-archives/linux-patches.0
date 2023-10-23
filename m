Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0747F13FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vdjty33r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778ABC433C7;
	Mon, 23 Oct 2023 11:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059250;
	bh=SPLVXAwqJGtchHlV1C73jT3GFdV7ygxRV+6VOi3bpUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vdjty33r0IqIxWNXPJKTqMzc6nDXYAm6idVnuK/3d8FtXZGQ6+shzvLWlhvbYAZMm
	 bThoegMJPfohmxxlHGPfJz2SYCReXV/xBrolcUYFifxkYDtAWS8iacNDCqR5DnE2QV
	 tiCziMbH9Hx4+pP1Hn+1f4wtDOFrGdtgM2zjZ624=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 114/241] wifi: iwlwifi: Ensure ack flag is properly cleared.
Date: Mon, 23 Oct 2023 12:55:00 +0200
Message-ID: <20231023104836.666723937@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit e8fbe99e87877f0412655f40d7c45bf8471470ac ]

Debugging indicates that nothing else is clearing the info->flags,
so some frames were flagged as ACKed when they should not be.
Explicitly clear the ack flag to ensure this does not happen.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Acked-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230808205605.4105670-1-greearb@candelatech.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 36d70d589aedd..898dca3936435 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1612,6 +1612,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		iwl_trans_free_tx_cmd(mvm->trans, info->driver_data[1]);
 
 		memset(&info->status, 0, sizeof(info->status));
+		info->flags &= ~(IEEE80211_TX_STAT_ACK | IEEE80211_TX_STAT_TX_FILTERED);
 
 		/* inform mac80211 about what happened with the frame */
 		switch (status & TX_STATUS_MSK) {
@@ -1964,6 +1965,8 @@ static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
 		 */
 		if (!is_flush)
 			info->flags |= IEEE80211_TX_STAT_ACK;
+		else
+			info->flags &= ~IEEE80211_TX_STAT_ACK;
 	}
 
 	/*
-- 
2.40.1



