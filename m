Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461053AE18C;
	Tue, 13 Oct 2026 11:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891948; cv=none; b=h97glrjmgYEg90pSZhQmP6QOXYL7zY4go93cYst/XRDYdc22hu55UPF/bRRAFQRX3lZZX97hCRLokAhsbkIb4EQ7nHz3kD+LNXPBw+IkQktKyRCrxgWPWZObi86GBC87S1VDk6N5hFsuvvVX4MGoyhr/aIaxEGL3Oy0dNZwhJ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891948; c=relaxed/simple;
	bh=4W5zyI7XrEjt5qBhLF0N5HO8pr27iFaiC+5jE1XqCqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qE4NYWLWHuzkfUqMQQPF4LNG73Pf/YLM2kVQwIyOdD2gkhB63biYqxz/PyZ0n5zjnBeeIc/UkrmWI49ocbNdsJznOA4Et413ABQ2cXXLqnjKW6EINnG7vjICy2p4Dmn7e5CN49nST/ktaipmkQz2ZT1mhyCa7dGoOdvCPHM4VEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdNC6krc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdNC6krc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EE71F000FF;
	Tue, 13 Oct 2026 11:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891946;
	bh=xXlyceBtJiTUoDpD2r3FfPNa1VAijypan0ed5CLhzQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdNC6krcvmQCSQERR19tijlJ2zNTACNZ+35SVZejC9wCqijMe9K74pv2i2h7Ik2X2
	 78H1CAyOQ0xUeZNtzYhmeTlTlEXrJy9yHc+xAuDdhHsGG2meSF3acBuhG5XfpZ51yh
	 RRvO2JLL6ImyOvPpMhvIzjklr8niiZp+l4PLVxL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 010/281] ipv4: stop PMTU walk when nexthop group shrinks
Date: Tue, 13 Oct 2026 13:35:26 +0200
Message-ID: <20261013112855.300524413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1080,6 +1080,8 @@ static void __ip_rt_update_pmtu(struct r
 
 			for (nhsel = 0; nhsel < fib_info_num_path(res.fi); nhsel++) {
 				nhc = fib_info_nhc(res.fi, nhsel);
+				if (!nhc)
+					break;
 				update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 						      jiffies + net->ipv4.ip_rt_mtu_expires);
 			}


