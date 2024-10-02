Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2734198837;
	Wed,  2 Oct 2024 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877447; cv=none; b=HH/uUYqrhGIdF+nkuUtaBWnaGD+ckpF+XKRGfO3XtR4nAuh9aiySAlb33qxxwPIzWjeH1nJbZOOgAQN5YnCTTd+/Z/0N63RrKO5M8cAoXxQiFyo2VgNTDp0Le+PdWR6ghTspY6izRTj8I4yJ9AaLudPlTiHWp73i/O0O2DGcOvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877447; c=relaxed/simple;
	bh=RRH5zolsG2/AJC6HOJwq+zoRtUcnj564GLsOlBtNur8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb/NT30aI3ktp9vv3hALmwdsNrset0myy1VuRtlmGAy5oJgEE9gv1N7zEOtdJ7GTI5wu0NwEbwc/g7TbAHFQ/HaK61K4zTrBDU/8hrSMZELH0/Kg298o16KRJma/+fJBkEL5bmP8oWnHEAiOA+YQukrFZTFw/kSdm2Ow5Dsk9Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjrMjDQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjrMjDQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBE3C4AF0B;
	Wed,  2 Oct 2024 13:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877447;
	bh=RRH5zolsG2/AJC6HOJwq+zoRtUcnj564GLsOlBtNur8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjrMjDQyyecwB7+lN3Ncu0t3IVEtwpaMh8HiJYq46Xnjd9Gjix/Hh273bM42xHm1d
	 T2A9ickMX6jHdYXWEUTyYvwS2vB28dkuhEA/wmKH2ggZNAS+PPEFfljNq/HMuSH8aw
	 bAzLX6BGsgV+nJwXbhQyf/Hni5GM3ESIo4aFO2kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 082/634] wifi: cfg80211: fix two more possible UBSAN-detected off-by-one errors
Date: Wed,  2 Oct 2024 14:53:02 +0200
Message-ID: <20241002125814.348924505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
index 967bc4935b4ed..e3bf14e489c5d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9658,7 +9658,8 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return ERR_PTR(-ENOMEM);
 
 	if (n_ssids)
-		request->ssids = (void *)&request->channels[n_channels];
+		request->ssids = (void *)request +
+			struct_size(request, channels, n_channels);
 	request->n_ssids = n_ssids;
 	if (ie_len) {
 		if (n_ssids)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 1cfe673bc52f3..4b80af0edbe97 100644
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



