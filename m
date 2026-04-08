Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F97B67E;
	Wed,  8 Apr 2026 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673629; cv=none; b=f++crXlhyqEl4INSUKrAtAbSG182Pe6bK75+PZRVjWrC5hOlBvf+xIsGCuz3K5Fn8tPzfs/lls/Qf4j2FaJXUipjA/RVqqrlLdX9Pg2QzRWGzOH59McLJn/KcnUwWBS6C+Bhkf2rONw+O06vU4qVUQTdLuZrWbXO7BqJJNGkHO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673629; c=relaxed/simple;
	bh=A/cDTU/G3ZskOnsMjBKikO3ly12YuRfYpBcaJPMMgSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWIYU5etFa2xIA+lJCGeoCbzKDMvbzcU2tFC662JBQmg71J+Kp6GUbe2vzb3XIZy1MGei+vYPKxDVfBjMg1uRjwf5WjAfiIj1J6WR3kMtnaLJkIOHgxYmjEnQ5q7gvY7aHJ5aB4IiBeYiz+X+yFn782HL7UPtUHTRrnFkVYoDAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2CCsr1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2CCsr1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2C2C19421;
	Wed,  8 Apr 2026 18:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673629;
	bh=A/cDTU/G3ZskOnsMjBKikO3ly12YuRfYpBcaJPMMgSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2CCsr1CGtf1Pvhzx9RyC8xFMteLC5Jirvz57VkNQPXRFB8wnnGW7VfGvJHr8Wj9P
	 ZGA4tkJ3tI7HVwToKFPUXVuCcC+ODjdx6vrH26OpJUVj2SktpB3p70FrC5qbs2C2p+
	 61ZIkMtDqzDL5tz1rJwX1Cik4KZ02DGyAULXlyI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/242] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Wed,  8 Apr 2026 20:01:08 +0200
Message-ID: <20260408175928.123582495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 7d73872d949c488a1d7c308031d6a9d89b5e0a8b ]

When NL80211_TDLS_ENABLE_LINK is called, the code only checks if the
station exists but not whether it is actually a TDLS station. This
allows the operation to proceed for non-TDLS stations, causing
unintended side effects like modifying channel context and HT
protection before failing.

Add a check for sta->sta.tdls early in the ENABLE_LINK case, before
any side effects occur, to ensure the operation is only allowed for
actual TDLS peers.

Reported-by: syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=56b6a844a4ea74487b7b
Tested-by: syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260313092417.520807-1-kartikey406@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 1cb42c5b9b04b..92ab7be3d4824 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1448,7 +1448,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		sta = sta_info_get(sdata, peer);
-		if (!sta)
+		if (!sta || !sta->sta.tdls)
 			return -ENOLINK;
 
 		iee80211_tdls_recalc_chanctx(sdata, sta);
-- 
2.53.0



