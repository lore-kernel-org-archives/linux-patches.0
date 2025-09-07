Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB781B424F;
	Sun,  7 Sep 2025 20:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276006; cv=none; b=DydG/cbgnjKIUzNruAdnkE9X4ppoXSF/UWdLJ29xuBF7o3/k8VGvz5LjKgrbx4CTQV03Ah2Sr0kV1D5LskhGUeFsQm0qAqYYNFxRdVrDmuknI7tAzHCoZufVxp/4ODuY6KomlxIve7oFwWz47Em3+s+Ijupl9ESPaIn0Ktnd5Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276006; c=relaxed/simple;
	bh=aGaADDwWa/0I1A5ZpdXVUgoQqcK8zuiFJCuPcLYybcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SveNVl174SpEms9iFfFe4a6Hq6NErgmx//fG2jABdRc5RlS9GGX+du0xQEt/mknjlW+117i7C3lVqaHV5eo5YmSexgdX9Oebhq0OzcVsyguhd11yAHVQEGK378Zq9BjyXMQhAca/tcyDVHC/eyfLSHw/d19YjHuhMoNeJmRy9Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPl1bWjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPl1bWjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C53C4CEFA;
	Sun,  7 Sep 2025 20:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276006;
	bh=aGaADDwWa/0I1A5ZpdXVUgoQqcK8zuiFJCuPcLYybcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPl1bWjnbxm4t+HvJPtGOfh6JtDxR6bTyNCfV075RVZpg/SLmXfKpFsX2j9I0VlTV
	 uhzUbJqE1E2MLMJTRsgR0tbCFSMNcAlF45jMi2fhl0p0F77aeVvmOwO0lg/MJLGDU0
	 KYJ2XL8AnDckfAuaWZ9AF1YxmFXJ3HHb0HT9+fSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+30754ca335e6fb7e3092@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/64] wifi: cfg80211: fix use-after-free in cmp_bss()
Date: Sun,  7 Sep 2025 21:57:51 +0200
Message-ID: <20250907195603.661140385@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d977d7a7675e1..e2b4149e5ff43 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1768,7 +1768,8 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			 */
 
 			f = rcu_access_pointer(new->pub.beacon_ies);
-			kfree_rcu((struct cfg80211_bss_ies *)f, rcu_head);
+			if (!new->pub.hidden_beacon_bss)
+				kfree_rcu((struct cfg80211_bss_ies *)f, rcu_head);
 			return false;
 		}
 
-- 
2.50.1



