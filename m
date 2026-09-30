Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3143BBFAF;
	Wed, 30 Sep 2026 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785803; cv=none; b=PKsu7VoGiL1Wh7qnlY3bgu2/0qR+EO0ULqLi8cTj6tzUW3GVtTxZysTivN0d8kkGaP1lmyD1ZpMvVqxEfCOQE6e8On55e03Pequ85JU+H9H9B32SNSd1bm5TeYpeYEWTKvePRx3wq3UkPc5/pZ3agaf3nKjNDaB/R9PHdY/B4tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785803; c=relaxed/simple;
	bh=CC3EP0WcDSt7IZMdS47d0Yz4zA3r0FzwWaWRzAMMT/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0MGhoi6PsJrJfg/Ei5u7WW3uRdgMiY2lQ4WUL040pv06LZZamquSGAvo8j+x2HwSvKOJabYyowuvGBJykey4SUriu7IPmdE9lkgk3EOLITH69ZguJrGLy0nPGcvTLpiWSMul047caeQ99FhFzaGkiXI+5IcyKW3r8Szmcsa3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOOvtTUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOOvtTUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D061F000FF;
	Wed, 30 Sep 2026 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785801;
	bh=hH/6p74Ss//df1BuspYPHCKzCzWYHDvAGRHfte3M8Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOOvtTUJg8vWLsaee7IuW5pwRZPeyyR5xnxqh8+7CGM7QJiCmWDomT7agOEJajSl2
	 k9y+uvr76IpMejWzjsKeNhTGhPS97n5+2MNc0c59C7/4+JqnqYCy4YHgAmn1uv5LMg
	 aJUxn4w/DAmvpJaJ/W0nq1ynqiPC7HS4URtFK/OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 635/982] wifi: mac80211: dont allow link changes when iface is down
Date: Wed, 30 Sep 2026 17:22:51 +0200
Message-ID: <20260930152430.409428615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f8416965c2198..6b4b5e0a19570 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -591,6 +591,9 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
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



