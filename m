Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43CC8827;
	Mon, 23 Dec 2024 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970793; cv=none; b=i6qAQ8z/7KaiDAdp88Ce7w8ToFV+7f3897ttgK2XM+p70qiRVqHVsc0DYts6lTNfgZKtOfPKBofrQPvaIZaOmKg4gTUswjIgndgRlaE752aGahCLwAvCbxSs21IIq8TbNUwRKsQvuVlbBAMWf/2UsrUQO7VhfI2gcWtKr4hAwyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970793; c=relaxed/simple;
	bh=8szpj+rodcWfb/HJOKgSnfTuBuBOSbQYDbzT/ouRPsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXTRYI45+aJu6iFgNcyhPfCafUajOasw/UmvD/+4dmiLvtgeH7PMEVegG+1wavDdWdpmy+vGvwrq070z4yVln4Ic8UUa/k6OaHM5QoOrN1h7AA0nzBPvmgagt7m2oIQkOTXu6XsCOcfJjynwz7vNmLscemLGdhLsQte54KGBvqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHCoOudg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHCoOudg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C6C4CED3;
	Mon, 23 Dec 2024 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970792;
	bh=8szpj+rodcWfb/HJOKgSnfTuBuBOSbQYDbzT/ouRPsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHCoOudg5btFH/mSfxqFZdpIfg1xUQnTwudT1S7HGYAcctkL8SRkVhltODE+0RwDn
	 CyW2DyGWGeTRji4QNan+dPjwD4KjZ5MYFp1oWyLfFNf+rL65ZptYF4qww7bsvUGGLB
	 VfLWrllw9M38WheSlXRYpwhOALvM13/17WzCIwIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/83] netfilter: ipset: Fix for recursive locking warning
Date: Mon, 23 Dec 2024 16:59:09 +0100
Message-ID: <20241223155354.818610026@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



