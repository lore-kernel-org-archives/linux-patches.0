Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976081DE8AE;
	Sun,  7 Jun 2026 10:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826942; cv=none; b=PQ/5d4fQmX/VCNpAJXN7cS1WCqOa2FDzLxS+CD4mlZs+9kDeMjOpf4lsAKj2J03nnAWdWfAl2qAXwvQz/w46dM1UY8f7vxFJ1JDejOpuhUG31Cdhhz/J6QICJUeHf/gxW5aLMValuKWGppqF3E7JaQLdGbJnhGzLUGrHDSdmV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826942; c=relaxed/simple;
	bh=Ind8MhTW+TGqIOaeMZgNxPfAzVLZp6Z3Ym85qTkZ2cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMuSmS40aHA8hbZOGMjNqXuN57oLehJkSBwK9Gob7LpXhdBd3yYGLy92wp1SLu5CHsHBwQPiMQwQ/naaAuh5CjGUlynEgudXswOwHC5YA2c3TAHasoFFCU/Zc0I1Q0LuYy203pa9g5ot9gjdrK8wz2Wr51vjP4JFEIHKsCI4pdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRadBnsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRadBnsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E001F00893;
	Sun,  7 Jun 2026 10:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826941;
	bh=Hz6byYveUDddX37RTTGXX/wLH3j8fDB0aEz9xaKphd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRadBnsf81MY+qZtVkTkbVwsjObfEWqPFu8SJOuzNtzSNwlW3X1STWd2q6iVbaaCy
	 /M0yvHpO8BigRD4EQVcBWyicpXvux8rmQXba94U5lwawbIC9PNFvPaQzv03qR94LMr
	 5Z7+1V32EbB3/6HuRqKknJeqx9tum++KJ32cucOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 045/332] ethtool: rss: fix hkey leak when indir_size is 0
Date: Sun,  7 Jun 2026 11:56:54 +0200
Message-ID: <20260607095729.772204677@linuxfoundation.org>
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

[ Upstream commit 78ccf1a70c6378e1f5073a8c2209b5129067b925 ]

rss_get_data_alloc() allocates a single buffer that backs both the
indirection table and the hash key, but only assigned data->indir_table
when indir_size was nonzero. The expectation was that no driver
implements RSS without supporting indirection table but apparently
enic does just that (it's the only such in-tree driver).
enic has get_rxfh_key_size but no get_rxfh_indir_size.
data->indir_table stays as NULL, hkey gets set but rss_get_data_free()
kfree(data->indir_table) is a nop and the allocation leaks.

Always store the allocation base in data->indir_table so the free path
is unambiguous. No caller treats indir_table as a sentinel; everything
keys off indir_size.

Fixes: 7112a04664bf ("ethtool: add netlink based get rss support")
Link: https://patch.msgid.link/20260522230647.1705600-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 5416aec13b7fe7..f745ddec6fbab8 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -132,8 +132,7 @@ rss_get_data_alloc(struct net_device *dev, struct rss_reply_data *data)
 	if (!rss_config)
 		return -ENOMEM;
 
-	if (data->indir_size)
-		data->indir_table = (u32 *)rss_config;
+	data->indir_table = (u32 *)rss_config;
 	if (data->hkey_size)
 		data->hkey = rss_config + indir_bytes;
 
-- 
2.53.0



