Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D869322323;
	Thu, 18 Jan 2024 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575159; cv=none; b=CfKZvTQpDKABoy1ZfVPoiy1X3qCkkkpACPYWwlk3ZIu6Sd9ZqT+trwD1dikoy0Uapd4PTQ91rKbw0R8qbFSztSxnmmbXeZfUobTE7twC3XhxMj0pXkzuuAdJJ4RLiJq1jU2u+99825uvCnIcNTThqpPEhJwwvqdqysW48bJqQrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575159; c=relaxed/simple;
	bh=n3adBkM4XSjvC0VZvgMazTj6a0HVZsF7v2CDCukzWgY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=NOdvXefzhsS/vu5pzANJoFNYKtBC1tcc/sLgRq4E7UMK4p4Z2NVJATG9I8vkcvAh+FOssYBqzFpCiOBXBCd1Yse+REFwnrrA+gtQh8Shqtdkp1ZGtqV4XfE7NazmsveToziSKfbJDBjRdRgGimkM7dDO1HaBSZl7eKq0teNURUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGf1aBx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGf1aBx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6B0C43390;
	Thu, 18 Jan 2024 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575159;
	bh=n3adBkM4XSjvC0VZvgMazTj6a0HVZsF7v2CDCukzWgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGf1aBx0np2lN90SmWZ+UtntsvF88Ii2/Twa/59SRqdzeiEOFFJTfKUn9gwT6WTuR
	 vXgdNAvdBAqEFAqoL6ayW5PHo9TFc/zueudfukzIjy4dmhj+NUnPstoBrhlUm9UmEK
	 GKVAM/wkXvW1G9zHBUeSGHZU3BwGyCxLeo3kB2qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7e59a5bfc7a897247e18@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/150] wifi: cfg80211: lock wiphy mutex for rfkill poll
Date: Thu, 18 Jan 2024 11:47:10 +0100
Message-ID: <20240118104320.427850882@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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
index 563cfbe3237c..f6ada0a72977 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -221,7 +221,9 @@ static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 {
 	struct cfg80211_registered_device *rdev = data;
 
+	wiphy_lock(&rdev->wiphy);
 	rdev_rfkill_poll(rdev);
+	wiphy_unlock(&rdev->wiphy);
 }
 
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
-- 
2.43.0



