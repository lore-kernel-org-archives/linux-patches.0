Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40C02E739E;
	Sun,  7 Jun 2026 10:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827093; cv=none; b=H8fPFdhUuUr+wu7hQ+4/s6hycA5YUQ0y07jKVgEbyPdCnK2pOpEg1WCgDifn1pMTG8/HWHB2qVSHOiNWsOSN/6+Mz8+nlCDOWU+5jbKb11AdctxKjO/WFrtHjBmReI9jyDzffKRBYvdh4VILUs6CoyxXFEXkOTyr6xOlxB0l1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827093; c=relaxed/simple;
	bh=Ov1CTaHwhM/CRWD5fR7ud62UtTPAESDI3yYpicGJlMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGcEJSZOGVKRhFZwYnYHckx7dgUYluqjji8gov44Zv0q4508aridjJ7oi6Uh1w4ZVYrJvcQO+1lp9/88MnDrEXcCdjHTu5nzxPspJYD+GQ18XLSyXbt2VClS0p24fCMzNjCCNxZ8DmhU07Y7H9+KCSjCEE1ttW2JstMoRfRPBGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGl0DnTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGl0DnTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5DA1F00893;
	Sun,  7 Jun 2026 10:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827092;
	bh=OWkL5N3MfN5yXsd22M5FmHvSkZ+XUF4LgjQ5qNu1Snw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGl0DnTWwMC1T8596qeCf7ldEVq4Yb2UPtBVkOJN3tqmgvJAsI0Hh0+JqS6wDvMWq
	 09pBnKzezSoVXKc+zpSjSEJCmvfHBC30NQL01aX/hEDEfghSYiLbbHRyOxCEx2Psne
	 pvXuoluTB2OIFH2tRwCobiffyCzoTIDkEJGM5Ed8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/315] ethtool: rss: add missing errno on RSS context delete
Date: Sun,  7 Jun 2026 11:57:06 +0200
Message-ID: <20260607095728.984954761@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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



