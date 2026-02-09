Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B4037AA91;
	Mon,  9 Feb 2026 14:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647368; cv=none; b=GvalsCAbo7UUooemGKIJQtXk41YAkU1n6pMWRRXFQpYp6REKdRXBaQe7amGBtdCnEcZhs+CwRXGU8v2/89IDUhmL6QnkfzN2JtCiOWTaHS5w6H0WfxvjcpkSQVddXisjo6Xxl2vZKslKk06hbh1IQ7dxG8bTnwvebG3Gl6QtVrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647368; c=relaxed/simple;
	bh=ZDrPqthF83bbNwtv//zZGZ2Qsm6ulrAJ9DSZmKB1czk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL6c4pGA9epf2Ue8K0uLVEfCpHGJiFWe5+UnUBeVL33V99FG3wMPdVc5Q02xi+0pudP2yuqGchxLTc/VboXPh2pHktIgVK2XHKmlj48fqZZlVkVpRIZ08ZLeo/gFAzuNfsYtbVzOynwXXyhK0VhLa65SadEG0+O6RpoYqU66sqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojEEHfMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojEEHfMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C54C16AAE;
	Mon,  9 Feb 2026 14:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647368;
	bh=ZDrPqthF83bbNwtv//zZGZ2Qsm6ulrAJ9DSZmKB1czk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojEEHfMKqy9g2A3oBd7rVCifz90HjC2739BC9mshEEhvV+y/yqolKUAVsHPCx3mQW
	 cAHeLcZdDahukUR+PKUKjIX/k5VZgzSH04NnFC8iM9H3bCKpFYX+8vYwIuB/8rn6lL
	 R3uu7KtZuA7KGHLg7eMVDi4ei1PpIGQq7XYqbK8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Yao Zi <ziyao@disroot.org>,
	Simon Horman <horms@kernel.org>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/175] wifi: iwlwifi: Implement settime64 as stub for MVM/MLD PTP
Date: Mon,  9 Feb 2026 15:22:05 +0100
Message-ID: <20260209142322.340906918@linuxfoundation.org>
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

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 81d90d93d22ca4f61833cba921dce9a0bd82218f ]

Since commit dfb073d32cac ("ptp: Return -EINVAL on ptp_clock_register if
required ops are NULL"), PTP clock registered through ptp_clock_register
is required to have ptp_clock_info.settime64 set, however, neither MVM
nor MLD's PTP clock implementation sets it, resulting in warnings when
the interface starts up, like

WARNING: drivers/ptp/ptp_clock.c:325 at ptp_clock_register+0x2c8/0x6b8, CPU#1: wpa_supplicant/469
CPU: 1 UID: 0 PID: 469 Comm: wpa_supplicant Not tainted 6.18.0+ #101 PREEMPT(full)
ra: ffff800002732cd4 iwl_mvm_ptp_init+0x114/0x188 [iwlmvm]
ERA: 9000000002fdc468 ptp_clock_register+0x2c8/0x6b8
iwlwifi 0000:01:00.0: Failed to register PHC clock (-22)

I don't find an appropriate firmware interface to implement settime64()
for iwlwifi MLD/MVM, thus instead create a stub that returns
-EOPTNOTSUPP only, suppressing the warning and allowing the PTP clock to
be registered.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20251108044822.GA3262936@ax162/
Signed-off-by: Yao Zi <ziyao@disroot.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
tested-by: damian Tometzki damian@riscv-rocks.de
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251204123204.9316-1-ziyao@disroot.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
index ffeb37a7f830e..231920425c066 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -121,6 +121,12 @@ static int iwl_mld_ptp_gettime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int iwl_mld_ptp_settime(struct ptp_clock_info *ptp,
+			       const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
 static int iwl_mld_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct iwl_mld *mld = container_of(ptp, struct iwl_mld,
@@ -279,6 +285,7 @@ void iwl_mld_ptp_init(struct iwl_mld *mld)
 
 	mld->ptp_data.ptp_clock_info.owner = THIS_MODULE;
 	mld->ptp_data.ptp_clock_info.gettime64 = iwl_mld_ptp_gettime;
+	mld->ptp_data.ptp_clock_info.settime64 = iwl_mld_ptp_settime;
 	mld->ptp_data.ptp_clock_info.max_adj = 0x7fffffff;
 	mld->ptp_data.ptp_clock_info.adjtime = iwl_mld_ptp_adjtime;
 	mld->ptp_data.ptp_clock_info.adjfine = iwl_mld_ptp_adjfine;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
index 06a4c9f74797a..ad156b82eaa94 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -220,6 +220,12 @@ static int iwl_mvm_ptp_gettime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int iwl_mvm_ptp_settime(struct ptp_clock_info *ptp,
+			       const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
 static int iwl_mvm_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct iwl_mvm *mvm = container_of(ptp, struct iwl_mvm,
@@ -281,6 +287,7 @@ void iwl_mvm_ptp_init(struct iwl_mvm *mvm)
 	mvm->ptp_data.ptp_clock_info.adjfine = iwl_mvm_ptp_adjfine;
 	mvm->ptp_data.ptp_clock_info.adjtime = iwl_mvm_ptp_adjtime;
 	mvm->ptp_data.ptp_clock_info.gettime64 = iwl_mvm_ptp_gettime;
+	mvm->ptp_data.ptp_clock_info.settime64 = iwl_mvm_ptp_settime;
 	mvm->ptp_data.scaled_freq = SCALE_FACTOR;
 
 	/* Give a short 'friendly name' to identify the PHC clock */
-- 
2.51.0



