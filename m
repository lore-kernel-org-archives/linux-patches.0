Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812D21DE8AE;
	Sun,  7 Jun 2026 10:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826908; cv=none; b=E4mrZgtRJJPrtFjybSWM8TTs5jpzDKSZBvXsowpVFPsJYsT3s/oj3GwHONMcUDG+4VsoJGtUXY1m/QUc4ifkMCEfqdfd6kN7QQ7MWzyEJB4OYwWqg0tQEdgfBhsHJelrNntNjr8nqRUBOVe/jGyextmRKUGTAR+qe/OWOVCsLMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826908; c=relaxed/simple;
	bh=g26Ri4mUkbTTDViQ4AHLKqtnr6EbX4r1AONdkXCgPho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UF+YEd+HqnC8lieViYVeKLS9oJECr4oU7HkKYfhnYzXy7epb9NuFoLojS/eRLqF5LpKkW08+U9HxuYAp/d0kxw3uNFbG2PLtO7FGh2lCxwkrzdLFP8g4HEJ2MBxIrBqxPh5LWB+b7w9dk3eaw3+UJs8PoUvakBM/SoR+8freG9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tClJrsYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tClJrsYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23521F00893;
	Sun,  7 Jun 2026 10:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826907;
	bh=KpL63wh3M1nQBrvHU8SyOAJ5GJZDkqEDcWLBcISo0xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tClJrsYOPG4h/gAtbuIb8no+KsjRhkTBIXnCCayQzBX3ewMdlmN0k6gdr0/jgNq6l
	 EnbWXqd8uDxRemj1Wu8sgCYkJiU0nB+4DqAy3VnggK/KxIX86QV+UAsFnZnTn8cht2
	 2RGSZrtIBYdIXSDWNVeXEvR0gN9TG13N6Z7WA9UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 042/332] ethtool: rss: add missing errno on RSS context delete
Date: Sun,  7 Jun 2026 11:56:51 +0200
Message-ID: <20260607095729.660978250@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 3e6c6e9782ff8a8d8ded774b07ad4590cd61d04c ]

Remember to set ret before jumping out if someone tries
to delete a context on a device which doesn't support
contexts.

Fixes: fbe09277fa63 ("ethtool: rss: support removing contexts via Netlink")
Link: https://patch.msgid.link/20260522230647.1705600-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 926be5698ba4cc..688c0e4bba69db 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -1160,8 +1160,10 @@ int ethnl_rss_delete_doit(struct sk_buff *skb, struct genl_info *info)
 	dev = req.dev;
 	ops = dev->ethtool_ops;
 
-	if (!ops->create_rxfh_context)
+	if (!ops->create_rxfh_context) {
+		ret = -EOPNOTSUPP;
 		goto exit_free_dev;
+	}
 
 	rtnl_lock();
 	netdev_lock_ops(dev);
-- 
2.53.0



