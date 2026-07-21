Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF054028FB;
	Tue, 21 Jul 2026 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654340; cv=none; b=k9ltrRi6gV2OS7dh+YeOJ4NX8190pzkgeVmBGMncURdFe3uZHaUv5XseUZOmjlmUapqKd7toWUh5m6paSH/gKTDLP8Aa7kGr6SDgMLAfzraPjGp/4nQKeLrVFOEK9/pMTzF3HF0JHVKRWKn8uBVkpjg4UZjb4RQsM4k41N16qfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654340; c=relaxed/simple;
	bh=8yTUexVzkUBcZ91so5lFqR4ahf2o6bKOJbbPbt0B0sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+gHEAkDNfEN19qtq6kGBfoNsJNBY2YgaMGd6c0jhkh+62MpD1/VUXnls3YWNbadGUrAVyJqCaot6gofBw+kwrWB3w+iKaC/vNRtKV+gTnwJGsY4Kz+Smloq0aiaO2YLjUOzH8PLUaI3n/wyZ4lvoPn//qJ3TVRJzBU6bb0tNHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0rkVyC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0rkVyC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EC11F00A3E;
	Tue, 21 Jul 2026 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654335;
	bh=o6y0IXs0+8iEtmrFGYt/FyO9i/XZ9tLaOmw03FvidzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0rkVyC3vD6t+C1GVRuPR1OYzMPDJyZV0xsftWV98DHr03pUdGKoXMT3Hw6KxfVak
	 bPHHjDASo/vnOIFvm/yOLtwkz+I11I1hKdRcJglcBHGy0etOT6zN0wgLFjUvDs/PVC
	 UGkTCj/cMuGFFFkdtmf5lUEQSgy46b3pF0M25vRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1612/2077] netfilter: nf_conncount: fix zone comparison in tuple dedup
Date: Tue, 21 Jul 2026 17:21:25 +0200
Message-ID: <20260721152630.786141785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit f62c41b4910e65da396ec9a8c40c1fe7fe82e449 upstream.

The "already exists" dedup logic in __nf_conncount_add() decides
whether a connection has already been counted and can be skipped instead
of incrementing the connlimit count.  It compares the conntrack zone of a
list entry with the zone of the connection being added using
nf_ct_zone_id() and nf_ct_zone_equal(), passing conn->zone.dir or
zone->dir as the direction argument.

Those helpers take enum ip_conntrack_dir values: IP_CT_DIR_ORIGINAL is 0
and IP_CT_DIR_REPLY is 1.  However, zone->dir is a u8 bitmask:
NF_CT_ZONE_DIR_ORIG is 1, NF_CT_ZONE_DIR_REPL is 2 and
NF_CT_DEFAULT_ZONE_DIR is 3.  Passing that bitmask as the enum direction
shifts the meaning of every non-zero value.  An ORIG-only zone passes 1
and is tested as REPLY, while REPL-only and default zones pass 2 or 3 and
test bits beyond the valid direction range.  In those cases
nf_ct_zone_id() can fall back to NF_CT_DEFAULT_ZONE_ID instead of using
the real zone id, so different zones can be treated as equal and dedup
collapses to tuple equality alone.

nf_conncount stores and compares the original-direction tuple for a
connection.  If an skb already has an attached conntrack entry,
get_ct_or_tuple_from_skb() explicitly copies
ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, regardless of the packet's
ctinfo.  Therefore the zone comparison in the tuple dedup path must use
IP_CT_DIR_ORIGINAL as well; the zone direction bitmask describes where a
zone id applies, not which direction this conncount tuple represents.

Fix the two dedup comparisons by passing IP_CT_DIR_ORIGINAL directly.
Do not special-case NF_CT_DEFAULT_ZONE_DIR and do not compare raw zone
ids: using the existing helpers with IP_CT_DIR_ORIGINAL preserves the
direction-aware NF_CT_DEFAULT_ZONE_ID fallback.  A default bidirectional
zone contains the ORIG bit, so it naturally returns the real zone id;
reply-only zones continue to fall back for original-direction tuple
comparisons.

Fixes: 21ba8847f857 ("netfilter: nf_conncount: Fix garbage collection with zones")
Fixes: b36e4523d4d5 ("netfilter: nf_conncount: fix garbage collection confirm race")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conncount.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -207,8 +207,8 @@ check_connections:
 			/* Not found, but might be about to be confirmed */
 			if (PTR_ERR(found) == -EAGAIN) {
 				if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
-				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
-				    nf_ct_zone_id(zone, zone->dir))
+				    nf_ct_zone_id(&conn->zone, IP_CT_DIR_ORIGINAL) ==
+				    nf_ct_zone_id(zone, IP_CT_DIR_ORIGINAL))
 					goto out_put; /* already exists */
 			} else {
 				collect++;
@@ -219,7 +219,7 @@ check_connections:
 		found_ct = nf_ct_tuplehash_to_ctrack(found);
 
 		if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
-		    nf_ct_zone_equal(found_ct, zone, zone->dir)) {
+		    nf_ct_zone_equal(found_ct, zone, IP_CT_DIR_ORIGINAL)) {
 			/*
 			 * We should not see tuples twice unless someone hooks
 			 * this into a table without "-p tcp --syn".


