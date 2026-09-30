Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227133BA244;
	Wed, 30 Sep 2026 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796138; cv=none; b=tUKg/xo3EURDJGAdIq6Ib4K1LIxYjv4OCJxzDh9biAWqt7dL5l/8zdb4P5UCE9pNjdTcfwhd9e7OE9NkQagvhNvaRI45+IidSMeWkaGF8rVbY6IfFV5ejA1mALQG8YlEmnz578HBmdxps9TJe03v390ku/Sn79RZguKLHfdUd10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796138; c=relaxed/simple;
	bh=W0h22brT5QHGmeL7O5ctVg52RgZMMX2njpwaSwICo6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIYNHlne35Oi5u/QUrn6GWjW1NbiHkyn9JcPcY6QCPHeSWuQa9AeSIdB6BlvgM+nSYRbWCA+locLhS6AMTXwWjnsduK+FxcLD9jiljJPbNdaltyxQu2R3K7b40uyyPQGnSoxWMsfIJhOdt/p6S9lK9HlQZ5XrB+06wrCjaQDMYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wd3OpJey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wd3OpJey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C77E1F000FF;
	Wed, 30 Sep 2026 19:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796137;
	bh=mjchMJF3FLYeRXat8+7ReHtRSnzLSqIIksHQDmTuYcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wd3OpJeyHVZL7GG1m+pzbcoUWQ+ba8UmIPSylNaNTwesPxYQjh8Aod2xkholaxkSp
	 uWOj1PhI7qBETt3qwsRIOKufDoN8rl4d9SVxTybiF8MubmbPgGxH0imxW2A5CA2tgl
	 UvowOBLDWpYi2dkJ0/NtnhvPSz4eRFAQSkivNrMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0762/1193] wifi: mac80211: dont allow link changes when iface is down
Date: Wed, 30 Sep 2026 17:24:06 +0200
Message-ID: <20260930152451.186320405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d6938ffd764ca..b77003d2cc2cc 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -619,6 +619,9 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
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



