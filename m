Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537E9882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA7BC433EF;
	Fri, 10 Mar 2023 15:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461146;
	bh=dP7hM5bgOcBfZUoXrGm3fNhOJ+ekyystG8z7bvDAt3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMavcHkvn6unnj9C80m0tv5rQPKmJtayDUr9N/3KA9mAN/4TZTUhpH09gkyIZvOk3
	 9nP5fgcc0lOglCE8DEPwcqE8oACRGECIa3K55Q1tXTxeet6WT03jcJI9H1RGbBgWAQ
	 M5LUkeo52EOADqUZj+F/Zb+tAWNso128faz0HUwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/136] netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()
Date: Fri, 10 Mar 2023 14:42:43 +0100
Message-Id: <20230310133708.314331045@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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
index 2cc6092b4f865..18a508783c282 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2396,12 +2396,15 @@ ctnetlink_create_conntrack(struct net *net,
 
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



