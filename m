Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F9827A935;
	Tue, 27 May 2025 17:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366901; cv=none; b=Wu/PfSiCryN9gLBKqeWDy6+MYWt+MJLl/MEueuKX3hMqWNfNQFusQ6jZ8pmwXpo2ImV3X0/d3U5EXXesZbKmCMt1XJb5kGl6ZmD5PzDfUwh8bekcFNpD8u7UCntiapuQCZg2uyAaCq/01Q/xfj79DZDuXTYAdrjsMEe9QApx7B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366901; c=relaxed/simple;
	bh=Q8jFp0cpoMCZk4qhs2plV+3HrfBOesdllWWaxUk9BmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OM4xdZ0OoZoqhF0eZyqLF6XSfkukYmAKoVpu5eTcWDChi+jJiT3rfkMS0SpDk4X+LFXeBwbKCpagqSUwkRwI/Ie0iqgT04ADMFMf5eOTodcnL/3eF6gzRKldG761rrTmjD1dwYRQdqacWUlTvAhDuZOnOvUDPIDjpjp6vJWSUGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDnnv25a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDnnv25a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E944C4CEE9;
	Tue, 27 May 2025 17:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366901;
	bh=Q8jFp0cpoMCZk4qhs2plV+3HrfBOesdllWWaxUk9BmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDnnv25a9GyWa1yjK0SXimyroRyfvH0KF8gl/kvRBjedylEuptp+2T9LMDZb41Pg0
	 NFDwGjBYoXFyBYDGMFjdS2rQgwgt2JuVlxk0flS4saiFBMWCaimz/U62Lalnj0NiCF
	 QFuYJzOFUIBdiVrk8GYVkWviF5kgM7EBk4RJdFK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 212/783] wifi: iwlwifi: mvm: fix setting the TK when associated
Date: Tue, 27 May 2025 18:20:09 +0200
Message-ID: <20250527162521.766715446@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 3ad61970ac9e164be1b09b46c01aa942e8966132 ]

When running secured ranging and the initiator is associated with
the responder, the TK was not set in the range request command.
Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231427.603dc31579d9.Icd19d797e56483c08dd22c55b96fee481c4d2f3d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index b26141c30c61c..0a96c26e741b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -773,7 +773,11 @@ iwl_mvm_ftm_set_secured_ranging(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 			target.bssid = bssid;
 			target.cipher = cipher;
+			target.tk = NULL;
 			ieee80211_iter_keys(mvm->hw, vif, iter, &target);
+
+			if (!WARN_ON(!target.tk))
+				memcpy(tk, target.tk, TK_11AZ_LEN);
 		} else {
 			memcpy(tk, entry->tk, sizeof(entry->tk));
 		}
-- 
2.39.5



