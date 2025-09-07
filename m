Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04026FA77;
	Sun,  7 Sep 2025 20:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277484; cv=none; b=iR8jYhbb7h8TcQhOdHdE3iMC9Yp6sks1sfWHIR9S61IlIlh7JP6phyxvY7dEkk6HMyE/s+5UDmtLb8R0p062XNL6ALuoasRY2fq2T7qZ1YaxJi8hFM7UBFhecMA1JQGOiZYANyg3UHY/I+vVO7HxDI7Zcx8em4P5EaoZmR6gtDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277484; c=relaxed/simple;
	bh=BSmjbbNmwCcN+iSNrjchxQ6SpgqBszMhOh3THAWlcME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Efp0B0muvpwvgjgJ9VMN8imE6e8LCmGQqg+3qiM2/WTj3J/jilTtp48YqyYN6s5S7KELWOiDFn/pdBg68FTy7vALDdCgNO5GPA1S3DuKeZLTzYBDN66cw1HKbGc6fu+tQwAS309M97xiMqium0F95aq2ou8dsK7lY4RST95ACQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pidboR9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pidboR9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B23C4CEF0;
	Sun,  7 Sep 2025 20:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277484;
	bh=BSmjbbNmwCcN+iSNrjchxQ6SpgqBszMhOh3THAWlcME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pidboR9HcwBz5RROaHeN592fnCD246RGY+/I3ogMzHE52TKbomKOhcex/mr3OA3dC
	 CiCCWdf6u8jhc83sfjod/s9ZyknEBmFUMjYwGkj8ZJljVpjvlRRFseqQawvejmhYcx
	 PSRi/kxPOen1+Hnq0qmYNHASyTV+BwX39KPuxX5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+30754ca335e6fb7e3092@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 030/183] wifi: cfg80211: fix use-after-free in cmp_bss()
Date: Sun,  7 Sep 2025 21:57:37 +0200
Message-ID: <20250907195616.492407971@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e8a4fe44ec2d8..f2a66af385dcb 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1905,7 +1905,8 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			 */
 
 			f = rcu_access_pointer(new->pub.beacon_ies);
-			kfree_rcu((struct cfg80211_bss_ies *)f, rcu_head);
+			if (!new->pub.hidden_beacon_bss)
+				kfree_rcu((struct cfg80211_bss_ies *)f, rcu_head);
 			return false;
 		}
 
-- 
2.50.1



