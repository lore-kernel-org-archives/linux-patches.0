Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E85949D58C;
	Thu, 17 Sep 2026 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665687; cv=none; b=K26iQ1KXVmcj9jWzBWyrBP6x9zH2L/fdjPDe2PhsNp1YjiKyNsvjmvzRgASkoRgs7xdz7rCUk3jIng58h/V5kKilYgNTVWeSXXia648SpxLYjimAKdMq4euFk1cgdaZh4tWqisXJhxTITlyFYLYuD1REqpsPE0C59C0z3jjEX9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665687; c=relaxed/simple;
	bh=yJuWz9ybUd7D3bNRMr4ZE4zIlM8c/gUaW+CAIysMpQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjFP+0lhFQFD8s1wyGPYLLzPC04rMhgzcZI16OPrDZDoD7RXCeth0Yk7Bia6aYe+jjjmf0aqodJ/3eYKc0hRTPwW+9B0BPgsyhRtOl6ptsrmEbceiTRZ2dl7tpbiAUkrLC/j0cW/ys4QNTfz0SqH2mTXgARW4ZC/tV3HravBe5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgBRhDiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgBRhDiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ED11F000FF;
	Thu, 17 Sep 2026 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665686;
	bh=juvAF1ej/Jtv0UGTESquQVbuT8bh6SJVRqYPpXn3vUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgBRhDiqkDAapnyqggNsIlDCJ+gl/4GCRzD1ush1aB0k29CY6wGVJNz+OSrTFq+rT
	 2Z02y7sB5lg6eBmvRHX45tNVXKkcAUZi7f8mL1eTdXDHyMLvpTQ8RCp8/svLpvvev0
	 3KhYSLEzjMQi75BVmRvdP2M4h5TiuO/g2gSJP2nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0788/1250] nexthop: Initialize extack in remove_nh_grp_entry()
Date: Thu, 17 Sep 2026 16:09:43 +0100
Message-ID: <20260917151613.252932064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5bd9e4e7cdaa03879e9b73b12ab52cceb1edd55b ]

remove_nh_grp_entry() prints the extack message when a listener fails
to replace the reduced nexthop group. However, extack is not
initialized and listeners are not required to set a message when
returning an error. Neither netdevsim nor mlxsw do so when an
allocation fails, resulting in the dereference of an uninitialized
stack pointer.

Fix by zero-initializing extack, as was done in commit 6347c5314cee
("nexthop: initialize extack in nh_res_bucket_migrate()").

Fixes: 833a1065eeb1 ("nexthop: Emit a notification when a nexthop group is reduced")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260903080259.10378-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index a8bf1ec548995..66d5c996866bf 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2025,7 +2025,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 {
 	struct nh_grp_entry *nhges, *new_nhges;
 	struct nexthop *nhp = nhge->nh_parent;
-	struct netlink_ext_ack extack;
+	struct netlink_ext_ack extack = {};
 	struct nexthop *nh = nhge->nh;
 	struct nh_group *nhg, *newg;
 	int i, j, err;
-- 
2.53.0



