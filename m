Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB11EF954;
	Tue, 15 Oct 2024 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992444; cv=none; b=KqKfv8+2ZMezgps2TOuxy1QXXShMtaorfufQM5NaQXAhzVVf1JSD50YfScy/Pj/JSoeq4C7vp/hrxsQNjMvlOyMSEFPgOMjBgl/qIJ5OZA8dXY7Oou3W04ZZiCueJ3md8W55fu1skYqZEMfUauQrbJmJtXcyzbKB44O8DGvd8ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992444; c=relaxed/simple;
	bh=t5jq+Zzaor2gdQxybD3kbh0rviraDIYj3TtZMvPmC+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bitss1miVhdE95Ey8fp1yYChXlnGn4IWRRIX2CqC0NPWNBZ0FiXUkg8M5yQ1jK/NtxVjYUl/x/v6FBpcPaIbM4Ae8kRVo0xtMY2vHrWW+ZpBbp5zR5lgVBFaT8iJS2LIye/gTrOuEqO16qpFFbR9Yyd26Dt5AkRLhVrr4BaOJi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD1ZeskN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD1ZeskN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88F9C4CEC6;
	Tue, 15 Oct 2024 11:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992444;
	bh=t5jq+Zzaor2gdQxybD3kbh0rviraDIYj3TtZMvPmC+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QD1ZeskNb8ydxoUqwD06GLgd1NExloR1mbRnfDWfalBnOV42BTAkfeKQtdYmt37iu
	 0EieFXPTbL/soJLLM981h3CeMX5wJwyWDORfpFoyLiROJsmKfPc3JvCzwJoI7EuJZi
	 GTJSLr3ERIx7X7BXCdqmJMm9V3JGzxmIA1VB3B5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/691] wifi: cfg80211: fix two more possible UBSAN-detected off-by-one errors
Date: Tue, 15 Oct 2024 13:21:07 +0200
Message-ID: <20241015112445.081346861@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a46278cf67da9..d286a10f35522 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8784,7 +8784,8 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return ERR_PTR(-ENOMEM);
 
 	if (n_ssids)
-		request->ssids = (void *)&request->channels[n_channels];
+		request->ssids = (void *)request +
+			struct_size(request, channels, n_channels);
 	request->n_ssids = n_ssids;
 	if (ie_len) {
 		if (n_ssids)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 1591cd68fc583..3c29e9bf66b4e 100644
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



