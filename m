Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D2CFC1F;
	Wed, 19 Jun 2024 12:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801889; cv=none; b=lOHyblXvGz9z5QH4rI+x7JxCI+Y6z4kqZyvIWYL33X826lsFwgnORe2lInuNCzeQeF0k7nBzhYZsZfAxveLzSPXkadM+88uUclajQmyd8NkEPkla5GeqHcBqlEKfjt8fx1VcQAnMhLk1PKDLsniaNTJ/Qkiaylr+6A1m6Dv7XPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801889; c=relaxed/simple;
	bh=zJV4Kgs/DdST+k66n3CnyYjomGqwfq37wZ5laJOYB8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3o+AUa9QA+MgEvNb9kYAmjLJDMWhNdPBuG6BdTkUc8a/AIM/62jNvf82ZKFS94HdEr3RFQUu87PeZUeU4m1vxDHFXJxk6u2NX9dmCESvgFccRf+TvBHHSGtWttYjugVWMe0wg10BReGuQTCmwgXzlBlPNGR5axu6UkFvFSjIjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikCCahNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikCCahNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86BDC2BBFC;
	Wed, 19 Jun 2024 12:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801889;
	bh=zJV4Kgs/DdST+k66n3CnyYjomGqwfq37wZ5laJOYB8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikCCahNM446qckS8OHUhoBXPCJdyGWyJhMK3dZhvp7Kh62VURO8ik4/EXbrfHLWMC
	 n9nj80Vpa6dCznT4/lQDeFmtB1b2+xO87ep/B0kKEVrB1kRbNUHtCRYIQ7A0Qui6ah
	 er9bRunRFXGnaaB9TGJrsjgfJFh1btA2ahoxGwb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/267] wifi: iwlwifi: mvm: dont read past the mfuart notifcation
Date: Wed, 19 Jun 2024 14:52:42 +0200
Message-ID: <20240619125606.787199502@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 4bb95f4535489ed830cf9b34b0a891e384d1aee4 ]

In case the firmware sends a notification that claims it has more data
than it has, we will read past that was allocated for the notification.
Remove the print of the buffer, we won't see it by default. If needed,
we can see the content with tracing.

This was reported by KFENCE.

Fixes: bdccdb854f2f ("iwlwifi: mvm: support MFUART dump in case of MFUART assert")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240513132416.ba82a01a559e.Ia91dd20f5e1ca1ad380b95e68aebf2794f553d9b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 1d5ee4330f29f..51f396287dc69 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -92,20 +92,10 @@ void iwl_mvm_mfu_assert_dump_notif(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mfu_assert_dump_notif *mfu_dump_notif = (void *)pkt->data;
-	__le32 *dump_data = mfu_dump_notif->data;
-	int n_words = le32_to_cpu(mfu_dump_notif->data_size) / sizeof(__le32);
-	int i;
 
 	if (mfu_dump_notif->index_num == 0)
 		IWL_INFO(mvm, "MFUART assert id 0x%x occurred\n",
 			 le32_to_cpu(mfu_dump_notif->assert_id));
-
-	for (i = 0; i < n_words; i++)
-		IWL_DEBUG_INFO(mvm,
-			       "MFUART assert dump, dword %u: 0x%08x\n",
-			       le16_to_cpu(mfu_dump_notif->index_num) *
-			       n_words + i,
-			       le32_to_cpu(dump_data[i]));
 }
 
 static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
-- 
2.43.0



