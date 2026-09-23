Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0B03A9DBE;
	Wed, 23 Sep 2026 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172818; cv=none; b=t3ZkfKyOPQgfIQxqPOAXdlmnKhVrn3XHArniaWoRiPnlq0/ftQepn7EeifnaziT/nFJZzJYTFFFoSO/Ww/kToqpR+WgdxI8pUXGKus+ogEK6t/LiN7Giv2BM+8z/ZEc/1+9+JT0U7GsGhKreVOxlH7v9Xm1VT9XZi3tEsYo9cXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172818; c=relaxed/simple;
	bh=q8D3IPj9T8+OTdeEfkS079SDY4o8i6hf95wX9zknw6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyL6z1Ii9uNQJCx1HQ4WygoXZJuBEs/fHLDEirbvwkaQKm2wrM618wy7X27qHpbAxil/5mUtVIp+Hg5VymmqStY0jGSjt45PJo6hXfNN2kkMeBi4zB6NJrB1XOs/0lzBSGxSd1nQuoyAWluoLC1alP5WiMWSouMjrFEYGJ2pnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zt2bftqV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zt2bftqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9151F000FF;
	Wed, 23 Sep 2026 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172817;
	bh=PUQZBDe25SQxHLlpvm+JOrTvc+J9YzPfReXUd895dn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zt2bftqVvozLQhOieJDRhCgM+bC5ARMS0gBAGzgMvFCoV/6sq9MXim++uKK/eh4d0
	 0Ypz0bpJ7FoaR/kSjxN1ZoiK91AA2Ixk5aF26bfH8d2xTkOkgukvWJ/bRiNeB7RQFL
	 xX3QLW6fvVdl4J4OgDfTO35xlnKvvW46ln4O1ByE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1634c5399e29d8b66789@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 070/438] wifi: mac80211: dont warn when an IBSS has no channel to scan
Date: Wed, 23 Sep 2026 16:01:31 +0200
Message-ID: <20260923140646.601353030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a7491b7efbd9136b120a12ed72af9c12121dd134 ]

ieee80211_request_ibss_scan() warns when regulatory leaves no
allowed channel, but that can happen as the regdomain can change
while IBSS is operating, and it can continue to operate briefly
during the 60s grace period until it's shut down.

Just remove the warning in this case.

Assisted-by: LLM
Fixes: 34bcf7150241 ("mac80211: fix ibss scanning")
Reported-by: syzbot+1634c5399e29d8b66789@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1634c5399e29d8b66789
Link: https://patch.msgid.link/20260904165722.fe380c27fef4.I0e8bee2e12a40d240851a4bc724d47753af46159@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index eeff230bd909f..8e950ef6d1ead 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1242,7 +1242,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 
-		if (WARN_ON_ONCE(n_ch == 0))
+		if (n_ch == 0)
 			return -EINVAL;
 
 		local->int_scan_req->n_channels = n_ch;
-- 
2.53.0



