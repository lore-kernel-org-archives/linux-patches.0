Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CC41D097B;
	Wed,  2 Oct 2024 13:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877324; cv=none; b=Pcl2LvHPeuF3mkMo5PVI1mvBOwG6U6bkDoKUrOiUimiZpDsVRAFUSmfiarTY4THwgIK8mXXx/WSzWaTdOiinWCrxsZ87PuzbSBS5p3TOPl8E5+/xpa/M8xuUUEz68aDgiiTKjmKPB2AYUZoUIHN7xHK87DsfiT3V3O7dceUv5R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877324; c=relaxed/simple;
	bh=UgRuBog9DlszqXspygK7t5AbvTu4IgyXTXVGEdoHWoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOUIos1JAcTP4z55YjmyBPTsYhOrOO3nsja2uNOjQBdCPGpkE0QF/k0h4blnWWt1LYt6dz7hCnTPEqz6B/Xnql2Ldw+e9QTD1dD5vIz1QYDnpbTJn6cw9vQ5BJoT+un3Iv0GlLLH6tEOF8OMOXPjyvdBXwDjI6ZYB2mjfr+5CmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2rRA9ej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2rRA9ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3371EC4CED6;
	Wed,  2 Oct 2024 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877323;
	bh=UgRuBog9DlszqXspygK7t5AbvTu4IgyXTXVGEdoHWoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2rRA9ej4m5tauU4t0hxgysZCd5fqxJtXnpqMt4IfGdRYXdloyQyFwx/SB26qZiML
	 vrMq0zuaE6ry7OizDz1H3bMPRT9kZyZ7YoaY5UOyJ99IqVn1yBlqNLcGDCD/gvtvb3
	 9kf9SIOtFmFI6gD46RI8Uod0/kCqoKH2N4NZmRzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 043/634] wifi: iwlwifi: mvm: allow ESR when we the ROC expires
Date: Wed,  2 Oct 2024 14:52:23 +0200
Message-ID: <20241002125812.802148510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 76364f3edfde60aa2fa20b578ba9b96797d7bff5 ]

We forgot to release the ROC reason for ESR prevention when the remain
on channel expires.
Add this.

Fixes: a1efeb823084 ("wifi: iwlwifi: mvm: Block EMLSR when a p2p/softAP vif is active")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.8f8765f359cc.I16fcd6198072d422ff36dce68070aafaf011f4c1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 9d681377cbab3..f40d3e59d694a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -107,16 +107,14 @@ static void iwl_mvm_cleanup_roc(struct iwl_mvm *mvm)
 		iwl_mvm_flush_sta(mvm, mvm->aux_sta.sta_id,
 				  mvm->aux_sta.tfd_queue_msk);
 
-		if (mvm->mld_api_is_used) {
-			iwl_mvm_mld_rm_aux_sta(mvm);
-			mutex_unlock(&mvm->mutex);
-			return;
-		}
-
 		/* In newer version of this command an aux station is added only
 		 * in cases of dedicated tx queue and need to be removed in end
-		 * of use */
-		if (iwl_mvm_has_new_station_api(mvm->fw))
+		 * of use. For the even newer mld api, use the appropriate
+		 * function.
+		 */
+		if (mvm->mld_api_is_used)
+			iwl_mvm_mld_rm_aux_sta(mvm);
+		else if (iwl_mvm_has_new_station_api(mvm->fw))
 			iwl_mvm_rm_aux_sta(mvm);
 	}
 
-- 
2.43.0



