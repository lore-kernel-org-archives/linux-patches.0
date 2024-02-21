Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FC83CF42;
	Wed, 21 Feb 2024 14:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525452; cv=none; b=AM6aYawcM8zawpW643oEUvy4oGX7JdguDJNJeHj7qToKZQPVx0rMC1451ul6Tfi/CN28MivfPr7VqDs8UQ3bMSzTHhzFk7SHnJdUbXPkUNVGsAMgTuVioBT9OXtKnSYlOhOd8tqHE52AJaXuP4FiRi4oz9rDft/Uoa8Vm/9C2fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525452; c=relaxed/simple;
	bh=Sz/4IfPxtp2vLU3mg/zQJ2VMfolQYnbL/+5NFDkl34Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uv7WVLrxDJHLuO5vFep2PNSBzkOLIxBRa2Ap4PCzVUjhZKJ8Z6MmwI/LrwZA0lK8Pq4Gz93GFA1CE6XV39B+ohei3F3MBGmCbNHzpAkpPPG8NgvGNaDiVeTK0yE1TBnD+0sUcc7UOxGXQogE+QkEhGSv9mJKYwRrUVQGX/01xeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GP1ujzOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GP1ujzOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C0DC433F1;
	Wed, 21 Feb 2024 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525451;
	bh=Sz/4IfPxtp2vLU3mg/zQJ2VMfolQYnbL/+5NFDkl34Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GP1ujzOMhEWJYJqtW9Qyqm3AC8IJizdbmSDZe/7pYDJdqn9qPFSP/ZcmpnX9RyB5W
	 w21wplLC6WUw7/V1YBhtQnj3oy2YFjzs/0xNK5NMZEuJZZmzlCaVjJPzsybeR4lFRi
	 e72WIiE+UtkwDrqd9eNzwzd0wO+uwe5dwcq/BDFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Subject: [PATCH 5.4 158/267] wifi: cfg80211: fix RCU dereference in __cfg80211_bss_update
Date: Wed, 21 Feb 2024 14:08:19 +0100
Message-ID: <20240221125945.042426142@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 1184950e341c11b6f82bc5b59564411d9537ab27 ]

Replace rcu_dereference() with rcu_access_pointer() since we hold
the lock here (and aren't in an RCU critical section).

Fixes: 32af9a9e1069 ("wifi: cfg80211: free beacon_ies when overridden from hidden BSS")
Reported-and-tested-by: syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://msgid.link/tencent_BF8F0DF0258C8DBF124CDDE4DD8D992DCF07@qq.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f3a957f2bc49..a1c53d4b6711 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1295,7 +1295,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					 &hidden->hidden_list);
 				hidden->refcount++;
 
-				ies = (void *)rcu_dereference(new->pub.beacon_ies);
+				ies = (void *)rcu_access_pointer(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
 				if (ies)
-- 
2.43.0



