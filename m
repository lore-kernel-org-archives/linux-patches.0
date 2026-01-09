Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A5833CE9A;
	Fri,  9 Jan 2026 12:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960240; cv=none; b=HlL0p/Myibwr+u27RxWxdrO3T8GVNG4hLog9h8uC37/O3f0dJJeV463K5c0PqBPCcjvMV5isbp1exif5zAB/GY3OGly9RSspjJVFQJhpt5xgQ5c8OkZ6BJfh49XzCet3wPCqbvLAQAvM+JAeitcvrE1p9bXT/TaWkiC/4FLXt94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960240; c=relaxed/simple;
	bh=yATn79dCKJiqC8KwdvJhY2eRun8K3FTzPkdMYhHcPqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPEiWLchb+CG8fVHhhZNBiy8OF5EIXcSg6Zki9rEdoXIKLkEjLrEbCZ5xNnHBkejSugOL0FHPjEsV7fV6I4VT1V9pz+nmNLOZaee/3MWgmWvgL8+FUJJdqJAEqQzr84Jqdae6zL3Di0yPQ+Tcco0DblKszpr7++mxWDoT/1gHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYUzPTpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYUzPTpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B353FC4CEF1;
	Fri,  9 Jan 2026 12:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960240;
	bh=yATn79dCKJiqC8KwdvJhY2eRun8K3FTzPkdMYhHcPqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYUzPTpzoOR1B8oeSvG1/23xPjGHBRWnAMKqZNbol8++ZXnc6fuPkB5qNLbj8HtCz
	 NYJYFgRKFqXPXmddMzhP+16poTYkJCTEQUZmQRpu2ETnLaU+IOG+1H37iYbILcL7F1
	 fDmzA9M5uBhydL5WDszxYXhX0dVakM11VC1nAKSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 335/737] mlxsw: spectrum_router: Fix possible neighbour reference count leak
Date: Fri,  9 Jan 2026 12:37:54 +0100
Message-ID: <20260109112146.594553475@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0534b10e29c5c..f5c34218ba85b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2857,6 +2857,11 @@ static int mlxsw_sp_router_schedule_work(struct net *net,
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
@@ -2880,11 +2885,6 @@ static int mlxsw_sp_router_schedule_neigh_work(struct mlxsw_sp_router *router,
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



