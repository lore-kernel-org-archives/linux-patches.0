Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BC2820AE;
	Wed, 23 Apr 2025 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422157; cv=none; b=YjwfJtVWpTirWlDTGmmPfYOPLg+uOixD0UQiLijvyiN+Er1Z3mLK4/u1jZBeFDg0o/Xv2JBASAZejQrnSS7bYpI7XNmjnQGC1Gswnn4SaL7uSkC00etkx/NCH9Nd2v40RGUItVIX6C6ndjcoEoCbB1OZFuidlPMs9+NxUXNyG3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422157; c=relaxed/simple;
	bh=Caqw28F119hMOT1o27R4w5r/COTo+ZFEvqjix/o/mBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApHxxpfxcs1Dx5GGwJOrmnH6ab2BoIfGVUe+Z1R3jPuLoqt1KcfzP7ufb7MjyrM+caCOzQatqo3aJhLTJhm09itu8TshTqnnJ/fnj5hWXdG1xV5MgQ9CYRsOIY6EMaIoeSkb0AcVviWgnZF2CHeR+TvA4bvEBiSucqd5coPSdfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTsPOPVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTsPOPVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74B1C4CEE3;
	Wed, 23 Apr 2025 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422157;
	bh=Caqw28F119hMOT1o27R4w5r/COTo+ZFEvqjix/o/mBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTsPOPVry2XXagwd7t5zHIWKIQTVccZeT4Uw9Y3M6BwWCeihuKISdWK0gLCsRCqQ0
	 RyuI8IdJsgp5b/Aro0njVVfaFAeTxa0//hqc/clnnXJATE9vitU/St7xXgvQrjF5cC
	 ZKWuzCoT2DwgBrQ6UDTZXKSaX6VxG7rFqjn4Cxpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/393] net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails
Date: Wed, 23 Apr 2025 16:43:04 +0200
Message-ID: <20250423142655.238272462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 514eff7b0aa1c5eb645ddbb8676ef3e2d88a8b99 ]

This is very similar to the problem and solution from commit
232deb3f9567 ("net: dsa: avoid refcount warnings when
->port_{fdb,mdb}_del returns error"), except for the
dsa_port_do_tag_8021q_vlan_del() operation.

Fixes: c64b9c05045a ("net: dsa: tag_8021q: add proper cross-chip notifier support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414213020.2959021-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index cbdfc392f7e0d..a5420421e462e 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -197,7 +197,7 @@ static int dsa_port_do_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
 
 	err = ds->ops->tag_8021q_vlan_del(ds, port, vid);
 	if (err) {
-		refcount_inc(&v->refcount);
+		refcount_set(&v->refcount, 1);
 		return err;
 	}
 
-- 
2.39.5



