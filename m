Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630E95172E5;
	Wed, 30 Sep 2026 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785155; cv=none; b=Ps0DTNtqyO+eY39o6+YbTH1jItClXH3Q/m/UBFctt8zQdE1wWin99sJi1aXUvTD4PaOw4fIENWrCK/yNtrVrz3YM87t4rF7I5kYwoQnFrynABrHwvL/A8kwq/DB41NS6S6eVAC5hv0twaFudTHOxVfeRTUZdmsfjdIyjQfDmcoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785155; c=relaxed/simple;
	bh=XVAtfBlP1jSmWixkuKTBJMq0fDPaYt6eMFoJLAkJcCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzMq1lHGQZ6goHrdDt1o8p/HyHmExHXaQFpBI+goL4i61VdMpoulp1no289FOIlOjrV7uM75Fg8dbyEbwYiBJfDOn8E5nwYIVHuFgLrLi8P6COv/Igqy865JpjttRjFWfatJ3Or5Rgyyy172hMQEfzJ6v5AA8htKmYPbiagp/mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmKRV2mw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmKRV2mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3823D1F00893;
	Wed, 30 Sep 2026 16:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785149;
	bh=23t9uFSbkFx0KTyy/I7sRMPBESvnlf8XIEK5KfEzXcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmKRV2mwx45OKGusNF9zllJBhR0VTHQYSr/3HKD9MKKQkSqEiqpR6uX+tSCR/0tOm
	 dtGqFyRdtDOWm2GF6/KWnxVsnSD2B89PZrg5wmB7divjVRBWZC59mVA5YKwo1qYowi
	 l3x1Pqg+QmH+Hkz1vDtxzyzloGWOMV/nDrOBvStk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 408/982] nexthop: Initialize extack in remove_nh_grp_entry()
Date: Wed, 30 Sep 2026 17:19:04 +0200
Message-ID: <20260930152425.571729850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 13a798f9dc9cb..cd93dd74608ac 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1736,7 +1736,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
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



