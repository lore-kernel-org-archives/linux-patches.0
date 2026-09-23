Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D165372E9;
	Wed, 23 Sep 2026 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174316; cv=none; b=TCuvJMDaF/w1qyR8pmy/cfH1kwwlFLkTMSmZI7pHscdzAkNbLnkR8zq05IUr6rPTjIUHHaebCFBbTAiI19t3avo8WFQwPI6zhAh0EcESIahWZ14rG6IhIuijivyCU/yrld98/WJOVGV+ODkk01TwXyFR4ROY4jJWk3iiSwQAZuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174316; c=relaxed/simple;
	bh=bGYCUwoyS/lXwlasH9piYFyXQ7k5HguhuJlppBbgF/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9N41yCroxKpj7qGq4qBb/Vlq6FwnQf1UxuiOTi2lNq/aV2GTeI7uarsgXcyB3fu/LHuDU8Y69jfCHVpFo5K0d0Xdh1N2/b8E1kjUCv6HBkdlNaIcp01T5Ac2ID+dy6p2yE2oWMPltpwANvl70s3bYSManq8y2TkfilMtMeJwWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iT+EKqie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iT+EKqie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128E71F000FF;
	Wed, 23 Sep 2026 14:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174314;
	bh=tXkeD/nIvaYlPo8yBFJHqyPkJU81RRcR9Teh7qr4nyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iT+EKqie0rVk/lgGiyrZqag0++JYqSwxemP3T3zIQ2LTQDsD1QASfdaco7+ud+LHl
	 sTnEKugtNk2ZXweDfXAhBLtqRyJ+IpDPuAQ1/IaXTTwo1XnZ+QX/f5n918NwsZOqqo
	 d1J5FehPT7y3ndqj3TrUu7EnIIAqVwOVsLoY/p8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/398] wifi: mac80211: dont allow link changes when iface is down
Date: Wed, 23 Sep 2026 16:02:30 +0200
Message-ID: <20260923140645.402413735@linuxfoundation.org>
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

[ Upstream commit 370872d30349d81dec519e15ea2949fd63511cf7 ]

ieee80211_set_active_links() only checks that the interface is running in
the inner __ieee80211_set_active_links(), after drv_can_activate_links()
was already called, so using active_links on an interface that's down
triggers the check-sdata-in-driver warning.

Add the missing check in the debugfs file.

Assisted-by: LLM
Fixes: 3d9011029227 ("wifi: mac80211: implement link switching")
Reported-by: syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=582469b3a9ef5f13606b
Link: https://patch.msgid.link/20260908122838.201719-16-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 30a5a978a678c..ba241567ac7e0 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -728,6 +728,9 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
 	if (kstrtou16(buf, 0, &active_links) || !active_links)
 		return -EINVAL;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	return ieee80211_set_active_links(&sdata->vif, active_links) ?: buflen;
 }
 IEEE80211_IF_FILE_RW(active_links);
-- 
2.53.0



