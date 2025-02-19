Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01281C4609;
	Wed, 19 Feb 2025 09:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955814; cv=none; b=GwvWRvJBR38/OO5ABM1h3rGjuiTvGzgF/OWOCpBKhnMAfO6fOhpgUp+BFFnuG5oSysMH2RCINrxvFpiyivUWRo/qn0d+n+A+aiIAhJ4oTkkW3ajccA3RRqmqANyjDSeuYqu8P7bpWct+YpjfyjXMohT67m2HfSrCOgnmRWdZrzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955814; c=relaxed/simple;
	bh=ewA+vV+OzI/CvjSGN3EFHFt0mzGTxrb1uoW12o7P0+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okAtB8b+MLE8difXgoYezI28QubdReHusR6XS8B9brJmfGKJ9ey63DsblOyNbTCIwlEUyphZnply8ivJfr14G+JD6CSJyLlrEBS0UAsHsojNyloFkMmVX9GVoI2iYk2fmhGyipowx/JO6UhQ77VGdE1y3/7GvFb7AKlYYMWk3uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwavNkoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwavNkoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4237DC4CED1;
	Wed, 19 Feb 2025 09:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955814;
	bh=ewA+vV+OzI/CvjSGN3EFHFt0mzGTxrb1uoW12o7P0+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwavNkoTTIJUWBXSJCdG0nxRSWTwwgi/URN64UhLFF8+GRM+A3dm360oYYg4Gsytd
	 rEYVtso4uWEMgt/swPoojieKEx7EF0YHsvTEjL9dvoA1Xx0N1Cfb3FcMk5LCgkeyUX
	 tESIpK1p5mstLKrqqv0uiHsDS0xu+tPopmF+pyhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/152] neighbour: delete redundant judgment statements
Date: Wed, 19 Feb 2025 09:28:55 +0100
Message-ID: <20250219082554.878145031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cb0c233e83962..118d932b3baa1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3526,8 +3526,7 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
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



