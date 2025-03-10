Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E232206BD;
	Mon, 10 Mar 2025 18:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630432; cv=none; b=UwiAEtieKGIWcDLOKR9VHKlhAETIWDLv3oGu7xbkDCM2RA3tk7OFfWEjE3XheT0ykMC0mA8VSSLv2t+iYBiYkPv/X37fKUz3Eesb835VZR7HdTV2ZassIPgfKZV7THqA197bL2P3eZegwYmsnJE82t+zZsTcw8/PqntJKIeTSNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630432; c=relaxed/simple;
	bh=ZgA4kHqqJVMGJhUT6P3VfVs6iMWIM/OM+ieLoXF01dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No6gPumPiMZokjHrAx9YI3qjPpSvBMSihlqwXJ5tEdYJUJFmMuniqsK2x2RmcHoiYSh+1FgH2hOIfoBJk5zCXj8G2f2xlKWo5ng1hidlu97oE2RY9bnbSbAjAkW3waS+UVWJ+Z00FYFH89yOe8b9aprg1BfKZ21N3MgSIbDvL68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oL3QSDhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oL3QSDhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D909C4CEE5;
	Mon, 10 Mar 2025 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630432;
	bh=ZgA4kHqqJVMGJhUT6P3VfVs6iMWIM/OM+ieLoXF01dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oL3QSDhNFocaYsXzI9K/l8v6AtJrXWOmevBTNb3JUhNNvyd3lQBV9KIK3eOsQYsl9
	 pi78+t8fYrnNrV/2GWkEP8Qm9NygvuBEdqaO0BsVcYL464eEQbq4xeEJO9za4pd4uA
	 ISdTfvMCLxYQwCL1y6z1ISFav18QVCrzXdmrzpUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 404/620] neighbour: delete redundant judgment statements
Date: Mon, 10 Mar 2025 18:04:10 +0100
Message-ID: <20250310170601.538889738@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit c25bdd2ac8cf7da70a226f1a66cdce7af15ff86f ]

The initial value of err is -ENOBUFS, and err is guaranteed to be
less than 0 before all goto errout. Therefore, on the error path
of errout, there is no need to repeatedly judge that err is less than 0,
and delete redundant judgments to make the code more concise.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: becbd5850c03 ("neighbour: use RCU protection in __neigh_notify()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6f3bd1a4ec8ca..7fffbe0424342 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3387,8 +3387,7 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
 	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
 	return;
 errout:
-	if (err < 0)
-		rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
+	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
 }
 
 void neigh_app_ns(struct neighbour *n)
-- 
2.39.5



