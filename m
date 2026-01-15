Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C3E21CC5A;
	Thu, 15 Jan 2026 17:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497884; cv=none; b=QjxCUid2imRskrLDm/4ZtMj3PYvankHPf7hmGKu1xjJcXq3v0+iETdv8UZ3nlhopLSB+A1jN8smDcZ5RtvJb1tAXT7Gy3WAaYDLJky863lierhweOnlRJrBBlyvknk+K7Rhz+iQomIYwdOxzXilvGMhFQ56k2u14Ql6ld1Vkz/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497884; c=relaxed/simple;
	bh=GjwydOA3/flzst649BqFEgOPXGfWlreQq3WPUZyiRXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Csta52182YAVcqGKAz6ETX7SkwGHjyVionOM057e/u3bcmjhJkR4a4WL8UnJBGJxh5kUqQPL/eXC3tPkU6MIjXZV/d2xgGul9eTkgqRVt09QCmI26uZxBiOXGaH3ydXzDuNkNEf+4HNxrWPXkaW9xPDfxkTAAco9/1CEPKt5GMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKR+puPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKR+puPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAF6C16AAE;
	Thu, 15 Jan 2026 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497884;
	bh=GjwydOA3/flzst649BqFEgOPXGfWlreQq3WPUZyiRXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKR+puPNFqv8Dn64drLp/R9HbyQ4fCRLT4i+luYxUAclhXTeGqQaAFxx0OxE2y1Jm
	 haJf/4tnMaIknJsbSC9leEcUq2iIMBuol5oGBme4coc484K9ZI1XEeuAmqGf51KZ5Q
	 uhZjDEr5HM8luztZGWN37QIq6vMomcvnas6jOREQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/554] net/ethtool/ioctl: remove if n_stats checks from ethtool_get_phy_stats
Date: Thu, 15 Jan 2026 17:45:02 +0100
Message-ID: <20260115164254.787916101@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit fd4778581d61d8848b532f8cdc9b325138748437 ]

Now that we always early return if we don't have any stats we can remove
these checks as they're no longer necessary.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7b07be1ff1cb ("ethtool: Avoid overflowing userspace buffer on stats query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 4b736385912ef..2ffd52d886cfc 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2085,28 +2085,24 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 
 	stats.n_stats = n_stats;
 
-	if (n_stats) {
-		data = vzalloc(array_size(n_stats, sizeof(u64)));
-		if (!data)
-			return -ENOMEM;
+	data = vzalloc(array_size(n_stats, sizeof(u64)));
+	if (!data)
+		return -ENOMEM;
 
-		if (phydev && !ops->get_ethtool_phy_stats &&
-		    phy_ops && phy_ops->get_stats) {
-			ret = phy_ops->get_stats(phydev, &stats, data);
-			if (ret < 0)
-				goto out;
-		} else {
-			ops->get_ethtool_phy_stats(dev, &stats, data);
-		}
+	if (phydev && !ops->get_ethtool_phy_stats &&
+		phy_ops && phy_ops->get_stats) {
+		ret = phy_ops->get_stats(phydev, &stats, data);
+		if (ret < 0)
+			goto out;
 	} else {
-		data = NULL;
+		ops->get_ethtool_phy_stats(dev, &stats, data);
 	}
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &stats, sizeof(stats)))
 		goto out;
 	useraddr += sizeof(stats);
-	if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
+	if (copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
 		goto out;
 	ret = 0;
 
-- 
2.51.0



