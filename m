Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AC21A2389;
	Sun,  7 Sep 2025 20:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276307; cv=none; b=GNnuLbBlX/qQE3zA9YTcbo+zqK2QDvtxw/2Tb2Pe6mArWFDbwQXMwAO0nd3OFrORP9urSUnKyZGgIN6m9p63HcKFkIHK7QZUtn3oDKckpcRCo+OGhOHDtF+/X+8q/e1Wl92l136S8GcSZmyRf+W+QkM4h3HDNSjD/DhPBtzMAjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276307; c=relaxed/simple;
	bh=PFZr9Eu0YYoxK8BlTkNRkYoaisn8WWb/5HEXFeqlnt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ui23IdsTBG8ajCtBL+ycJL1JlEKXAKttqy2PyCoVo+e4ZhfsBg3l6z+nXVIPC/fkTALUEEiMs6R6u6TcN6g+ZCITDx/RWqfOhDa4Bd8d2qEvCF7ln7ZcnsFbBiW9+4ZAp/svaeTytstHWX8b3d3TwajXhrkL91izL/8zTLnSWpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4BOnmNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4BOnmNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACF3C4CEF0;
	Sun,  7 Sep 2025 20:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276306;
	bh=PFZr9Eu0YYoxK8BlTkNRkYoaisn8WWb/5HEXFeqlnt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4BOnmNxtPy/MtUmo29rdFanI9pQdjK77M6rFsfkToWC4PHHH6ukn+Mia6l9bwdes
	 GW9I1+c4P7NukyZck/ubsW7pzZwy1Rt36j+GXp8RIEluLfL3hFiScwMCX8+T5qk3Zy
	 AN6EutfpQjkwWplLIW2xkd4ojMg8Wx24QYYjzvYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+30754ca335e6fb7e3092@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/104] wifi: cfg80211: fix use-after-free in cmp_bss()
Date: Sun,  7 Sep 2025 21:57:33 +0200
Message-ID: <20250907195608.102747476@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 26e84445f02ce6b2fe5f3e0e28ff7add77f35e08 ]

Following bss_free() quirk introduced in commit 776b3580178f
("cfg80211: track hidden SSID networks properly"), adjust
cfg80211_update_known_bss() to free the last beacon frame
elements only if they're not shared via the corresponding
'hidden_beacon_bss' pointer.

Reported-by: syzbot+30754ca335e6fb7e3092@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=30754ca335e6fb7e3092
Fixes: 3ab8227d3e7d ("cfg80211: refactor cfg80211_bss_update")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20250813135236.799384-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 810293f160a8c..7369172819fdf 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1785,7 +1785,8 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			 */
 
 			f = rcu_access_pointer(new->pub.beacon_ies);
-			kfree_rcu((struct cfg80211_bss_ies *)f, rcu_head);
+			if (!new->pub.hidden_beacon_bss)
+				kfree_rcu((struct cfg80211_bss_ies *)f, rcu_head);
 			return false;
 		}
 
-- 
2.50.1



