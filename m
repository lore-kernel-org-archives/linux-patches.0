Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EE83FFE;
	Tue, 23 Jan 2024 00:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970932; cv=none; b=kMNn3rLRGw/NX8si8ftDIBG9K7fH3vI/NUoX8SMo0T2LkXH0eZpoYi2jWMFmTsE8Gsb0EBsEcs6fJCmu7B5pnkBtq6TDDTLyStXFlnMVKDpYg0B+aUvNCOntXCz81Ro/qlJlUTuHAcD7B/bxlm68w3/J4SnPjgl+hyAk0WcDytY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970932; c=relaxed/simple;
	bh=gMGxjoBUKWLA4JhpoHklm5MLhXLmFLTfY7Sq6Pxa8co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peXYxNSsZcdZeVPIaXCshY9USIU5TXbqcK5hW/8RsI05jtu4SlS0RlrFhsDV/AXeWSDdUs4zdk4FeHJE1ajOaqo4cV3hLMplCh+W8C1jBc5DDbiqo9rQzJ8DIyOqXq4Ul4gc0sq3MQR7dzxntUIVdf3ImR7U/uHC2larGWasoco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2eyiyuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2eyiyuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2FAC433C7;
	Tue, 23 Jan 2024 00:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970932;
	bh=gMGxjoBUKWLA4JhpoHklm5MLhXLmFLTfY7Sq6Pxa8co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2eyiyuRWg6vqDJIVSxqZqZn6bxJmayreYl1vdPEdPyKmI4tVsozUn1OAxrKKDj1S
	 pZaCJtrkcPAQvlKFmO9V2MLChgJNpf9dg6PEAKrlQug7SxhVmHryJ/6EvJ7UiN5GDb
	 OjbAlpWk4MASe3TAboV0q6sZ25I4l5wt9IOEKuSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/417] wifi: iwlwifi: mvm: send TX path flush in rfkill
Date: Mon, 22 Jan 2024 15:55:10 -0800
Message-ID: <20240122235756.747193046@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index caaf4d52e2c6..76219486b9c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2200,7 +2200,7 @@ int iwl_mvm_flush_sta_tids(struct iwl_mvm *mvm, u32 sta_id, u16 tids)
 	WARN_ON(!iwl_mvm_has_new_tx_api(mvm));
 
 	if (iwl_fw_lookup_notif_ver(mvm->fw, LONG_GROUP, TXPATH_FLUSH, 0) > 0)
-		cmd.flags |= CMD_WANT_SKB;
+		cmd.flags |= CMD_WANT_SKB | CMD_SEND_IN_RFKILL;
 
 	IWL_DEBUG_TX_QUEUES(mvm, "flush for sta id %d tid mask 0x%x\n",
 			    sta_id, tids);
-- 
2.43.0



