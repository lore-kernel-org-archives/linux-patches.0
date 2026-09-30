Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D46E511E9B;
	Wed, 30 Sep 2026 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786541; cv=none; b=qdZUk0k1Mu/MRVi2/agpcr9KA8JIy9wjwmpLG+jObVkRAN+p0TPG1zRB2q56Ewu+SlRDtMtFcmK3U5+Vv2CegxoAsqyRb0dNS08rmDxqG4TN1uldhw3ploCtuCpCH9GLXLmdgXY38sNBEx6ZZrjGImJRGUXetG3p1RmaIIB3leQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786541; c=relaxed/simple;
	bh=2FEo0sC4h/fT/k79FoLz53jrEOgtKqWMs1zDvYCXTGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cm2RoWv8j73KOkpcH3ED4GJD/0vkcQfwR04ZIx+e2klgds2rudHySUyykT25ywzMkxt6D2aECjCs+bMft1VAan8naXBV3NzgTxvonsliEXe3xfVLK2yopKveXUI/yhlVxVpd560oWG05spzUe3tT3g011wqCWUemqPVrz5BznBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SANL43xy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SANL43xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C686C1F00898;
	Wed, 30 Sep 2026 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786540;
	bh=s3khc5swQxlQKswb6BIVvKxmLiqRNPTs3DHhPQD6CaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SANL43xy4rIs0onQQVS99mt1nRrsNwWgg8yPSlhctamxLcIaTzGi1qS6kVVSe96Ks
	 QGqjrAUrmkCaUi9h9hkRyfU3dT6dvvhGw5JFtSKEBeomgy8Ivj2p8HUSLVWRUolofV
	 kf7L7AHmcppsA37YQWDNnWgkdZS4UlrZJAevtyUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 898/982] net: bcmgenet: fix 64-bit RTNL stats reading in ethtool on 32-bit systems
Date: Wed, 30 Sep 2026 17:27:14 +0200
Message-ID: <20260930152436.031514037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 0e2bec77ea62895416600c90588f593516572bca ]

When bcmgenet was converted to 64-bit statistics, STAT_RTNL members were
switched to point into struct rtnl_link_stats64, whose fields are 64-bit
(__u64) regardless of architecture.

However, bcmgenet_get_ethtool_stats() retained a legacy check:
  if (sizeof(unsigned long) != sizeof(u32) &&
      s->stat_sizeof == sizeof(unsigned long))

On 32-bit systems, sizeof(unsigned long) == sizeof(u32), causing this
condition to evaluate to false. As a result, 64-bit RTNL stats fields were
read via *(u32 *)p. On 32-bit Big-Endian systems (such as MIPS BE), this
reads the high 32 bits and returns 0 until the counter exceeds 4GB; on
32-bit Little-Endian systems (such as 32-bit ARM), the value is truncated
to 32 bits.

Fix this by checking if s->stat_sizeof == sizeof(u64) so 64-bit fields are
always read as 64-bit values.

Fixes: 59aa6e3072aa ("net: bcmgenet: switch to use 64bit statistics")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260921220021.281418-2-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index a22f569987c6f..bda534237a7a9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1307,9 +1307,8 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
 				p = (char *)&stats64;
 
 			p += s->stat_offset;
-			if (sizeof(unsigned long) != sizeof(u32) &&
-				s->stat_sizeof == sizeof(unsigned long))
-				data[i] = *(unsigned long *)p;
+			if (s->stat_sizeof == sizeof(u64))
+				data[i] = *(u64 *)p;
 			else
 				data[i] = *(u32 *)p;
 		}
-- 
2.53.0



