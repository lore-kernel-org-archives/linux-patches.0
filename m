Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118E6FC19;
	Thu, 25 Jul 2024 14:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919180; cv=none; b=EXqzLmXmlcUJqlsURQ0Lu0d68cM1NyIMxPaDDDtrPErji3XzKtP+rdRAq1DKG8lTi8155DA5qFg7PcnsvUHrI294S16sQ5ohXe0xZcqPDXC/f5sntyJvcoocgNARHkKoWRJ0SW0RkyAXu3WWJ3uYUNEZPY7C+1OM0Pf3SekMzI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919180; c=relaxed/simple;
	bh=9U0L8jfJAmHW15uMlqodw+vqAdB8v+DFmv/VgJu+sNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpqJQSSmRMWtBwgC5rvvd/tI1gmJpiLVnsfDk/+jzhDhhDbi/lshf+LyDZWl+V8o/ucHwhRhXFLUlY6gyRI7CFVDXJR2lI4/TrC6TTLdMz2lvPmIdLOWn5YgxfMyhD5yun0C3etJBwlyHeGGlmmDdlxGUfFPM22VaYAU3yRApnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5U4jH1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5U4jH1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB41C116B1;
	Thu, 25 Jul 2024 14:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919179;
	bh=9U0L8jfJAmHW15uMlqodw+vqAdB8v+DFmv/VgJu+sNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5U4jH1Psl5evJNRkRr1CEkyPga0v2kDegQxhlTdVxpWeD9jfajaFKgGK6WaT2kNo
	 Si8BJ3r9IYWyEv2wpYZlSLExIOnAH/q1OuuG/5avnQigSMs0ynatqbe1N/t8KP/CRp
	 M94L4BIlaelKD50UcE9HLZS76YHVRaKzPAsTiDhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/87] wifi: cfg80211: wext: add extra SIOCSIWSCAN data check
Date: Thu, 25 Jul 2024 16:37:04 +0200
Message-ID: <20240725142739.610213487@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

[ Upstream commit 6ef09cdc5ba0f93826c09d810c141a8d103a80fc ]

In 'cfg80211_wext_siwscan()', add extra check whether number of
channels passed via 'ioctl(sock, SIOCSIWSCAN, ...)' doesn't exceed
IW_MAX_FREQUENCIES and reject invalid request with -EINVAL otherwise.

Reported-by: syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=253cd2d2491df77c93ac
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://msgid.link/20240531032010.451295-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2898df10a72ae..a444eb84d621e 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2782,10 +2782,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	wiphy = &rdev->wiphy;
 
 	/* Determine number of channels, needed to allocate creq */
-	if (wreq && wreq->num_channels)
+	if (wreq && wreq->num_channels) {
+		/* Passed from userspace so should be checked */
+		if (unlikely(wreq->num_channels > IW_MAX_FREQUENCIES))
+			return -EINVAL;
 		n_channels = wreq->num_channels;
-	else
+	} else {
 		n_channels = ieee80211_get_num_supported_channels(wiphy);
+	}
 
 	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
 		       n_channels * sizeof(void *),
-- 
2.43.0



