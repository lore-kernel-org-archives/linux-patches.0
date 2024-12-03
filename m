Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746421DAC9F;
	Tue,  3 Dec 2024 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241037; cv=none; b=WhKxKJy6X2pF4eHk7WLNn8PTv0btpl+GJ0B82+nZJYH/pBw5l1kcBqbS/YPrlg3BKQgPmQSFBHoJpa5M09cuaIdQqbKAPzd5JKSajis2ENV8NpTON5RMYqfE1uaZihlVVUzMdWxqVAXlts35s3kBsWhy4w6utEwDqjeUVDgnKHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241037; c=relaxed/simple;
	bh=AmH34KtlRr1Vl1U/0HABAyCpbv1RyDdXkMRezcOe6hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBNJiPMBZgUYMI/coa2Foe6nd/WspghAakNtpPCo4y9ssAwl1hRpvwacN108pQVZ3E1oFtnUiW1eOE0+uEA0iF4x/1wzIHNHgoO1xf0Hh8WCQboGkfqOVZqVfSeEKzyP1WNFX1XzC9LhM+GbR/MKQei5q3UxXAdZmSLGfEZGu6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFbTgKiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFbTgKiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D494CC4CED6;
	Tue,  3 Dec 2024 15:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241037;
	bh=AmH34KtlRr1Vl1U/0HABAyCpbv1RyDdXkMRezcOe6hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFbTgKiDcWR2wrlEiSr4x44RN0vq7OEjkNgwzI89/X72cir1xL71aZEKHHh+NUpdp
	 2ozqx8TuxU4M8VMyAyHNJeWhtT5cbl7tGWDCA+3bFof9vZgvi++RevvxSW1UxkJw+l
	 VmLb2fb/gBqQo/ZFOGHjNHuFw093ZnFVjQGrJD90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/826] wifi: rtw89: unlock on error path in rtw89_ops_unassign_vif_chanctx()
Date: Tue,  3 Dec 2024 15:40:02 +0100
Message-ID: <20241203144754.504066407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit ac4f4e5a203927e555107db6e781e85f241720e1 ]

We need to call mutex_unlock() on this error path.

Fixes: aad0394e7a02 ("wifi: rtw89: tweak driver architecture for impending MLO support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/8683a712-ffc2-466b-8382-0b264719f8ef@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 44ba4dc181b5b..13fb3cac27016 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -1373,6 +1373,7 @@ static void rtw89_ops_unassign_vif_chanctx(struct ieee80211_hw *hw,
 
 	rtwvif_link = rtwvif->links[link_conf->link_id];
 	if (unlikely(!rtwvif_link)) {
+		mutex_unlock(&rtwdev->mutex);
 		rtw89_err(rtwdev,
 			  "%s: rtwvif link (link_id %u) is not active\n",
 			  __func__, link_conf->link_id);
-- 
2.43.0



