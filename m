Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30704218A4;
	Tue, 31 Mar 2026 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975831; cv=none; b=Dbr9drwv6qxg7vkEzltmSmKwWKshhxEVjcMj3xn3akRahWDycPS1MO6GvossHDGKGDRPrxcl+0UKTvqWUSWXTgCAU283AyLoBzSnnvZpzhOEx+Ai8kFzlJcDI2PlNfplayQxFEZeJIn+9vPb910yr5JM0qsy6u6fIPUk6FH24BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975831; c=relaxed/simple;
	bh=KtYrJzm9q5l1sdkLEqcboGOGFyFI1vA3DEz77pezoPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHvyfmg+J4kRcQElSNUQGuJFhxKE/SsME+Li23024vEIePnGdTUZFwbjrtauxy+noYWx4LrzHxqLXr2/mcaCn2Boa96ghYjv/iAWjAhcH+9PzoRfRuJFwvG3f+FhFOH8lUI6O5oKTIWzkuHKlq2GDvqyPFmIb5CHKqI2Jw4WZRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHcVE4L7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHcVE4L7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697F5C19423;
	Tue, 31 Mar 2026 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975831;
	bh=KtYrJzm9q5l1sdkLEqcboGOGFyFI1vA3DEz77pezoPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHcVE4L7Tv1ObGBeDCYKqtQ0MvI4Y4hXLRghsGfswzr3lSmbbFq+Z4RU+lKom2sUB
	 1p1sz0i0XlKkdRohZQyTueUx0KX/kYi4nSN98suBXycGKJEYEfheAZ7zWfEx4PNqZb
	 SAJaLDNGhn75BqW/fDyn/cXfeuN811/rzscNw93I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/244] rtnetlink: count IFLA_INFO_SLAVE_KIND in if_nlmsg_size
Date: Tue, 31 Mar 2026 18:20:21 +0200
Message-ID: <20260331161744.310707643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit ee00a12593ffb69db4dd1a1c00ecb0253376874a ]

rtnl_link_get_slave_info_data_size counts IFLA_INFO_SLAVE_DATA, but
rtnl_link_slave_info_fill adds both IFLA_INFO_SLAVE_DATA and
IFLA_INFO_SLAVE_KIND.

Fixes: ba7d49b1f0f8 ("rtnetlink: provide api for getting and setting slave info")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/049843b532e23cde7ddba263c0bbe35ba6f0d26d.1773919462.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 650c3c20e79ff..24722671cbed9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -557,11 +557,14 @@ static size_t rtnl_link_get_slave_info_data_size(const struct net_device *dev)
 		goto out;
 
 	ops = master_dev->rtnl_link_ops;
-	if (!ops || !ops->get_slave_size)
+	if (!ops)
+		goto out;
+	size += nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_SLAVE_KIND */
+	if (!ops->get_slave_size)
 		goto out;
 	/* IFLA_INFO_SLAVE_DATA + nested data */
-	size = nla_total_size(sizeof(struct nlattr)) +
-	       ops->get_slave_size(master_dev, dev);
+	size += nla_total_size(sizeof(struct nlattr)) +
+		ops->get_slave_size(master_dev, dev);
 
 out:
 	rcu_read_unlock();
-- 
2.51.0



