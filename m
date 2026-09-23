Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F883ADBA7;
	Wed, 23 Sep 2026 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174277; cv=none; b=ah48S+LeqeJbOxGgEj0xgyYi25Zaiope0tFX07UJjdHuAZlMPN9AHTuoi/heMT+evCUNQjVYQHLatVGG78mYrPBDVT0xgAU5U8EifNHTCUA3pSwLx66eRSjZivcz0bY5dS3EsKnBj7KxyYjIrHbo2FxHITH+MkZs9Ls57GQgl3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174277; c=relaxed/simple;
	bh=G+OvspH6zJX35dRYGEcIjj6bvIfTGCDnViRBmgSY3Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEsexbNICUh4BJUea1B1mbBgNK34qvtv29nUyAx3ylJsEZGOPT/FuMgpnlk2bZ6rFXZoWUs/HflT0xtoHYvFX94KV4PtIeuGxRlm6vEhaQRqatk3m2SN2uHO4AI25KkTynalYojYc9q6TtbOyPSZsakbDiqZpmtmO/qimOZ2KX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwP5CDh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwP5CDh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E841F0089A;
	Wed, 23 Sep 2026 14:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174276;
	bh=w+j8CHrKHq0ul8Bh9NT6PuYIkWo1Sg6429xjKgNKPsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwP5CDh+MRE2dtXYC/qolLHRf7sgiEuawWJJ1zG1bU8hJNTpYjJSYjhKndJ3ztaCw
	 fQgtbePhyxxDUNH3CSv2K5sUbJ2DyqYdnDuFv7/MVIGlK2Tff/M0JMeJK/RGUFrsIr
	 KCNZGK10ofT83aQ+uO0YACMqxDbud3Mc1kXzSDB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1634c5399e29d8b66789@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/398] wifi: mac80211: dont warn when an IBSS has no channel to scan
Date: Wed, 23 Sep 2026 16:02:17 +0200
Message-ID: <20260923140645.064909086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1e06a465b49e3..1101e98f186de 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1238,7 +1238,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 
-		if (WARN_ON_ONCE(n_ch == 0))
+		if (n_ch == 0)
 			return -EINVAL;
 
 		local->int_scan_req->n_channels = n_ch;
-- 
2.53.0



