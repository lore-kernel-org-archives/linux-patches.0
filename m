Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2FA3ACA7C;
	Sat, 17 Oct 2026 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256266; cv=none; b=RU4KIwtP+vzUuUJOoY7ym1W5ckaZGy1vCLucopZS3FwY0H7+Ub/Vyj9AQoUxX2upU1F15BFeJHl8tjAmVSbwUAo1lcO51SgTT02uDo7mDO+abZKcb7zuirZ55DTMUpf8vjxNoM77nJ68G3eO0yCctkV5XDHpG7pPQLv/xRcGoRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256266; c=relaxed/simple;
	bh=/XD0GSMyUa1Ov5oOa7PY2vKOe2Mud4rARRff63u4f9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBofzCGkTJKP+bWKNVAfuF2mvM7cJvaUHSH2LbPQD0n2AnJ0zNeJC5kaZyVJNs+TzwRdm3wt7KwihfSBAMHkl5qi9xdJvdNepaYcpTRM+GncSP2C0qJKZtPzJ11M5NWUnU+DJdTFEHwUEYGO/pongGijp+qr24vLXsUuLhgIXVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svQzXnd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svQzXnd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3231F000C4;
	Sat, 17 Oct 2026 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256265;
	bh=2MYnCoyyAfQWUnkR88IrFPCT795ZW0Pix0yTC1e1WkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svQzXnd+RBZjl2VWfj/aY195xpBqdXFtH5ZBgCO0t4ziIpOBCFiWohLsaIwH5mvGE
	 6vwGaXyX88anE7Xgttj0EkPUTbCUwK2cHyP/pBOCQLj9ZculCHG6sRg5r6VRqBLn4P
	 ldXw+C6W2WVsJfn4dROGYhLDu5KG7XDLKCpYtzQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0179/1674] wifi: cfg80211: avoid double free if updating BSS fails
Date: Sat, 17 Oct 2026 17:40:51 +0200
Message-ID: <20261017160435.748227403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit acc44cbd7727115f9381c35c2898b1b5af665ec8 ]

cfg80211_update_known_bss will always consume the passed IEs. As such,
cfg80211_update_assoc_bss_entry also needs to always set the pointers to
NULL so that no double free can occur.

Note that hitting this would probably require being connected to a
hidden BSS which is then doing a channel switch while also switching to
be not hidden anymore at the same time.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231220133549.8891edb28d51.Id09c5145363e990ff5237decd58296302e2d53c8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0766367bda6cf..4f4a77b1e7ac7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3162,10 +3162,9 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 
 	if (new) {
 		/* to save time, update IEs for transmitting bss only */
-		if (cfg80211_update_known_bss(rdev, cbss, new, false)) {
-			new->pub.proberesp_ies = NULL;
-			new->pub.beacon_ies = NULL;
-		}
+		cfg80211_update_known_bss(rdev, cbss, new, false);
+		new->pub.proberesp_ies = NULL;
+		new->pub.beacon_ies = NULL;
 
 		list_for_each_entry_safe(nontrans_bss, tmp,
 					 &new->pub.nontrans_list,
-- 
2.53.0



