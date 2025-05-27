Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4CA1CEAC2;
	Tue, 27 May 2025 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366935; cv=none; b=MHG7zQ0+SsVZMrnAl9UwakiKcCA3IB3LcBhQV61vIfbunGwapZIcZInMLDG11VKJ4u9qEoq0VU3hCo+CukMdDT/FZJZxO3UpMEjBKqrOww1WyagrAuGIE5CENU26bdbBpu1keoZtVPd229Ehr4/MNrxQebeX2Hoc/SNUIqMj3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366935; c=relaxed/simple;
	bh=TC5liaJyfv3Dz4dV9VwjBAyP6aa55jc0xIWaWSjZeFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPh53UQkb8UyEuGS/SFoYcfJx9PMqDTAcVd1Jn+J1m6P2LM0uBtjN/A9gaccWu81JOMCdgsnx1V9pNzR/cLnBD3stc/6wTpLii8n37iQs/vw9XCH9GVZK2D1TxurJo1yS/Rmbhb2Trdh1nBKszebDKpvE5QR+3VRJkkqzsXUM2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEYyoJAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEYyoJAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9ADC4CEE9;
	Tue, 27 May 2025 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366935;
	bh=TC5liaJyfv3Dz4dV9VwjBAyP6aa55jc0xIWaWSjZeFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEYyoJAzEupKV14tvg/Z1E5CTcHhWSjjFMPSqPdph/xmnOM8NFCoNxq2aejdNLeJ2
	 o8pdK3wwXqCvpRYt83S2MxRDnQ2jBm9YtYgEAj4IFqHLNXfkacBNqFEL8Q+wDxb/hw
	 +RN6lO+wtPCnRDcfjxmuHk/iRvaT0biMPMkZDOY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 225/783] wifi: mac80211: fix U-APSD check in ML reconfiguration
Date: Tue, 27 May 2025 18:20:22 +0200
Message-ID: <20250527162522.282842304@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7a6a740be17e049a2742c76bb1dadb3d78c930d9 ]

If U-APSD isn't enabled by us, then IEEE80211_STA_UAPSD_ENABLED
won't be set, but the AP can still support it in that case. Only
require U-APSD from the AP if we enabled it, don't require it to
be disabled on the AP if we didn't.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308225541.b4674be12a38.I01959e448c6a2a3e8bc5d561bbae9e8d2cca616a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3f30c4c1f78bb..f92cbbc32a9e5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -10216,12 +10216,11 @@ int ieee80211_mgd_assoc_ml_reconf(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 
-		/* Require U-APSD support to be similar to the current valid
-		 * links
-		 */
-		if (uapsd_supported !=
-		    !!(sdata->u.mgd.flags & IEEE80211_STA_UAPSD_ENABLED)) {
+		/* Require U-APSD support if we enabled it */
+		if (sdata->u.mgd.flags & IEEE80211_STA_UAPSD_ENABLED &&
+		    !uapsd_supported) {
 			err = -EINVAL;
+			sdata_info(sdata, "U-APSD on but not available on (all) new links\n");
 			goto err_free;
 		}
 
-- 
2.39.5



