Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865091DFE1E;
	Wed,  6 Nov 2024 12:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897859; cv=none; b=Ax6aejLkdo70Ixzz2QyzqmRrp2BsSL7W2plvZ8zM+b0pNfOboCY2EM/DwOwakKkrlkjuJxozl6LSdwISGvTmaIIlEnsOBWTRWSwTIPfOFJXobFvzp068Yl1dTNtEd/qHDmegzQRd+T/LQ0rwpe/9sXKziZJTW7dBqerx/6EHsNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897859; c=relaxed/simple;
	bh=z8zQWazyDdywnCfbD6v9TLeTZnG9mGDxG/4EbEnp65E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXpfmyL+dmh1aXpwV20Xdn3FiFPkul3eP+qBR1pdpIGS6NkUTElV+8s4XdbYGQDfkqyGjLZ2UmivjNsLRvmsjNGV31xidWEkcsARUNB8AEnBdPWCH/DdU3KAXc/PpwUzD4hJVZY7l0QK7UKyLk7mVpw03sE/M3SaNSfnQtb9Kuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7t973kL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7t973kL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F175C4CECD;
	Wed,  6 Nov 2024 12:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897859;
	bh=z8zQWazyDdywnCfbD6v9TLeTZnG9mGDxG/4EbEnp65E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7t973kLbjor9WSVqxk+4XsBs+iBpcq3ZhjnrtMRGH2zpABVthAe/fsvJZBsiswPe
	 t6Q2qlG1O2ih15htoVVohGsj8eP2mI4CLJ7JOW4s4WGpwOAdyDAL6IagYt8ofwCt6U
	 T2LHno+Lqx2+T5p5Qg36dZoQ+ggqYFXR9UKxGzE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/462] wifi: cfg80211: fix two more possible UBSAN-detected off-by-one errors
Date: Wed,  6 Nov 2024 12:58:57 +0100
Message-ID: <20241106120332.606812187@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 15ea13b1b1fbf6364d4cd568e65e4c8479632999 ]

Although not reproduced in practice, these two cases may be
considered by UBSAN as off-by-one errors. So fix them in the
same way as in commit a26a5107bc52 ("wifi: cfg80211: fix UBSAN
noise in cfg80211_wext_siwscan()").

Fixes: 807f8a8c3004 ("cfg80211/nl80211: add support for scheduled scans")
Fixes: 5ba63533bbf6 ("cfg80211: fix alignment problem in scan request")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20240909090806.1091956-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 ++-
 net/wireless/sme.c     | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e85e8f7b48f92..77edb69384637 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8018,7 +8018,8 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return ERR_PTR(-ENOMEM);
 
 	if (n_ssids)
-		request->ssids = (void *)&request->channels[n_channels];
+		request->ssids = (void *)request +
+			struct_size(request, channels, n_channels);
 	request->n_ssids = n_ssids;
 	if (ie_len) {
 		if (n_ssids)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index a260cd60a7b99..55a04b30b8778 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -116,7 +116,8 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 		n_channels = i;
 	}
 	request->n_channels = n_channels;
-	request->ssids = (void *)&request->channels[n_channels];
+	request->ssids = (void *)request +
+		struct_size(request, channels, n_channels);
 	request->n_ssids = 1;
 
 	memcpy(request->ssids[0].ssid, wdev->conn->params.ssid,
-- 
2.43.0



