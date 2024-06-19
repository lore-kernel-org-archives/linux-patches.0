Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282394D9EA;
	Wed, 19 Jun 2024 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803595; cv=none; b=R0DiE/gEELgZk/UnN6NOH4X+y+FDUSGOEkcIckSmK9+iEjASitzxvF/ZtE68mO5q809XxX/ugI1EOWgKGzMWO7tKUw+aUYv7V9dFcKDsIseh8WfhEIoY3/YWUCG+4oAOcuyeP6dU+/ymGVfHjjk0tkj6MEzxXQwTnL6jDwF7leY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803595; c=relaxed/simple;
	bh=UFH+z++fwcz7jg7M/pGHlR7eD0o/IbQhQ/eeo023tUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHoqp6OGA5gS0isVd8ysZiQXkeejYylC+VVVivlEwsbWdrgEG4twWLaP5PnCSOx6LSitLpWQ9/+On+ptMKbVmw5rfDgJ1R0HxWL319NLOa9FQ4B3I4Ugv3XfOGyWhr+hR9te1f+polqPh5WWczypARczSQudyswz/wAyNKR5bVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIgVBcZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIgVBcZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15EBC2BBFC;
	Wed, 19 Jun 2024 13:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803595;
	bh=UFH+z++fwcz7jg7M/pGHlR7eD0o/IbQhQ/eeo023tUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIgVBcZpAuOgjvZqimrnxUMU6ikBNdV3BnuQH37rVXZhiPw488O4itISc3TbuLSPd
	 sFVXEcqYGz+V5m4An+8Ip2F2AFeC3iEIw+PemzVA2zPd6V4phbBBfVMFOXy906QJ3Z
	 B8Ak4hM5Mz8QBIMDkdSn/8QfpGUqRsOaax6BXUfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/217] wifi: iwlwifi: mvm: dont read past the mfuart notifcation
Date: Wed, 19 Jun 2024 14:54:12 +0200
Message-ID: <20240619125556.864137693@linuxfoundation.org>
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
index 2e3c98eaa400c..668bb9ce293db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -91,20 +91,10 @@ void iwl_mvm_mfu_assert_dump_notif(struct iwl_mvm *mvm,
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



