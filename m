Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5458B25771;
	Wed,  2 Oct 2024 13:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875382; cv=none; b=u/7f65pe6rROf0qYpMo7p+FIYhJGGvBC8qSfd2Bq7WGzZCmuxKDQLUZ6wTQQKWtndjqJcHXKp5mWEwOlZAO1aLaSs22ZYo7xG7b2CrDbkHl6VZvNPz2rYwQNevR+aUrqwKpa690UzkX1vwLLEjzEyI6qJRtR1ARPu/+HGCl7f6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875382; c=relaxed/simple;
	bh=ayOoXitWaCorY1ZvVoVRzJiH9Ake99RvbIHs53no65c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTtAKvOicZ9Bo06rTlS+6pNPJ7CHNWdwYW7fcZTMjVb8wqa3sA905p+nyVqKAht5DRAMUdhRaqwscRL7gvVMSwTuNkNBpZTg7uMU++fWYL5sJZ21E+Y4wXZ7AfS5H4Ag0xIqh1LiNEEVk0UA0G8ha7tTnK8KxcPd0Az967hXA5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=by6fyF4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="by6fyF4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD747C4CEC5;
	Wed,  2 Oct 2024 13:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875382;
	bh=ayOoXitWaCorY1ZvVoVRzJiH9Ake99RvbIHs53no65c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=by6fyF4xGZ/+/KQhDua9mcESleLlwqx+irL4J5R79Z33/S9igDhNpfPABhj9hV1+o
	 LCYlkL67AadAUgLaWHjXfywab/cQIieCVGTPlwuZGI6EXKRIFUxf6jA+asFZJDdU0j
	 kGsj2gtrg7SliL2ygSIYMPM6XSFOrbpY2Jn7OWUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 052/695] wifi: iwlwifi: mvm: allow ESR when we the ROC expires
Date: Wed,  2 Oct 2024 14:50:50 +0200
Message-ID: <20241002125824.564486242@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index a8c42ce3b6300..72fa7ac86516c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -114,16 +114,14 @@ static void iwl_mvm_cleanup_roc(struct iwl_mvm *mvm)
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



