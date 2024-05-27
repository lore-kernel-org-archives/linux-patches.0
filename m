Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5CC168C4;
	Mon, 27 May 2024 19:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837901; cv=none; b=fQGKw1sexacIre2J5HSa7HRZa4LkMoC0cUr7sW6mxfbPYm3HWuzG5wBNSgNcTy4tDXHB1Jz4OyBnJzdlVvBBHAD84kihOkWwjLz8lSilsSj9Z28PMxAckjWWTf/gqxSi0PlIvwGGZYXPs8PPX2N9GZQta3OPs5UAoZxApVnL9h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837901; c=relaxed/simple;
	bh=2HIyxVxQOUE/j3851qO3Y+6nOK4IkVHlIvm+ehFpVuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxdjOLrFW9I8nutpTE5rQaEoZh/YBYPCV2RVKExHQgavwrp+6RQQARRD2y/HofLPsxajE6qQDRxIFd8mlR1LNmf3Uwt/2y3/wKrQE+rNx+OtlhpS0YzpQGMYIFjzyflodaWIcD8QQCz5+2DQv2ApDMffDdtzW55HbIOKCJ3Aijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0wl292N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0wl292N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F315C2BBFC;
	Mon, 27 May 2024 19:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837901;
	bh=2HIyxVxQOUE/j3851qO3Y+6nOK4IkVHlIvm+ehFpVuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0wl292N5d1m5X/0VoVcWLqOJ/uGt5phm2OuDKjIN+0T2il3bylj/8c/D5fOvdW0g
	 VCDohchpwclS/W6QdEx0h7phXm1KVVEcKdG9htpm0is9u3zbRvvIzkCLJV90gJDaRe
	 yrJgNdpUFq41Ny6wiyNlZkI19zeNI2bxDs9XxKek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayala Beker <ayala.beker@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 172/493] wifi: mac80211: dont select link ID if not provided in scan request
Date: Mon, 27 May 2024 20:52:54 +0200
Message-ID: <20240527185635.978965712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayala Beker <ayala.beker@intel.com>

[ Upstream commit 80b0aacd1ad046b46d471cf8ed6203bbd777f988 ]

If scan request doesn't include a link ID to be used for TSF
reporting, don't select it as it might become inactive before
scan is actually started by the driver.
Instead, let the driver select one of the active links.

Fixes: cbde0b49f276 ("wifi: mac80211: Extend support for scanning while MLO connected")
Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320091155.a6b643a15755.Ic28ed9a611432387b7f85e9ca9a97a4ce34a6e0f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index dd0ec34a3f8a8..d613a9e3ae1fd 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -695,19 +695,11 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		return -EBUSY;
 
 	/* For an MLO connection, if a link ID was specified, validate that it
-	 * is indeed active. If no link ID was specified, select one of the
-	 * active links.
+	 * is indeed active.
 	 */
-	if (ieee80211_vif_is_mld(&sdata->vif)) {
-		if (req->tsf_report_link_id >= 0) {
-			if (!(sdata->vif.active_links &
-			      BIT(req->tsf_report_link_id)))
-				return -EINVAL;
-		} else {
-			req->tsf_report_link_id =
-				__ffs(sdata->vif.active_links);
-		}
-	}
+	if (ieee80211_vif_is_mld(&sdata->vif) && req->tsf_report_link_id >= 0 &&
+	    !(sdata->vif.active_links & BIT(req->tsf_report_link_id)))
+		return -EINVAL;
 
 	if (!__ieee80211_can_leave_ch(sdata))
 		return -EBUSY;
-- 
2.43.0



