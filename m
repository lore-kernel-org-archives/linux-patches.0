Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D77881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F228C4339C;
	Fri, 10 Mar 2023 14:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459287;
	bh=RZEf7v+wyeHDpn5PIlC3RxFgnFy8sBoUQvxBZ+pUalo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfPC+7Bu0krFiSAU/OJlQWITVtum6BrcyZMVHenjhA/srGxAXqQ00M9nWA5Q3qecL
	 5FRl9Scbi2VCNvwhxlG0BmmTmjpmEehK/q4NIZNAOnphJCVl0fJTHbo/W9FSvHp1m/
	 YyNaOXINMHeei6/sPDyq8NCVWNvA0WWZcF5m2RtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 311/357] netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()
Date: Fri, 10 Mar 2023 14:40:00 +0100
Message-Id: <20230310133748.429493239@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index bc6f0c8874f81..4747daf901e71 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2086,12 +2086,15 @@ ctnetlink_create_conntrack(struct net *net,
 
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



