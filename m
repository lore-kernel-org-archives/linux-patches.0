Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211340;
	b=Kus6eoNY3d+NiyVOMP0TkOGSMPX0Joac4IWTc00zRu14KUh0fKUgprsBMK5sTVPiIuw0
	 mlBPfIDXOSlzRp7zg9+DEZpz6KYeaoUCwQfiBjJfyLuzBupg752RqiD4F6mvSJjAF0LSO
	 7A//J8Q8JOzkx/ju+hfzWUI1DX/7efMh34nf0IXvWOXMjnTZDGXiXERM9GlxLoaHpoext
	 Lo1JxpV8wSiBbvnkA4cwATzfQczs7UwtaJoWHgMX6WN1OA26xL+2ofuGx0Kmmiyw7Eert
	 2DaobuA/HYXUy11ij+piGd+U5ZzEbdFOUbLdbUW7x9UJVWq1M00hSdZyl0BwoA+kSFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TSB1blw32ANp0fNa3PL7ynRNWuSbIkx2vM2vlk/UStw=;
	b=nrLcvuiERsWFYyT37o7nrehz0f5WF6BpaxNjCxRfZi53jf6eIIAf5eFmGAECISyL2zmB
	 1r8R+NY1MqB707nnr0WYBHTxel7G5Vdy0C3nQNHaT8GZlF71sirdwmKvVt34g/NWSCM80
	 90+fPpKZQ+wM4zgPyihSFw/xFhUy1K4nz8WFyCioRATHxiA2uvkpIb3D72egm4RZK4Wt/
	 W4vnEDIloVNq5SE6CzAjjBks0X1XzDhwfe+mPCwwKxgsz0it/SPv2jNHZ9h6ILl2F02iA
	 1yRiLViGrfARthG+OOp6OxYs813uOjtBDdTv3cb5JrU30dGHKDlL6vJVkg5t+FWO9gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i41y6Dt/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D455606A32E;
	Wed, 28 Oct 2026 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i41y6Dt/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD441F01825;
	Wed, 28 Oct 2026 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211339;
	bh=TSB1blw32ANp0fNa3PL7ynRNWuSbIkx2vM2vlk/UStw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i41y6Dt/Mm62frfuVK2CGfITIu2Uxd9hcaSWe5EyGg2CaAUI6HPP28fsKi0wyks6D
	 /aVJT5SWmHxeEfEmvuwispMHZxbo/rt2pUQKwsTFTvBbQgdGVrTgk5F1vIzc/6BU5X
	 Z1Lyen/rELS4PcHDAIXS7sp72movQdoRUv7cZaFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 343/571] ipv4: stop PMTU walk when nexthop group shrinks
Date: Wed, 28 Oct 2026 17:58:10 +0100
Message-ID: <20261028170016.157139249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 6619e01855e65ef35723685a557e3eb106f4ecf5 upstream.

Commit 7d3f3b4367f3 ("net: ipv4: Cache pmtu for all packet paths if
multipath enabled") made __ip_rt_update_pmtu() update every path.

For nexthop objects, fib_info_num_path() and fib_info_nhc()
independently load nh->nh_grp.  RCU protects each group's lifetime but
does not make the loads observe the same group.  If replacement shrinks
the group after the loop accepts an index, fib_info_nhc() returns NULL
and update_or_create_fnhe() dereferences it.

A deterministic probe only widened the existing window between the real
operations.  On v7.2, an RTM_NEWNEXTHOP replacement published a
one-member group after the PMTU reader accepted index 1 from a two-member
group, producing:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: update_or_create_fnhe+0x45/0x15b0

Stop when the indexed path is absent.  Groups are dense, so no later
index exists in that snapshot.  The same real-writer window completed
114,423 PMTU iterations without an oops with this check.  A reproducer
is available on request.

Replacement requires CAP_NET_ADMIN in the network namespace.  Where
unprivileged user namespaces are permitted, a local user can obtain it
in a new user and network namespace.

Fixes: 7d3f3b4367f3 ("net: ipv4: Cache pmtu for all packet paths if multipath enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/4fb87ed994dfc067178fc845cdd8bc9b5446b039.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1094,6 +1094,8 @@ static void __ip_rt_update_pmtu(struct r
 
 			for (nhsel = 0; nhsel < fib_info_num_path(res.fi); nhsel++) {
 				nhc = fib_info_nhc(res.fi, nhsel);
+				if (!nhc)
+					break;
 				update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 						      jiffies + net->ipv4.ip_rt_mtu_expires);
 			}


