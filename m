Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9589714A088;
	Wed,  5 Feb 2025 14:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765312; cv=none; b=PSnQFG2luxVy9ZbLcFIj5Xueg7ujUzCZbxFJDiM1H1kDZ7hwe+CPBNnmlRm9aNm2ml6gIvHoBDKkk0X1e6ZcIq3xfhNcOdBC6gWDKgii6vQLEt96X1GPIP6M7goWqGP/ZhVH/u35ABkC7fQfFWkOEKxpKW53LBX5AjT9M32Ggsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765312; c=relaxed/simple;
	bh=JO+952px7zutv2OsEgbaxtNloTW4xYQGanWYzN/9kwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1r33PDl/vT/mky46inZy1LB11gyP35B5vGdJTYavvBTVmmjGkq+xJ6PqjT1IOxTT4jGtEqPwXMJKqwk0vT+CfdR5rJi65Qew9uSNm5jk5nxpOZl8r0yHdBeXg+hWsTV8O91z+1DXX81L6+NnWwjHJosCdgN9lh+w5SQQ5ksF5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2t9LYef4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2t9LYef4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04257C4CED1;
	Wed,  5 Feb 2025 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765312;
	bh=JO+952px7zutv2OsEgbaxtNloTW4xYQGanWYzN/9kwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2t9LYef45XqVj/jY+ia/xnG4DPMeyioFdAmKBNfFELSP9SyzXteSO86ai38Lml9Cx
	 6ne/Y4kP3ZTVDbb66PYh8wImbV2gQpxHxb9PrnGI+WcRHvmIptnOuuyQEIalJbmaLw
	 Xnm9uVb9Ft9gZxFyOLbW3Xa0D5h5wKkP6Qd/ty1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 165/623] wifi: iwlwifi: mvm: dont count mgmt frames as MPDU
Date: Wed,  5 Feb 2025 14:38:27 +0100
Message-ID: <20250205134502.548442081@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c9867d26361b6..998a390a70bbc 100644
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



