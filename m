Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6AE27D763;
	Wed, 23 Apr 2025 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420042; cv=none; b=otVR469cUE0+tABA5aTLLEaGwhkCHeDbUKbv9znGG0Jx02sBBQ3oolQCQW34e6dAuxIgMvbgxYCAXX992Od6hb6q7u6dmCQvBDs/IgXU8a4eiuXCM8QqCD3cZoX2sCdTWNUXRqejvizpLaskVsZrIvXxAoDUctFJa8aMuPi9iTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420042; c=relaxed/simple;
	bh=dT4kHhT91ReiM6HbBSG0ZYkWRP1Jno31YY4auH4Av60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lhp05dZ/aX1zJ25xkDofV4PtiTIV7ZuURDToIrhyxZ3Sk6KjkB/OCcPmrSL6vBsWyKKpdr8uaOwAmgYYYnwroXV5jpYJaVoanaqohdhTVVe8XyMTYiqqxda+gI8C0j2TB2iJCEcjACaG4RJl8TxM4H4PIdYTCcTms2HXN967PN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJaUFsS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJaUFsS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8B1C4CEE2;
	Wed, 23 Apr 2025 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420042;
	bh=dT4kHhT91ReiM6HbBSG0ZYkWRP1Jno31YY4auH4Av60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJaUFsS+chM+5guZ66KCMh4M9p97GK1i1LEvk6rNZmTuBumG8dRWD682lR9QXfutu
	 kTZSzE4yO1Xcvnr0ZBFhu+rixEI+w15uW7JzKeHFzImLUSin8m1gQzqKAuzKEiz+Yu
	 PBqUh7/48zdcUfSl2rn8XZE9ep4CFLFSxccx0QJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/393] ipv6: Align behavior across nexthops during path selection
Date: Wed, 23 Apr 2025 16:38:49 +0200
Message-ID: <20250423142644.656407622@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 6933cd4714861eea6848f18396a119d741f25fc3 ]

A nexthop is only chosen when the calculated multipath hash falls in the
nexthop's hash region (i.e., the hash is smaller than the nexthop's hash
threshold) and when the nexthop is assigned a non-negative score by
rt6_score_route().

Commit 4d0ab3a6885e ("ipv6: Start path selection from the first
nexthop") introduced an unintentional difference between the first
nexthop and the rest when the score is negative.

When the first nexthop matches, but has a negative score, the code will
currently evaluate subsequent nexthops until one is found with a
non-negative score. On the other hand, when a different nexthop matches,
but has a negative score, the code will fallback to the nexthop with
which the selection started ('match').

Align the behavior across all nexthops and fallback to 'match' when the
first nexthop matches, but has a negative score.

Fixes: 3d709f69a3e7 ("ipv6: Use hash-threshold instead of modulo-N")
Fixes: 4d0ab3a6885e ("ipv6: Start path selection from the first nexthop")
Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Closes: https://lore.kernel.org/netdev/67efef607bc41_1ddca82948c@willemb.c.googlers.com.notmuch/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250408084316.243559-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2e98531fa51a3..53197087353a7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -472,10 +472,10 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 		goto out;
 
 	hash = fl6->mp_hash;
-	if (hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound) &&
-	    rt6_score_route(first->fib6_nh, first->fib6_flags, oif,
-			    strict) >= 0) {
-		match = first;
+	if (hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound)) {
+		if (rt6_score_route(first->fib6_nh, first->fib6_flags, oif,
+				    strict) >= 0)
+			match = first;
 		goto out;
 	}
 
-- 
2.39.5



