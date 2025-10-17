Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F11330B1C;
	Fri, 17 Oct 2025 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716063; cv=none; b=K19rpjnbSaFrUPdcEpeeeBpS6ZVSYvST8Y8Cfc2lFb5TBvF4IvYuNIQxwQQ0j4cQewAbfDmxpd+VqkjLNDrj1I08HYIm74wcc4CH1veNLb3xOHT3kGVuXaMjLtkBb4fvknFDV4m3pUoodA0KWwaKwpjTq5wqW3T7sS4gNOe3f8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716063; c=relaxed/simple;
	bh=91vXonBSQQyLT2dbHxndQMIrzqldcs/cNACB2HUnTOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQCh5uo7GJHtseIbXi9NJ1qDyODiLKZ/nDORJqsU/FNLYB09yem4ut4CffZo2yAdU16ExXlScormsfadCPmwylk2KMgKbSaAfxW53oUTWQ29oeudUDzHlUsjIOwlioFVdycL2D/n5Zz07R8jXKFRSJoCSOtWRx0ry6l41ebBk7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBqcgy5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBqcgy5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36065C4CEE7;
	Fri, 17 Oct 2025 15:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716063;
	bh=91vXonBSQQyLT2dbHxndQMIrzqldcs/cNACB2HUnTOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBqcgy5xiTKRm/lppd3XW+nq4R4eKqCBcb96VGzubp4BVmqmBgy1CLeRQS+3COMvL
	 XjFV8sewJ/rU8uw3dgBewPARQD1tX5JLXpdJiZfj0E36gQD7R0Rve/MyB4i6fyH5PF
	 BGCkI5DmuzrrrXIkKWTAdvZRw3ZvbFOS5Q8JJkF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Jeff Chen <jeff.chen_1@nxp.con>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/276] wifi: mwifiex: send world regulatory domain to driver
Date: Fri, 17 Oct 2025 16:52:33 +0200
Message-ID: <20251017145144.679342889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Kerkmann <s.kerkmann@pengutronix.de>

[ Upstream commit 56819d00bc2ebaa6308913c28680da5d896852b8 ]

The world regulatory domain is a restrictive subset of channel
configurations which allows legal operation of the adapter all over the
world. Changing to this domain should not be prevented.

Fixes: dd4a9ac05c8e1 ("mwifiex: send regulatory domain info to firmware only if alpha2 changed") changed
Signed-off-by: Stefan Kerkmann <s.kerkmann@pengutronix.de>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.con>
Link: https://patch.msgid.link/20250804-fix-mwifiex-regulatory-domain-v1-1-e4715c770c4d@pengutronix.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index d76a8523ef1d3..8978f18d98de4 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -663,10 +663,9 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 		return;
 	}
 
-	/* Don't send world or same regdom info to firmware */
-	if (strncmp(request->alpha2, "00", 2) &&
-	    strncmp(request->alpha2, adapter->country_code,
-		    sizeof(request->alpha2))) {
+	/* Don't send same regdom info to firmware */
+	if (strncmp(request->alpha2, adapter->country_code,
+		    sizeof(request->alpha2)) != 0) {
 		memcpy(adapter->country_code, request->alpha2,
 		       sizeof(request->alpha2));
 		mwifiex_send_domain_info_cmd_fw(wiphy);
-- 
2.51.0



