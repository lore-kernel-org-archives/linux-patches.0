Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD852D8DB9;
	Mon, 27 Oct 2025 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590493; cv=none; b=GzgBp5bwe84K23OtQ7padeOZI9X4/vTpktEWj/tWrGiLcsul5/VHRD2w/BJCW+UMSXzgy1wi9m68h0sncctp4WkaDtP7HAeRA2PuLOrwk9eMLYZpnDZml+CCp5OB3i+5rqHUjXKGG/egkD50A1bpt3ILlTP/ZfF1b1/yT4J0c8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590493; c=relaxed/simple;
	bh=seFFerxcoom0Y6KfdtmHPoQI5GPMEyMOtgOc94sGdhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDfvNZJKuc9LRoh38TPzzlaQ/Jrc09YWLbUMkAPQivArIByb4ehjYWIvWeQpdefB/oqhEst0AY6ftqhxakagfEFNVoDNDENfA3FEu0wdezbUef56GYMzFwYk2DlmEaXSwAKPgSgFAAF8RCwv8k+cspFktVYGIErcnAg5xyus+OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei9ukHuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei9ukHuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BF8C4CEF1;
	Mon, 27 Oct 2025 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590493;
	bh=seFFerxcoom0Y6KfdtmHPoQI5GPMEyMOtgOc94sGdhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ei9ukHuUY29LZKnT3r/Si4XBh5Jvynqke/qpzngYjePpF66qq0zN9RtCSNWfzWFfR
	 tRtod3C+Rtn/g3tRAj5BLP33xs4EECbMlxrd+P+NtaU8HZdf7mgsFchEOzDfIzIAoj
	 CIpF4abHS3yxG7MslkT7Nph2iZmAAKGH27ELt4+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Jeff Chen <jeff.chen_1@nxp.con>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/224] wifi: mwifiex: send world regulatory domain to driver
Date: Mon, 27 Oct 2025 19:33:04 +0100
Message-ID: <20251027183510.024601470@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 40e10f6e3dbf8..9f9826b94ad40 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -667,10 +667,9 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
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



