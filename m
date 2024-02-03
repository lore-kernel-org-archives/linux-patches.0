Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04332125B6;
	Sat,  3 Feb 2024 04:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933671; cv=none; b=CoOgfd2sXPxnYIKMaaBA9av/keNtmr6b0Omnu577QMPxwPIdlF2WE6gXGoorD/k6SI2RXOZ6Atb9/7rvA/Z99zl5FHMWk5Z28xdvGWsvupZr4QTjE2f03WK4ki8Q/EZ3TFUDWKmNyzQC1EYbRs6VrYvU1nhjqdxEkWPTgrmxRCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933671; c=relaxed/simple;
	bh=/LJ23ci9y+xlIpR7Y8YoIalR+5UkfMCWslPVtBCHO6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5EIn9s23CR1TAWC0iLE3yGWq26KqOPBa7EH6GZBUVVqjR40KZ/PHR1VDdW37EXZMq081jZ0cnatlWNtocoDgjoMOeG3pqQ5o7Ys3Vy5MIG7nqkoScEksyRz/vaKvToqvD2dR9GktR8zrceUK7VbA20w0i6rkqaONdYmIJ9XlLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r10PX2rG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r10PX2rG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1385C433C7;
	Sat,  3 Feb 2024 04:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933670;
	bh=/LJ23ci9y+xlIpR7Y8YoIalR+5UkfMCWslPVtBCHO6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r10PX2rGCrwSmml03qF+jPrYpfnPsw76TRdpTdJwq/rkd8xlCrQuAaHLPNNmXaBbB
	 DY47/FiQiFkha2XohtTDtz1jX4Nc3OZbBJ7ebb9zwqcCuTEB0dUh3/JotB37s7e07G
	 m5jLRfXvQwxO7JMnC/PizCFW1JzUTAdCmwhwIcrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Subject: [PATCH 6.6 260/322] wifi: cfg80211: fix RCU dereference in __cfg80211_bss_update
Date: Fri,  2 Feb 2024 20:05:57 -0800
Message-ID: <20240203035407.544573440@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 04ef7cdd39b5..c646094a5fc4 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1830,7 +1830,7 @@ __cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					 &hidden->hidden_list);
 				hidden->refcount++;
 
-				ies = (void *)rcu_dereference(new->pub.beacon_ies);
+				ies = (void *)rcu_access_pointer(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
 				if (ies)
-- 
2.43.0



