Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B83E4E77FA;
	Thu, 17 Sep 2026 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668445; cv=none; b=RtJyqQtGkBETHOTSlRw/ExIJkpaWbjt4C+xJWOCnrRZEtSiduJSqQYutAi0SgpL9NaY6S5xVvNEQcKPpdKXKN3hEGkVcnPNhh3YfVX5A0hoy6m+J8BrcQWommyY33KaOdlGTDen6TDbL2FjycYS/5fksq4KB7/qqZ9UIsVFeiUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668445; c=relaxed/simple;
	bh=0Q4bZgBp3Kzd8lVa2QJgOmzzLxlUcNmPZ1bTeHng/e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVNu8TSrZtOQE7ZW+YztNc7p+0JtQoJZdgkvBKHfsOZf5+PyIdpyVPcKOQDQ9EDfGcphPlQePnLtFtHVAKrBlyq82L3SqfBJvHXhYEJSW3oJirPSjmCYLzPkvJRKCorZdzGQZi1ZkZJR+281+w15WoFJeN1UdALfvtL1TdoH/FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP5pne7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP5pne7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87871F000FF;
	Thu, 17 Sep 2026 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668443;
	bh=Z8LoVCg4jwg+bdFMh4bleNhAcKoO1Gsfg3lzjllVD8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CP5pne7/GlF522JYfv/D8E4pfUsv74yxh0+N6hKrgSHgcVddhgzotsjtC3OIjsKuT
	 ne9TM9kNCwcbC6oIwN/7iWSMAA9MRebLJz1+bB0fONshSoX9rGuWyd46jKp8aMu9OU
	 vw7Ht5ZBr4S1J2QtQPvH8yLCWg2hS1HCEJG88CkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0427/1102] wifi: iwlwifi: mvm: add a check on the tid coming from the firmware
Date: Thu, 17 Sep 2026 16:06:10 +0100
Message-ID: <20260917151550.391653277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0e4c0d83267261cf67ec9690856edf4a56bb7dfc ]

ba_notif->tid is a firmware-controlled u8 that is used directly
as an array index into tid_data[] without any validation. Add a
bounds check against IWL_MAX_TID_COUNT before dereferencing the
array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.d7c3e75d47af.If88948108cfc8b5fb3ce5531d927855d1b3b6b30@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index c1fc45cb7e025..e70c26deb8b8f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2308,6 +2308,9 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	ba_notif = (void *)pkt->data;
 	sta_id = ba_notif->sta_id;
 	tid = ba_notif->tid;
+	if (IWL_FW_CHECK(mvm, tid >= ARRAY_SIZE(mvmsta->tid_data),
+			 "invalid TID %d in BA notif\n", tid))
+		return;
 	/* "flow" corresponds to Tx queue */
 	txq = le16_to_cpu(ba_notif->scd_flow);
 	/* "ssn" is start of block-ack Tx window, corresponds to index
-- 
2.53.0



