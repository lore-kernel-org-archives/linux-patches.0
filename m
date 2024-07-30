Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694251A6161;
	Tue, 30 Jul 2024 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356573; cv=none; b=RLxf+EBkVpHzBaxwW6UooXotc5iYLA81xIcNidsGziNpgHjHS6TyeOmxwRNwU3G5elMh+Xkangf3C1ogTrQUKl77jPzJeKHD3vuVY7vpy+ofipoWcQokvO4lSksQaETjf9fPIrY74CZpN5pXzliKl6Ve/NdrWDYNOZlC9tM88KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356573; c=relaxed/simple;
	bh=ov3JxoQLSNB8nUXcuAuo3aEaLZ9t4PQ1pCqqmJ6vPzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONxcOmTvc8F01G56A9OPV+ehfNlPerewvnaWqqwhd1J21lA25rQtZOD3MAvM3oGOZdZCK4GjXdyRoAc5pWb8vQ5nx/S8LT83n1fVEcgxxK03Oz5YYL4ORWWaNalDLIZXn3zi8iEWi6IbtSAaQrnfrsjZxhWPJkJguVMM/UaEtxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8kS5MJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8kS5MJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48D9C32782;
	Tue, 30 Jul 2024 16:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356573;
	bh=ov3JxoQLSNB8nUXcuAuo3aEaLZ9t4PQ1pCqqmJ6vPzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8kS5MJ5424xNYyS9TSVljggUJa1VDD+kMHeby7q+OLkohZI4pvsEOljbeos/GA/j
	 oLO3lg1HWLXhydd/68zanUwJuNH6MRovSt5I8sq6fsh+MVxscmpIpfbvw7ogTK+nDG
	 IhdcpCCleMSOWZ+3MvxRgkYJVuhYs9HdQYbuzEmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 163/809] wifi: mac80211: reset negotiated TTLM on disconnect
Date: Tue, 30 Jul 2024 17:40:39 +0200
Message-ID: <20240730151731.039605586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 609c12a2af046c3674af2d5c7978b025718de5e8 ]

The negotiated TTLM data must be reset on disconnect, otherwise
it may end up getting reused on another connection. Fix that.

Fixes: 8f500fbc6c65 ("wifi: mac80211: process and save negotiated TID to Link mapping request")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240506211858.04142e8fe01c.Ia144457e086ebd8ddcfa31bdf5ff210b4b351c22@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0a9949bbd7576..ad2ce9c92ba8a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3287,6 +3287,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	       sizeof(sdata->u.mgd.ttlm_info));
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy, &ifmgd->ttlm_work);
 
+	memset(&sdata->vif.neg_ttlm, 0, sizeof(sdata->vif.neg_ttlm));
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &ifmgd->neg_ttlm_timeout_work);
 
-- 
2.43.0



