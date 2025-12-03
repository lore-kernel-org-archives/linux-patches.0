Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A71345CD8;
	Wed,  3 Dec 2025 16:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780863; cv=none; b=HjPIPa2mgM/+3eejlb7yhtOAlnCk5mTtgReVrtgLt7H+lPnCCrglFIa12dkwzO9yMrlYo4PIy5ZfkRrnKwe46LN4qISq1vGzHu3NRLrBh3+nGrqWM6vjYBBPp15bCNu+Z4waS92GARmHJ+Hn3gqdrYopsi5CSyTBspw7jCV3KKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780863; c=relaxed/simple;
	bh=oTG3hJ/sp8YtwaHfqJnyFF6eSHoHurzi3sL6EsDH/Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd2G6JiY1TTAU78htefA8GrEuTcLyk+dD3okO/ypk2/0chgTAt6nlUoTPyqx9x2VClj8XsMN2GKlYDgcREaNqpvHR7GWQwhqRv93reLzLulZrxdbuKbjyB7riBv02F3J+Wzp0ZknHOoH1ED5WQt83Ft//llcryxHse/wZFk808g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKV65iXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKV65iXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F12FC4CEF5;
	Wed,  3 Dec 2025 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780862;
	bh=oTG3hJ/sp8YtwaHfqJnyFF6eSHoHurzi3sL6EsDH/Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKV65iXS2C4m+iFBSo1uTNThcymiC27tvylBAluiYakpMLDDQhLtFtzPKYAMFpJ3/
	 6PSMPshWrmN/KwCWWViM1BesBqU6xF63e12zVQwBicuo//B+AY7PwCO8mikfvRtg68
	 WgMbopCZiEW4hSNldzuGJXfRAik+zoiCgdu6YMWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 113/132] libceph: replace BUG_ON with bounds check for map->max_osd
Date: Wed,  3 Dec 2025 16:29:52 +0100
Message-ID: <20251203152347.467591027@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: ziming zhang <ezrakiez@gmail.com>

commit ec3797f043756a94ea2d0f106022e14ac4946c02 upstream.

OSD indexes come from untrusted network packets. Boundary checks are
added to validate these against map->max_osd.

[ idryomov: drop BUG_ON in ceph_get_primary_affinity(), minor cosmetic
  edits ]

Cc: stable@vger.kernel.org
Signed-off-by: ziming zhang <ezrakiez@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1504,8 +1504,6 @@ static int decode_new_primary_temp(void
 
 u32 ceph_get_primary_affinity(struct ceph_osdmap *map, int osd)
 {
-	BUG_ON(osd >= map->max_osd);
-
 	if (!map->osd_primary_affinity)
 		return CEPH_OSD_DEFAULT_PRIMARY_AFFINITY;
 
@@ -1514,8 +1512,6 @@ u32 ceph_get_primary_affinity(struct cep
 
 static int set_primary_affinity(struct ceph_osdmap *map, int osd, u32 aff)
 {
-	BUG_ON(osd >= map->max_osd);
-
 	if (!map->osd_primary_affinity) {
 		int i;
 
@@ -1577,6 +1573,8 @@ static int decode_new_primary_affinity(v
 
 		ceph_decode_32_safe(p, end, osd, e_inval);
 		ceph_decode_32_safe(p, end, aff, e_inval);
+		if (osd >= map->max_osd)
+			goto e_inval;
 
 		ret = set_primary_affinity(map, osd, aff);
 		if (ret)
@@ -1879,7 +1877,9 @@ static int decode_new_up_state_weight(vo
 		ceph_decode_need(p, end, 2*sizeof(u32), e_inval);
 		osd = ceph_decode_32(p);
 		w = ceph_decode_32(p);
-		BUG_ON(osd >= map->max_osd);
+		if (osd >= map->max_osd)
+			goto e_inval;
+
 		osdmap_info(map, "osd%d weight 0x%x %s\n", osd, w,
 			    w == CEPH_OSD_IN ? "(in)" :
 			    (w == CEPH_OSD_OUT ? "(out)" : ""));
@@ -1905,13 +1905,15 @@ static int decode_new_up_state_weight(vo
 		u32 xorstate;
 
 		osd = ceph_decode_32(p);
+		if (osd >= map->max_osd)
+			goto e_inval;
+
 		if (struct_v >= 5)
 			xorstate = ceph_decode_32(p);
 		else
 			xorstate = ceph_decode_8(p);
 		if (xorstate == 0)
 			xorstate = CEPH_OSD_UP;
-		BUG_ON(osd >= map->max_osd);
 		if ((map->osd_state[osd] & CEPH_OSD_UP) &&
 		    (xorstate & CEPH_OSD_UP))
 			osdmap_info(map, "osd%d down\n", osd);
@@ -1937,7 +1939,9 @@ static int decode_new_up_state_weight(vo
 		struct ceph_entity_addr addr;
 
 		osd = ceph_decode_32(p);
-		BUG_ON(osd >= map->max_osd);
+		if (osd >= map->max_osd)
+			goto e_inval;
+
 		if (struct_v >= 7)
 			ret = ceph_decode_entity_addrvec(p, end, msgr2, &addr);
 		else


