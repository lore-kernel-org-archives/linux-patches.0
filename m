Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D6E847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80966C433D2;
	Fri, 10 Mar 2023 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456622;
	bh=6u0ePQZ+YiBDfRz2rvDVDPqI5rsE7kLJA+yOsD1wlK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6Lw3E3/M2pIOynIGGm5oB40QI81dcfDGlYlJnVHWny5ulOJKmmRjEL/zV7i29F70
	 eTATL3tDPOA/i6JQlfRW1+1BOS+M0neO/d7MxBwM3GqvxbTE8nkXvax+wlGa/WeCAw
	 swaYjwTn2FyCyKwNfeBO1tQXF5u/tB82VzA1CtLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 066/211] netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()
Date: Fri, 10 Mar 2023 14:37:26 +0100
Message-Id: <20230310133720.760669020@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit ac4893980bbe79ce383daf9a0885666a30fe4c83 ]

nf_ct_put() needs to be called to put the refcount got by
nf_conntrack_find_get() to avoid refcount leak when
nf_conntrack_hash_check_insert() fails.

Fixes: 7d367e06688d ("netfilter: ctnetlink: fix soft lockup when netlink adds new entries (v2)")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1286ae7d46096..ca4d5bb1ea524 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2375,12 +2375,15 @@ ctnetlink_create_conntrack(struct net *net,
 
 	err = nf_conntrack_hash_check_insert(ct);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	rcu_read_unlock();
 
 	return ct;
 
+err3:
+	if (ct->master)
+		nf_ct_put(ct->master);
 err2:
 	rcu_read_unlock();
 err1:
-- 
2.39.2



