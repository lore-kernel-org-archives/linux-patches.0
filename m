Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF6A13D600;
	Tue, 23 Jul 2024 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760116; cv=none; b=hZ5aGyqTCukKtL7hlOwz1Cxvy8E0QbXP3bLWm4VaDZptjuaKN0iXbmZFgXAK8/jfJ8mdV4lyZGu14Y4KvjbtpG0gI6u1pvf2fOytTVEuOKlBnlAK8l5l48VxGZJg3UnyW1asdoABcwvHSVMX9FTR1C6TImEjpZ9ThMltVnoWzYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760116; c=relaxed/simple;
	bh=RnHHvpQA8gL+09qcVi3pbCObbnQEBh3nPwr8oAqNEqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MP7/WC9hLIVmauxeYElIhkCG+G/Lejl9x+UDC0wd9nrdBf+Tx3Brt+nKefxGqvc1cg2CIhXzt/gaWb9x31WaSlBaEywZvduN6rPPdqr8LpRqSmFTw6BieF74krLNfT8e7iGbyYpKN4ol5pq8hx5B3SRLlcywv/F9VEJ7yWOEciY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INd1Zvyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INd1Zvyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FBCC4AF09;
	Tue, 23 Jul 2024 18:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760116;
	bh=RnHHvpQA8gL+09qcVi3pbCObbnQEBh3nPwr8oAqNEqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INd1Zvyc/l0OADuP0bFdBiLhuPsx8LfgGFkfe7F1B9IKqX+UXwfjno4ci5DW/MBj5
	 A3Qw4JbFInUf7hXZ4DRYCFlTCJSkDHJ8nBkVmKnSt/KXB8b4hJc4Cui9Owa9uvRQSy
	 pozWRVFmfmNjaPWW3fjIDa020n1XsuZ5F8K7baNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 067/163] wifi: cfg80211: wext: add extra SIOCSIWSCAN data check
Date: Tue, 23 Jul 2024 20:23:16 +0200
Message-ID: <20240723180146.059454109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 0c0d54e40131d..a811ad02e6d1f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3411,10 +3411,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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



