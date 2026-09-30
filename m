Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52315208A6;
	Wed, 30 Sep 2026 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789546; cv=none; b=GqWKHvySumpl360RUtR758E7evU0/BAewhyrNI4wA8sQ+LPqnC8TQOxn+SpQPCWlNsHuOXXBnGvuloNNiZLGfAdSdNqpxzMTb9jywmhArfq+wcQYNNpps1sIUerrSrzkOUssmdnmk75dvLEtZt95F+uCb0DsJAtmcUCBKME/I2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789546; c=relaxed/simple;
	bh=2OLaeREFnRfpBcxPbXfhq5j7ZWL6/lMN6VEhw1h/mbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBeuzpHfi08P5YG7loECGMXOM/UsrYShhtLsYVkNqz6R6SMu8pf38R1MFQBdCEE/S1OvpT2AWiZJ/Svp+wmm0DVWP+xLYnIBREjAoow+j+nqzV4fJswzgAggXre44PAFDaS3gF98awtPDaIVw6jlIaoTh9A4pP9g6WsxAfwZxvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDKPD9r2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDKPD9r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B97B1F000FF;
	Wed, 30 Sep 2026 17:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789544;
	bh=RZp1BrhAGIaISv10P7agApPinofDAuMeOCWaTk411Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDKPD9r2qofwqFNkKYBbgSzTBrbtsbA9NfUhjL7n41fIwQcyfy5TTssZXJ7Wq5qgM
	 yfKmUFlPP0RQRFH16LEugwanq3o5ibfEDyh6/3eChziDka2j16gqjHnWRyDru8F1p8
	 y4M2DzgdzfyPL3ZESClObJlsJnuUlgqeLz8u91c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fourie Zhang <fouriezhang@tencent.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 515/877] net: bridge: mdb: restart port group walk after deletion
Date: Wed, 30 Sep 2026 17:23:46 +0200
Message-ID: <20260930152425.768706653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Fourie Zhang <littleddfu@gmail.com>

commit ab1404ac81154a89fb61ac50ae9a04cd8d4834dc upstream.

br_mdb_flush_pgs() keeps a pointer-to-pointer cursor while walking
mp->ports. br_multicast_del_pg() can re-enter the same MDB entry through
br_multicast_sg_del_exclude_ports() and unlink other port groups. If the
cursor points into one of those groups, the next iteration dereferences a
stale cursor and can leave mp->ports pointing at freed memory.

A following RTM_GETMDB exposes the dangling pointer:

  BUG: KASAN: slab-use-after-free in br_mdb_dump
  Read of size 8
    br_mdb_dump
    rtnl_mdb_dump
    rtnl_dumpit
    netlink_dump

Reset the cursor to mp->ports after every deletion. The deletion removes at
least the selected group, so the restarted walk always makes progress.

Fixes: a6acb535afb2 ("bridge: mdb: Add MDB bulk deletion support")
Cc: stable@vger.kernel.org
Signed-off-by: Fourie Zhang <fouriezhang@tencent.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260920110852.60293-1-fouriezhang@tencent.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_mdb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1505,6 +1505,8 @@ static void br_mdb_flush_pgs(struct net_
 		}
 
 		br_multicast_del_pg(mp, p, pp);
+		/* br_multicast_del_pg() can remove other groups from this list. */
+		pp = &mp->ports;
 	}
 }
 


