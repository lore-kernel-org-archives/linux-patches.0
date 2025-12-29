Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A362E347C6;
	Mon, 29 Dec 2025 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025112; cv=none; b=PoyYDE4oCWxoD19nysAs9I5IqmYqyCXqB4vS2igR9jN9XPQBpfNuM1D9m8pI/MYMopiNbTgEzQlYSPiEdlTqe92WdNfwVio1SFUDRVxxe0Hlj4f+D9F7gc+K0cUxVovjPV6p1DbKTLMvtG4kj6AZqbDdB9gBTIyh3SD3Cx99cwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025112; c=relaxed/simple;
	bh=xOkMnL8hoPqXiJ6oFtmqeAwWJF4AFg3D5wb6UJOTX9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/DB/pTiqjq6OgFPyEZxCRaOJAJU9U98+qrVCjzP3oc6l5L1BwzBN5ggIUOHYWuOLyxdqe6zrdOVYGrVfgF0W0q2h7RgdpiXHvzb8/kkJAiAvaKwQWuu7P/wKzM9Yer8P9Xcqp+twiAOCRlDtpcEkqO77ALXU9Q4ueAnWKwfvgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5Hcwh9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5Hcwh9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB5CC4CEF7;
	Mon, 29 Dec 2025 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025112;
	bh=xOkMnL8hoPqXiJ6oFtmqeAwWJF4AFg3D5wb6UJOTX9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5Hcwh9MY6+4ul/ah9JaZIW7bDzvt5sP8H6uIIL/0YC6hOubtM79/JZfvOeroQoLG
	 QCalTSDCyJYeCjhznjzlzCWKh15+7Bi6uE2cIcHdAjCYjoU5eSjPtnllePyGqmpJ5m
	 7gYS5SqLHUhNbDx81oxE3eLUZw7xcmDjFpctn+rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/430] mlxsw: spectrum_router: Fix possible neighbour reference count leak
Date: Mon, 29 Dec 2025 17:07:48 +0100
Message-ID: <20251229160726.794671283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

[ Upstream commit b6b638bda240395dff49a87403b2e32493e56d2a ]

mlxsw_sp_router_schedule_work() takes a reference on a neighbour,
expecting a work item to release it later on. However, we might fail to
schedule the work item, in which case the neighbour reference count will
be leaked.

Fix by taking the reference just before scheduling the work item. Note
that mlxsw_sp_router_schedule_work() can receive a NULL neighbour
pointer, but neigh_clone() handles that correctly.

Spotted during code review, did not actually observe the reference count
leak.

Fixes: 151b89f6025a ("mlxsw: spectrum_router: Reuse work neighbor initialization in work scheduler")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/ec2934ae4aca187a8d8c9329a08ce93cca411378.1764695650.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a2033837182e8..f4e9ecaeb104f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2858,6 +2858,11 @@ static int mlxsw_sp_router_schedule_work(struct net *net,
 	if (!net_work)
 		return NOTIFY_BAD;
 
+	/* Take a reference to ensure the neighbour won't be destructed until
+	 * we drop the reference in the work item.
+	 */
+	neigh_clone(n);
+
 	INIT_WORK(&net_work->work, cb);
 	net_work->mlxsw_sp = router->mlxsw_sp;
 	net_work->n = n;
@@ -2881,11 +2886,6 @@ static int mlxsw_sp_router_schedule_neigh_work(struct mlxsw_sp_router *router,
 	struct net *net;
 
 	net = neigh_parms_net(n->parms);
-
-	/* Take a reference to ensure the neighbour won't be destructed until we
-	 * drop the reference in delayed work.
-	 */
-	neigh_clone(n);
 	return mlxsw_sp_router_schedule_work(net, router, n,
 					     mlxsw_sp_router_neigh_event_work);
 }
-- 
2.51.0



