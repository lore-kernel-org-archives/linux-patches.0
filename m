Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB650B433;
	Wed, 30 Sep 2026 17:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787761; cv=none; b=o3R7sKLl1tIg/b2BCu4kQPkOUVHAj8EQZqkvfUa5yE3dDImLXG6fhM37qngoWiT8Dv5QBVrvfsc12TDlt/qO1wLZnW0Cmuq07Z7SVSvSgSBUzbeHYKECAuPfrwtweqTdwd54Rth5eZTck3V7Jqmw95Ed+Y+hZH4lXQzPkJ69Ulk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787761; c=relaxed/simple;
	bh=NlwoyHCJzx3PMRmS1emTwACNk0rpDJNPpXvpJW3Waig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rU2DTC7OsQ6jxStbybS9gbrlgY9NNbD8t+2Aa57Q5X3F2CunYBLwiuCedV7NUcsDerjQGhJvHH/wJPX1swTpGjBfy68Xhd/zklFIF4CvVxd3LaG5K9MNnWr+P7AZ6js9HZ/SW3IIHEhyE0sJedOQEcMOCViupGUSoTdrpruC8QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkBKTVca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkBKTVca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99B81F000FF;
	Wed, 30 Sep 2026 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787760;
	bh=ON+i7tmOYz5QtSNshG3TRLs2QMcQL7WmdxN/t6KB3y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkBKTVca9sNYlDaUxHBhyJLhaYqUIVrUfyHEv68SeuZInSF2Dh/STb6Tm3jzSA2Db
	 PzJ/nrThzMe9+QYEu/lgWmaufjhfl6Tz1ZDnZssPF1a0ndlIV1+/5hc2rwQYEHpaqw
	 TdJFTsIDvrSxFH7EbqcBwTWSNNl8ONl2cjZdkroI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fourie Zhang <fouriezhang@tencent.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 342/457] net: bridge: mdb: restart port group walk after deletion
Date: Wed, 30 Sep 2026 17:27:27 +0200
Message-ID: <20260930152353.397001834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1523,6 +1523,8 @@ static void br_mdb_flush_pgs(struct net_
 		}
 
 		br_multicast_del_pg(mp, p, pp);
+		/* br_multicast_del_pg() can remove other groups from this list. */
+		pp = &mp->ports;
 	}
 }
 


