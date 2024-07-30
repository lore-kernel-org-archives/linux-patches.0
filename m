Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A75C1A76A4;
	Tue, 30 Jul 2024 17:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359958; cv=none; b=bCe+spp6AALMBunFzefzKLh3B+CNPcy1ecdLgrqqWDsN6K33lYw7QOSvmbwMmf3x3v9i/KCpb5dc4XVOoTrNrpzVfc8F+m8gamG8iZE5+114UZbgKoEdw0yi3IIG7Ar5hnyrOQG7oT6gqPUUGXgwzjXkBhoih4BsVh8TWpThwR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359958; c=relaxed/simple;
	bh=zMootvfocrLkJX9f+iCKCi+pW2gtCJg7WVHIQkHb2UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlCUUbjkwCqZ1euME6OkbXHvcr0f2JGxK13s9OqZ+5b8jJG4r41UyO3fx1albs5VG9vguV0criac1J6qtCFL750aKpk7ob2cHMOyjKPf37Ds5QZzVZVf4CToqS1LGpzOI7PYEBNaBd7aBmf7MBsjdlLGFE1OWZSjxFdxCb6aHdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2IX8sAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2IX8sAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C90EC32782;
	Tue, 30 Jul 2024 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359957;
	bh=zMootvfocrLkJX9f+iCKCi+pW2gtCJg7WVHIQkHb2UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2IX8sAF5W1TAdITrZiK2/XBUD7TZJqQ2j2dOd9QzCRF8xsQLMicT4HZsMMP+WKL2
	 38D20nfiwJOze/crIwW9F2SVPYWaiJbdeTSX3Ozw3n6N6qJwvs9Kae7T1IqDCUP+ud
	 h6XeH5880YvQ0rflVP0w/GJEhbivQZmKlFjbaBt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.10 559/809] wifi: mac80211: chanctx emulation set CHANGE_CHANNEL when in_reconfig
Date: Tue, 30 Jul 2024 17:47:15 +0200
Message-ID: <20240730151746.840170937@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

commit 19b815ed71aadee9a2d31b7a700ef61ae8048010 upstream.

Chanctx emulation didn't info IEEE80211_CONF_CHANGE_CHANNEL to drivers
during ieee80211_restart_hw (ieee80211_emulate_add_chanctx). It caused
non-chanctx drivers to not stand on the correct channel after recovery.
RX then behaved abnormally. Finally, disconnection/reconnection occurred.

So, set IEEE80211_CONF_CHANGE_CHANNEL when in_reconfig.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Link: https://patch.msgid.link/20240709073531.30565-1-kevin_yang@realtek.com
Cc: stable@vger.kernel.org
Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7578ea56c12f..85a267bdb3e3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -148,7 +148,7 @@ static u32 ieee80211_calc_hw_conf_chan(struct ieee80211_local *local,
 	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
 	/* force it also for scanning, since drivers might config differently */
-	if (offchannel_flag || local->scanning ||
+	if (offchannel_flag || local->scanning || local->in_reconfig ||
 	    !cfg80211_chandef_identical(&local->hw.conf.chandef, &chandef)) {
 		local->hw.conf.chandef = chandef;
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
-- 
2.45.2



