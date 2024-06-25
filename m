Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4F513C90B;
	Tue, 25 Jun 2024 10:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309701; cv=none; b=ST5P+eFda968KtQDkEYK88vTdfY2lf8uvrI60sRnGjHakJ8ACny6VAD94UOBbe2HMyKgqv16EuwlUpOXzjET0r96ytjPbUnoEYUNFglT2BCIIXR1KSnrPJeS1P/XGDZOP4yVth/H/KNrTWjc51a6vPLmCQ9Ntfu0rTVKGv7PN08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309701; c=relaxed/simple;
	bh=ikR+9dfAGUIaLTP3dthYabaS1E1hjedC9l49rED3isU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYqkKapth1FSF3VGfqR6XkvV89mngPPbUveb+oLdYnPdU9Muv0jIxFf6uvlFzhFhbXmnQDg/N4SS+CdTLk4t6Mlnb4YxjnjcBNcVWTUAvbTb3OdECjPTesgeWomb0vtWAczes3eGA5i0ntqVeN6THSj6AW3p0WS6p1kTMw0l6Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYbX+zsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYbX+zsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87473C32781;
	Tue, 25 Jun 2024 10:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309700;
	bh=ikR+9dfAGUIaLTP3dthYabaS1E1hjedC9l49rED3isU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYbX+zsRDX+1kRIWzc3oI/IUlnFyIibCa4+UUXI4RfS4wiawqK20jrl/+XUDDjuZW
	 2n4+/9JL21W5X0CcrNcq/y7lRHhtZLgVeeOLxHfItEGmMnDPMsLCmmmiivvqw72S2v
	 6eTpjU9TQu9N70Imh0mqsejVHeL7WfGdaiceWKV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b62c37cdd58103293a5a@syzkaller.appspotmail.com,
	syzbot+cfbe1da5fdfc39efc293@syzkaller.appspotmail.com,
	kernel test robot <oliver.sang@intel.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/131] netfilter: ipset: Fix suspicious rcu_dereference_protected()
Date: Tue, 25 Jun 2024 11:33:48 +0200
Message-ID: <20240625085528.718154828@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 8ecd06277a7664f4ef018abae3abd3451d64e7a6 ]

When destroying all sets, we are either in pernet exit phase or
are executing a "destroy all sets command" from userspace. The latter
was taken into account in ip_set_dereference() (nfnetlink mutex is held),
but the former was not. The patch adds the required check to
rcu_dereference_protected() in ip_set_dereference().

Fixes: 4e7aaa6b82d6 ("netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type")
Reported-by: syzbot+b62c37cdd58103293a5a@syzkaller.appspotmail.com
Reported-by: syzbot+cfbe1da5fdfc39efc293@syzkaller.appspotmail.com
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202406141556.e0b6f17e-lkp@intel.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 649b8a5901e33..0b24b638bfd2e 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -53,12 +53,13 @@ MODULE_DESCRIPTION("core IP set support");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 
 /* When the nfnl mutex or ip_set_ref_lock is held: */
-#define ip_set_dereference(p)		\
-	rcu_dereference_protected(p,	\
+#define ip_set_dereference(inst)	\
+	rcu_dereference_protected((inst)->ip_set_list,	\
 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET) || \
-		lockdep_is_held(&ip_set_ref_lock))
+		lockdep_is_held(&ip_set_ref_lock) || \
+		(inst)->is_deleted)
 #define ip_set(inst, id)		\
-	ip_set_dereference((inst)->ip_set_list)[id]
+	ip_set_dereference(inst)[id]
 #define ip_set_ref_netlink(inst,id)	\
 	rcu_dereference_raw((inst)->ip_set_list)[id]
 #define ip_set_dereference_nfnl(p)	\
@@ -1135,7 +1136,7 @@ static int ip_set_create(struct sk_buff *skb, const struct nfnl_info *info,
 		if (!list)
 			goto cleanup;
 		/* nfnl mutex is held, both lists are valid */
-		tmp = ip_set_dereference(inst->ip_set_list);
+		tmp = ip_set_dereference(inst);
 		memcpy(list, tmp, sizeof(struct ip_set *) * inst->ip_set_max);
 		rcu_assign_pointer(inst->ip_set_list, list);
 		/* Make sure all current packets have passed through */
-- 
2.43.0



