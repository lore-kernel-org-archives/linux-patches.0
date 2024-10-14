Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03F21C7274;
	Mon, 14 Oct 2024 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917470; cv=none; b=T0dFeOmy9hWkPYTynusfLF/KwdOS92kb3sRoQ3O1Rel/sZgpP7efa7FN+sYBjvJ5pKIrYXNmdcELiamqUrD7WeHdZryePOm4U3j7mk5hTUSP8EmdDxKtBLFk3K0nue3VxKoEpgNMzj3HTWguQ3ZnAHGkHULnaTZSqvxLZ+cBMMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917470; c=relaxed/simple;
	bh=eLD0Ry9TrbJ5t0wXY63QI/dMKjNWMqtl+Xj5v6w/Cnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEM4hWqaemvqkuPcZwRmgJ1PAv8btxpLcH0dUsCkXpuMrNb/wSxmLjD8SXNJQKdHodKFfzahCgISa9RoQ4tQapm8XaD9/ewQiq2/P8xOeu6qdQfE3+AK79UnX+vAlGO8S56oxtZMcEVXBCWZAjgEmuJ1sskPn0AK2GdctIbj2jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1a1LIbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1a1LIbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3229BC4CEC3;
	Mon, 14 Oct 2024 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917470;
	bh=eLD0Ry9TrbJ5t0wXY63QI/dMKjNWMqtl+Xj5v6w/Cnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1a1LIbsqfpfKaIfhzyGLGxVkM/K+fokfNtOVc0hsMivT91p8+mfC1ZbPQLwUeh1W
	 w4WmBmFTZZF2CnxJVqbyxPEWTfX4EHBpQ4RtQ7GhtTP8zMR7Mm+d1XOw8OEdyATTh+
	 GUcslMJXD1YoWfPG9MBgYUgLMFTLhg8i6o6XnwYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/798] wifi: cfg80211: fix two more possible UBSAN-detected off-by-one errors
Date: Mon, 14 Oct 2024 16:09:58 +0200
Message-ID: <20241014141219.673789774@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index dd9695306fb85..fe14997ce2c08 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9465,7 +9465,8 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return ERR_PTR(-ENOMEM);
 
 	if (n_ssids)
-		request->ssids = (void *)&request->channels[n_channels];
+		request->ssids = (void *)request +
+			struct_size(request, channels, n_channels);
 	request->n_ssids = n_ssids;
 	if (ie_len) {
 		if (n_ssids)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b97834284baef..e35c3c29cec7d 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -115,7 +115,8 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
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



