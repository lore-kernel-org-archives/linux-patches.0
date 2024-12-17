Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDB31F429B;
	Tue, 17 Dec 2024 17:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455776; cv=none; b=gR46bihx6HpYngXL8oMHlMbRMGLzgki/GAAVCDkEEh5Sye1pF0QFcLcW9yNgmDkNB6k3aAxcIT1cITHNaC8oDdfbir3axJGmU3kahfg7dk7FoOxlpnIifIy7NC0kA9ZkwHwtTgst9m21J9Ut17xn1XW3fCEwENOSrnBr+h7Fenc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455776; c=relaxed/simple;
	bh=Dv12o+yiKsMP9mzAWsx2ORSRX0UXz1r3anjPpjM5vXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiVqqAlmmZlwjYIdolZiBBQUpVB/RiiMwEmLMaiTr5eskmSCm5oUgLAFdjFl8v09Oud60h2VlS7ouQXEir8fGEyRP/1NH4GT8bNlAkx1TjxCeQsFhq5/HdOfigBTSOiTE6VJfw3O0oz3lHT5rjKymJydJpFYUiqY7yRUqUOJS1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2E7CoHe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2E7CoHe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F22C4CED3;
	Tue, 17 Dec 2024 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455775;
	bh=Dv12o+yiKsMP9mzAWsx2ORSRX0UXz1r3anjPpjM5vXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2E7CoHe+l3LAtF8YPN7GlWHkwp5qFZkHZk3eFCh8qYARdVrq7MlTDw7dssMdf/LhT
	 fh00RSkBNt2RZeo799xEhFCZ97zWh6EheXPFO4lBhmDETt0BMzN/GtJm6GNhJ7qw71
	 KrOy71wkBI8DC5Nec5s5+EaFLfb/moEkO5tttvak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/76] wifi: mac80211: fix station NSS capability initialization order
Date: Tue, 17 Dec 2024 18:07:09 +0100
Message-ID: <20241217170527.476925601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 819e0f1e58e0ba3800cd9eb96b2a39e44e49df97 ]

Station's spatial streaming capability should be initialized before
handling VHT OMN, because the handling requires the capability information.

Fixes: a8bca3e9371d ("wifi: mac80211: track capability/opmode NSS separately")
Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Link: https://patch.msgid.link/20241118080722.9603-1-benjamin-jw.lin@mediatek.com
[rewrite subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aa5daa2fad11..be48d3f7ffcd 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1767,6 +1767,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 						    params->eht_capa_len,
 						    link_sta);
 
+	ieee80211_sta_init_nss(link_sta);
+
 	if (params->opmode_notif_used) {
 		/* returned value is only needed for rc update, but the
 		 * rc isn't initialized here yet, so ignore it
@@ -1776,8 +1778,6 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 					      sband->band);
 	}
 
-	ieee80211_sta_init_nss(link_sta);
-
 	return 0;
 }
 
-- 
2.39.5



