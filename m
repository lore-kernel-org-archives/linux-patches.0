Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33779285060;
	Mon,  9 Feb 2026 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647590; cv=none; b=lEKCN7T9hr5RAc92D7tyX4VJFYeFo1E/h0Fl2l3dWkusHtM96XWCeORQfG6DhfzSox8wNhN6ojYxJojzDOED7cITSDwV04E2GD4sS2vYm+FAStKtpyn806Lb4wzbPKzSCNkG5M2DGzjY1346LeR+GBK+3/POlg7H8h6JMHkj9J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647590; c=relaxed/simple;
	bh=EyVIv4mTRx8k3fmyEOuMSRAdkeBt/OsnFoY0jazB+lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw3ydGXN3si/YhhJ8TRiHI8UhykviVF6TahLINivZCjwDta7HBlTP2m47gngTWOuhreRiM2DD46r/zvS7cfg/kJsX0caD/dvirlqHWYwK+Cx+fxzIZ1VmdtLUXyh76qA9Bu3ncuzA2B9DpTD560ON0GRSO5scY02Ycw3M0w05eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFUaOqSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFUaOqSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FCFC19422;
	Mon,  9 Feb 2026 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647590;
	bh=EyVIv4mTRx8k3fmyEOuMSRAdkeBt/OsnFoY0jazB+lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFUaOqScJppSI9KI4nKieAIXfDjUCzM8g7/RKseCCP3RVO0FBNytqqFJ+Suvz9j7n
	 bl3iTD0fFLKQZM5AuVYdvlQahDY1asqki11/ht7vVorVyeVTCl4S5mIPKM0IxSwM4u
	 gDeq8mJljazCFZ+dgpiqfuZ9US+jyetubVUq1ulY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/175] wifi: iwlwifi: mvm: pause TCM on fast resume
Date: Mon,  9 Feb 2026 15:23:38 +0100
Message-ID: <20260209142325.721181901@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit fb7f54aa2a99b07945911152c5d3d4a6eb39f797 ]

Not pausing it means that we can have the TCM work queued into a
non-freezable workqueue, which, in resume, is re-activated before the
driver's resume is called.
The TCM work might send commands to the FW before we resumed the device,
leading to an assert.

Closes: https://lore.kernel.org/linux-wireless/aTDoDiD55qlUZ0pn@debian.local/
Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Fixes: e8bb19c1d590 ("wifi: iwlwifi: support fast resume")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260129212650.05621f3faedb.I44df9cf9183b5143df8078131e0d87c0fd7e1763@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 07f1a84c274ef..af1a45845999b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -3239,6 +3239,8 @@ void iwl_mvm_fast_suspend(struct iwl_mvm *mvm)
 
 	IWL_DEBUG_WOWLAN(mvm, "Starting fast suspend flow\n");
 
+	iwl_mvm_pause_tcm(mvm, true);
+
 	mvm->fast_resume = true;
 	set_bit(IWL_MVM_STATUS_IN_D3, &mvm->status);
 
@@ -3295,6 +3297,8 @@ int iwl_mvm_fast_resume(struct iwl_mvm *mvm)
 		mvm->trans->state = IWL_TRANS_NO_FW;
 	}
 
+	iwl_mvm_resume_tcm(mvm);
+
 out:
 	clear_bit(IWL_MVM_STATUS_IN_D3, &mvm->status);
 	mvm->fast_resume = false;
-- 
2.51.0



