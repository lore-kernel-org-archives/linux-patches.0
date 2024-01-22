Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604FA1487D2;
	Tue, 23 Jan 2024 01:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972081; cv=none; b=ZOaUxqdbQ57a/LF4y0FEB2DSiWyjxZQvWwfOA9+JRX76Oy45ml9uywP/ULX6TzXbrl9quEgWFY7EedNdjLEycHdeU19D0N+bYJNalkJNCYaWB4pDLd+j6R3OOjke/aAM98PoR129EcVc70R7cQ0CuFm15e63yNjRbPZXe7unbh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972081; c=relaxed/simple;
	bh=Xf0ade+jHGDpG+8q9yyGPiYEn1vKFXhpfl2YqTvh23s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBIf8UKkWVAlX6ofCV27KeuT/4A3VtALAsfxk7fclkR6n5MbXHDjxLDHaROcngkrXMYi7ULUWx1kso4gW4u2v1sBdVIvZH4VCyYgX68DT1bH+2BRK5CHIKDFgW5yT42yGXTjs91HgF6gl8kmBt++j7DC5rfSykYvnRtyEvS87YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H444ofp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H444ofp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1452C433B2;
	Tue, 23 Jan 2024 01:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972080;
	bh=Xf0ade+jHGDpG+8q9yyGPiYEn1vKFXhpfl2YqTvh23s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H444ofp9ZG+/XOdhBX5Bek4gsZUVUT7c7wmZmRvJoWLFxyPf78IxP8YSwLyajS0X7
	 mQjQYEoJntVqoDWMvMZ5jnnwGlM1l2YF8IUoBJhMyc/zEH6vegSCUDJlvXzjnuMmsq
	 4724ys1Xh5Mg6UwND72Sq4y7vH3KRXmuMkcdWse0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7e59a5bfc7a897247e18@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/374] wifi: cfg80211: lock wiphy mutex for rfkill poll
Date: Mon, 22 Jan 2024 15:54:21 -0800
Message-ID: <20240122235744.810639319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8e2f6f2366219b3304b227bdd2f04b64c92e3e12 ]

We want to guarantee the mutex is held for pretty much
all operations, so ensure that here as well.

Reported-by: syzbot+7e59a5bfc7a897247e18@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d10686f4bf15..d51d27ff3729 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -216,7 +216,9 @@ static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 {
 	struct cfg80211_registered_device *rdev = data;
 
+	wiphy_lock(&rdev->wiphy);
 	rdev_rfkill_poll(rdev);
+	wiphy_unlock(&rdev->wiphy);
 }
 
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
-- 
2.43.0



