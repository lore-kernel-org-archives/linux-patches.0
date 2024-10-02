Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E9D1D078B;
	Wed,  2 Oct 2024 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879285; cv=none; b=DT9WxnVY1wZ+sYuTnheciEaPuyBmHtvrQp8JlQrzj4pl/1hQmuO8ZDnP+VKo4c88tRCU0ozfwHoi0mgPldaObZ2ubSZ7v9/0AUp1Qh9FFKjtIje3t3LoTUHu8ThHc5xTHCAftzQn+fcHBTxmR1aQ7iDT2AaIQFoCiM3Tcd4R++E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879285; c=relaxed/simple;
	bh=8TeRz29FW1G/DM4VqXYh3xjnLZnrQz2M3Xv7iLxTSxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5LA2gTrtT6+9rakEGqzO8FARYK2zuFj6q9RhfN8LU+eHm/dDtkOF8hZi44+C7sPZocIxilVQ4WvJbEpTHuAluJJlJExau4GCu+NtUAZ1W7wsl7w8Vj5YW56GGlsmkHBv0DNleLsFDcswkgc2JcQi2H0HUs+ERBXC3BTQUxz5a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0gPzUcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0gPzUcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2088EC4CEC2;
	Wed,  2 Oct 2024 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879285;
	bh=8TeRz29FW1G/DM4VqXYh3xjnLZnrQz2M3Xv7iLxTSxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0gPzUcuruWmZ6qU6V64Son2jMLfEpKdLZ4aBXtdz9CLrx0LzIvlcENMwkO9vIqt8
	 usY2iP9DVRR5I0BV/inL4hwoSQFMckN9s4lxM5hSxT3F0bjZLl4yvMV40N5ihq0uOu
	 v/alTmbdPpbKrWk0zcYH8FyqdxBbtudG1if73hD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/538] wifi: cfg80211: fix two more possible UBSAN-detected off-by-one errors
Date: Wed,  2 Oct 2024 14:54:58 +0200
Message-ID: <20241002125754.535536465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2b2dc46dc701f..4ce23762b1c95 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9679,7 +9679,8 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return ERR_PTR(-ENOMEM);
 
 	if (n_ssids)
-		request->ssids = (void *)&request->channels[n_channels];
+		request->ssids = (void *)request +
+			struct_size(request, channels, n_channels);
 	request->n_ssids = n_ssids;
 	if (ie_len) {
 		if (n_ssids)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 72d78dbc55ffd..591cda99d72f5 100644
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



