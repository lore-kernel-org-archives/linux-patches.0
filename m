Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347B54EFFCD;
	Tue, 13 Oct 2026 12:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895677; cv=none; b=JW/1iP9QJFMo98MQsUegZD2ybUUfcb4BsXUOkMCR3Hf8G/S2znbps0LM6td8G+MbdeaL5k16+NEp1SdisiHQ0J8ofdQetjOdb+JDiCmkwn7JODVn0wIal/ZiAFjhZjweUfjBX/JP6dnTcjbliDRY/P4Y9k983sXJEuLE7+l6W68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895677; c=relaxed/simple;
	bh=t2yCFbNgLiApoWCUOZb4yIZ+KgBmWxNmBmOh8XGH3Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvQ7FGRWB/qVRb8hhOuczSlpOSkjMhbxkQKTrROc9uCdZdo3+N/zf3SAMGlMLShik41ZX3sDyMWq1Fr/00LWOPCsOI0FQFV6eS6KaFR8YzituusLqPR0LXm9cQKulBp/OLJOx5JDd4Bf1/2iuxHmbQTIxznz9LlyrKYw+noiCro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nc/QiDR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nc/QiDR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806931F000FF;
	Tue, 13 Oct 2026 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895676;
	bh=pTN+tYxu8CjfSOROWUHlfMFZKrKb7PMrDTR3UCdsn+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nc/QiDR5/w5lgT4pyrhtX4jnN9mpgox63RS2Fhy7A7n7VdnxgjgB1DB3dikkj2jPY
	 3BtCtW75DzLXh1KsGtapqCIWKpjUKtKJtVwEm5dMoj4ogOneggychcfX84aP1SL6ik
	 LRSUNokAx3H6AyZ+usg/mr+Ax0lngbCAh5dkrOmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 354/497] ipv4: stop PMTU walk when nexthop group shrinks
Date: Tue, 13 Oct 2026 13:38:41 +0200
Message-ID: <20261013112916.309340070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1077,6 +1077,8 @@ static void __ip_rt_update_pmtu(struct r
 
 			for (nhsel = 0; nhsel < fib_info_num_path(res.fi); nhsel++) {
 				nhc = fib_info_nhc(res.fi, nhsel);
+				if (!nhc)
+					break;
 				update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 						      jiffies + net->ipv4.ip_rt_mtu_expires);
 			}


