Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F42E25D8E8;
	Tue, 11 Mar 2025 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705993; cv=none; b=h0mG6v/hYRaL1jWT2XC5xmkIy3ut7cStsIVA16N6CFlQTS7ClJd2f55NPNB5wVXLvx30qSOxwqTV0wObHdX/pfBAJ3KpGjQ+GxgUJUALAlnscbFIFz1geZq8bu0lvE63uYqSaTlhwu4aZSUIEsEsWTIFViRPEKdqt84f1rV7D60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705993; c=relaxed/simple;
	bh=tg/iFOzKJbrXe7I4HGUYOZsf9qpTMw/Ri1o6G4+0ecE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isikLTTnWKBIgLZEVJGix+RZw9mzlKuv0F1Lcix70WpgGHypIFjA3G18xAG0TVOWx1fLXrI/aHY84nZ7pDuroTof04D8k6fCM/PADk5Ft9FXCQFi5ddev6LI3AOTN+E1PcYX1lmB+phJEldKzroEljOhWTtR7B4sWWXMHvNUuVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNp09+d0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNp09+d0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA003C4CEE9;
	Tue, 11 Mar 2025 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705993;
	bh=tg/iFOzKJbrXe7I4HGUYOZsf9qpTMw/Ri1o6G4+0ecE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNp09+d0UsTFKTd/j7BIv/iGP2iXpdZYCo8J6fOsP2JxEtwz+vbMqBM0vDV2Tmnbr
	 51+CKTbKpGfuMF4LdNz8X15uYyW9jr6Ebxs91pbiamYi2rcEQGBw9ihmxVEUi0mnQd
	 smnvVnW78612azCrmrEho7csgEtPOp1Iho44ZXTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/328] neighbour: delete redundant judgment statements
Date: Tue, 11 Mar 2025 15:59:37 +0100
Message-ID: <20250311145723.133765401@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4dfe17f1a76aa..3e007cbadb707 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3382,8 +3382,7 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
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



