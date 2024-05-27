Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5303515FA85;
	Mon, 27 May 2024 19:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836572; cv=none; b=BpI9WtbZEHR/ETSwky1NDBP2Q3retlPwl2XryQspOOcZW0lrm0apVNhD/DbMTQpHr1UyNfgCMmdM8zEakdqSN8JDHFZK6anWINhH9gH0Ckop2eHAc3LrfQunJGV6wLkixzNNq9LIi1SH+AFTqhFOa1b2+/QLmKLJ+eZBp3OHwgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836572; c=relaxed/simple;
	bh=rVn6hXjLlsrfD+p5xUgbLD011agN8DgJxi2YBjqhQaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eef+vyRUe8crOghrtR/8Qr4TcRdnzieTNcyFPPsXdM64e87WFG8+hA7G3dflVTGm1mQ/EyeBbJ6ZvKyiNfmHavLZdQOW4juJot7f1ezha8vQHv4LILlp/DISJCJM2r7VhrJkigwnD7DG45MRfESEbQp9exBe9TrBE/O191ykQow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQwPFMGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQwPFMGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CF1C2BBFC;
	Mon, 27 May 2024 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836571;
	bh=rVn6hXjLlsrfD+p5xUgbLD011agN8DgJxi2YBjqhQaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQwPFMGt7onsRc7V1jO7Esv8FHhZhIAl9UlmT+x1soCbWRjjJ/xtdzcG55BOK97sh
	 2LqJB83Pg43A+T5ZjlZsSSX2mqCRtGMGOH17fSjZmiPRKCiu1nOz8/VFWx5YsU/ekM
	 8uEgMp9KH2nVNshiTiMJUI8u5TCqGUlwgD+jE8PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 107/427] wifi: iwlwifi: reconfigure TLC during HW restart
Date: Mon, 27 May 2024 20:52:34 +0200
Message-ID: <20240527185611.801433455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 96833fb3c7abfd57bb3ee2de2534c5a3f52b0838 ]

Since the HW restart flow with multi-link is very similar to
the initial association, we do need to reconfigure TLC there.
Remove the check that prevented that.

Fixes: d2d0468f60cd ("wifi: iwlwifi: mvm: configure TLC on link activation")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320232419.a00adcfe381a.Ic798beccbb7b7d852dc976d539205353588853b0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 5a4973431c8b7..32ccc3b883b2c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -295,13 +295,8 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
 	 * this needs the phy context assigned (and in FW?), and we cannot
 	 * do it later because it needs to be initialized as soon as we're
 	 * able to TX on the link, i.e. when active.
-	 *
-	 * Firmware restart isn't quite correct yet for MLO, but we don't
-	 * need to do it in that case anyway since it will happen from the
-	 * normal station state callback.
 	 */
-	if (mvmvif->ap_sta &&
-	    !test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+	if (mvmvif->ap_sta) {
 		struct ieee80211_link_sta *link_sta;
 
 		rcu_read_lock();
-- 
2.43.0



