Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785B91DD0FE;
	Mon,  6 Jan 2025 15:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178567; cv=none; b=QfeTQHi6oPVmAZWlntfutrpBl3+y543WENybP3zxRWq89FkWybC+6x7QurV22UYSgCjK4M/Fi3SXmO7QkFZlNjcI3dn8h0qn5/hfx9VhsSk4UubQRj0FUADBcw+DP9OwrNtUfHzHaL4Ei6pdKRI4mX0ZBkqK3Wpq7mr2weddDQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178567; c=relaxed/simple;
	bh=HV/eNpsaF1I0qTr0HMMkdCP8ANPNC57OgYF7+k6v4jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKnyKAU5OZByZf6TGJrA3gDHFS0PjFxMc0OK1fNzjv9cBTVm28I+NbOh+YSfs7DW+bvDqkZ6uBxcnTD5+gmkUrOdb1wIEXnMSrnhxSSkd2/0jkwbXfTbtVQbSgsxKw3MV/t1eim/f4seps/t50eIg3XSxjFKCgkeEsBtxLKcCf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcksjHoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcksjHoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13AFC4CED2;
	Mon,  6 Jan 2025 15:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178567;
	bh=HV/eNpsaF1I0qTr0HMMkdCP8ANPNC57OgYF7+k6v4jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcksjHoRmbBPmbP0WqngTgt8QTR5CzHmmgY+AmQfavgdWUIX+VoRIseyoTUX5yVvs
	 8bBVZljScU8isqZfLfjjhExBBRC6Kz1YsTNRaS3aySutowDkAI8SKnjnqj9OK3ROWs
	 jJKPm4nveEwQDIr08QUfOLJE1LcudOjdoaO/Ga+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/168] netfilter: ipset: Fix for recursive locking warning
Date: Mon,  6 Jan 2025 16:15:30 +0100
Message-ID: <20250106151139.301506339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 70b6f46a4ed8bd56c85ffff22df91e20e8c85e33 ]

With CONFIG_PROVE_LOCKING, when creating a set of type bitmap:ip, adding
it to a set of type list:set and populating it from iptables SET target
triggers a kernel warning:

| WARNING: possible recursive locking detected
| 6.12.0-rc7-01692-g5e9a28f41134-dirty #594 Not tainted
| --------------------------------------------
| ping/4018 is trying to acquire lock:
| ffff8881094a6848 (&set->lock){+.-.}-{2:2}, at: ip_set_add+0x28c/0x360 [ip_set]
|
| but task is already holding lock:
| ffff88811034c048 (&set->lock){+.-.}-{2:2}, at: ip_set_add+0x28c/0x360 [ip_set]

This is a false alarm: ipset does not allow nested list:set type, so the
loop in list_set_kadd() can never encounter the outer set itself. No
other set type supports embedded sets, so this is the only case to
consider.

To avoid the false report, create a distinct lock class for list:set
type ipset locks.

Fixes: f830837f0eed ("netfilter: ipset: list:set set type support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 902ff2f3bc72..5cc35b553a04 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -611,6 +611,8 @@ init_list_set(struct net *net, struct ip_set *set, u32 size)
 	return true;
 }
 
+static struct lock_class_key list_set_lockdep_key;
+
 static int
 list_set_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		u32 flags)
@@ -627,6 +629,7 @@ list_set_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	if (size < IP_SET_LIST_MIN_SIZE)
 		size = IP_SET_LIST_MIN_SIZE;
 
+	lockdep_set_class(&set->lock, &list_set_lockdep_key);
 	set->variant = &set_variant;
 	set->dsize = ip_set_elem_len(set, tb, sizeof(struct set_elem),
 				     __alignof__(struct set_elem));
-- 
2.39.5



