Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFD412FB31;
	Wed, 19 Jun 2024 13:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802352; cv=none; b=hAA5GjFaBG8FJav75cCy0efetL0XgiRy0KU8nv7x2I6p6rN7sJIdvTFy6C+v9mmoNCvBamnh9YKX133cQ88lTOWtKVQIDJKoFLrKynN558v2cXNl0+SOyC4V2ssCQhvXo/NiBEu5IdvxI7IuucZBpx9tPFKtLoPGmRvz0aqXd08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802352; c=relaxed/simple;
	bh=Y9ZgZldDljNqkny0VAt2gPI3yKQS9IUaYb6CFLnGRl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qw6iwoBTSK06KH4jrzlf/m49cRbyppkLDvcj0ZCRSc6NB8wG+86armYgULYiLT3Lo3lFfuKrWUxT5i/G2EMvVbpJjWkURg2CkFupoGUTid8DzOUkXEal1AnRt1Mmq/zJWlf+E9YiV2u6JKzEGrQaOOzzo+CzlvDofcgzQAFojbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cemIA4Rx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cemIA4Rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5001AC2BBFC;
	Wed, 19 Jun 2024 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802352;
	bh=Y9ZgZldDljNqkny0VAt2gPI3yKQS9IUaYb6CFLnGRl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cemIA4RxtGNILeGr1xp9e1Z2gzW5tLVgAUzyNBuon62jd91GkyAJ+XhyghavbgCK2
	 XbsdtkjnfJdnFIgVvqitU55k9uryqpG6i5ohXcyz9Lc4QoduaiRzFNZ/KOjy/UZ1+P
	 WHnhQqsagD4c6S5rwEOrrfs8GDTN5DhgSjRhjIQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bbe2de1bc9d470eb5fe@syzkaller.appspotmail.com,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/267] net: bridge: mst: fix suspicious rcu usage in br_mst_set_state
Date: Wed, 19 Jun 2024 14:55:19 +0200
Message-ID: <20240619125612.790580161@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 546ceb1dfdac866648ec959cbc71d9525bd73462 ]

I converted br_mst_set_state to RCU to avoid a vlan use-after-free
but forgot to change the vlan group dereference helper. Switch to vlan
group RCU deref helper to fix the suspicious rcu usage warning.

Fixes: 3a7c1661ae13 ("net: bridge: mst: fix vlan use-after-free")
Reported-by: syzbot+9bbe2de1bc9d470eb5fe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bbe2de1bc9d470eb5fe
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240609103654.914987-3-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 1de72816b0fb2..1820f09ff59ce 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -102,7 +102,7 @@ int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
 	int err = 0;
 
 	rcu_read_lock();
-	vg = nbp_vlan_group(p);
+	vg = nbp_vlan_group_rcu(p);
 	if (!vg)
 		goto out;
 
-- 
2.43.0



