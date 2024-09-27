Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509FF17B515;
	Fri, 27 Sep 2024 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440142; cv=none; b=phPQEYLLY2ZQjbXvkB/JAKpIj4F3mp+QjkZiisopPNZ+Nw8KOt40nXjnBZE1bMvvejftwYSUxyVIK/YJpTZMwp3B3JL4L4uAbMBCbqHX/YZNQIJhnDB775lgVcaug5TdRpwuwKTo+mdYsQkP9D7pqUiwXzqgxywKv9qe2li9G5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440142; c=relaxed/simple;
	bh=d3+9DpdHdKrqiQ4igOtrzILCMd2VOdLbfT4Ub6/FJHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tra8yjF2zlVuKLnatqC9GnQSz93QRVrYdP6C7OhPsuvRMOUB9N8//c7zL+lBXHs+4x/eu9OXqZNY1ObzTHjxmD7MHtCeXLxzzqYSXl9yr8yYEwZAx3KYiTwRJabEAhjWFBNI3vwA8wEqHHlCgGBDzT/WP6tWApUVf+umiCnbtdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5w9de5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5w9de5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31E9C4CEC4;
	Fri, 27 Sep 2024 12:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440142;
	bh=d3+9DpdHdKrqiQ4igOtrzILCMd2VOdLbfT4Ub6/FJHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5w9de5MJtlFk4zUkLOoBpZ+HUq30nUS3AvVdtjSiNRj7c1XuoVHU0NZEmOBX9ShU
	 xnXzYWuvIeyP4Zc01HBy2dH/d3/KEL494+tzd4miC7YF/lWjOThzce4YyQCh83m7lh
	 r6TJKy/YwF7rAGcY/+12V/foMc6t/d8Sz7yQ6ySk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 21/58] wifi: mac80211: free skb on error path in ieee80211_beacon_get_ap()
Date: Fri, 27 Sep 2024 14:23:23 +0200
Message-ID: <20240927121719.663082440@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

[ Upstream commit 786c5be9ac29a39b6f37f1fdd2ea59d0fe35d525 ]

In 'ieee80211_beacon_get_ap()', free allocated skb in case of error
returned by 'ieee80211_beacon_protect()'. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20240805142035.227847-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index edba4a31844fb..bca7b341dd772 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5348,8 +5348,10 @@ ieee80211_beacon_get_ap(struct ieee80211_hw *hw,
 	if (beacon->tail)
 		skb_put_data(skb, beacon->tail, beacon->tail_len);
 
-	if (ieee80211_beacon_protect(skb, local, sdata, link) < 0)
+	if (ieee80211_beacon_protect(skb, local, sdata, link) < 0) {
+		dev_kfree_skb(skb);
 		return NULL;
+	}
 
 	ieee80211_beacon_get_finish(hw, vif, link, offs, beacon, skb,
 				    chanctx_conf, csa_off_base);
-- 
2.43.0



