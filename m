Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07573BAD9B;
	Sat, 17 Oct 2026 17:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257141; cv=none; b=IQNn0c3sfI64tKRptKdmo5/M6zUCxUNA/7GwvKCcsOsoICYVQTSIyvcfxDBp/zYyOCKiPaioOdLFhYAUHyzfN7SkzZpc6bayXsFVGGl+cvDNMg6VqBj3gj+V5bUwXv4ONpQOEUO6PODA2RCRVaGVy0fI0RHF8Otlf21w566IJgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257141; c=relaxed/simple;
	bh=P+CAMD1lyRAWwuknnxo850RHpHtuMV5MudmXOJnBUfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwYglwoO8KUC4R/SE0wViVfG8NC/c61eMl0akw+iCQ/K2QSsrO9LiKJhUGeUSpCLIwSSxIuu3/PAIN9ByjjIo4IlEiGfMUDOAV54AVHQCjRt8moa6KaDvFDG0cNcm45zF8XJ3bSU9gfYtY/TsO3+u8d2+/Sq8clIuMTM9MBPukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anO3BUY+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anO3BUY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0A31F000C4;
	Sat, 17 Oct 2026 17:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257139;
	bh=h1dcs/IvSssPcxecrK2DdpOrwz/VT6WDFc5QH8lctCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anO3BUY+5g+UVFvVXKF27eVnru23ddX7mFD2+X6gwLFcOQmLf5A9FAZvG5omZnDzo
	 rwxKEdkuu594+wdjFqeHocGUKlVNCwSCya20txsEnzJmsPEY51W8Y/aE0hHTV95U3v
	 AqLzpYM0+P+9DLkP05oE2pKJkVDys7AcP9rPErMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0463/1674] ipv4: stop PMTU walk when nexthop group shrinks
Date: Sat, 17 Oct 2026 17:45:35 +0200
Message-ID: <20261017160443.003735359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1089,6 +1089,8 @@ static void __ip_rt_update_pmtu(struct r
 
 			for (nhsel = 0; nhsel < fib_info_num_path(res.fi); nhsel++) {
 				nhc = fib_info_nhc(res.fi, nhsel);
+				if (!nhc)
+					break;
 				update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 						      jiffies + net->ipv4.ip_rt_mtu_expires);
 			}


