Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AD3151CFE;
	Tue, 20 Feb 2024 21:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464465; cv=none; b=MaRuYDTlj/viwjR3ce4jMyiordX6DkDiEwEFn2sk4Z7vwWHY22dgsfgmD2+vZZra53sjXHrea7o8BtU1JtTwoQYCqE7FcWRjOX42hIe072zvO6qUWZL+F07yWdPmBogTg4waKswvA9vh9KPQ262+zJYNeHoF6mvYs4j8jJI+KJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464465; c=relaxed/simple;
	bh=eWhX/LHA8X834DClTzJTAI5SrlchCHwZdORprW1Y8gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tj7IdNLfd1XqcQYmZnzJ2rd7ZSxOwveJqPGpcFbwc7q1teVvQn0y3aOfBqo3uoDyK63sxoN5IFYdaTluLjBwqIu5NemtT1IjjgPPxCVxA6K3Ifnkh/xYTbK6ooyY7JhRt6ci1tx/MUYcVtSKYhwkqvTpfhFumMo8qAavUZrhrNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYMTVxeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYMTVxeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954C2C433F1;
	Tue, 20 Feb 2024 21:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464465;
	bh=eWhX/LHA8X834DClTzJTAI5SrlchCHwZdORprW1Y8gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYMTVxeqHxARYKyfywZV/LfPM3MiBsqd6qIpuL3V4TOCD6t4to9bWT5aSEYijQ7Fl
	 jYAdJ/FbafQTpNVXqkeedYDrafhRgp43xG/i0BciB0Z0Sh7lDA6WGOBeggiiHFGGMe
	 iFTik3Oi6vc8H3NnvQOzrYo1DA8WZB6bJOObb1u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 026/309] wifi: iwlwifi: clear link_id in time_event
Date: Tue, 20 Feb 2024 21:53:05 +0100
Message-ID: <20240220205634.002458577@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 3012477cd510044d346c5e0465ead4732aef8349 ]

Before sending a SESSION PROTECTION cmd the driver checks if
the link_id indicated in the time event (and for which the cmd will be
sent) is valid and exists.
Clear the te_data::link_id when FW notifies that a session protection
ended, so the check will actually fail when it should.

Fixes: 135065837310 ("wifi: iwlwifi: support link_id in SESSION_PROTECTION cmd")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240204235836.c64a6b3606c2.I35cdc08e8a3be282563163690f8ca3edb51a3854@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 218fdf1ed530..2e653a417d62 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2023 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2024 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
@@ -972,6 +972,7 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 	if (!le32_to_cpu(notif->status) || !le32_to_cpu(notif->start)) {
 		/* End TE, notify mac80211 */
 		mvmvif->time_event_data.id = SESSION_PROTECT_CONF_MAX_ID;
+		mvmvif->time_event_data.link_id = -1;
 		iwl_mvm_p2p_roc_finished(mvm);
 		ieee80211_remain_on_channel_expired(mvm->hw);
 	} else if (le32_to_cpu(notif->start)) {
-- 
2.43.0



