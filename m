Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330C743B490;
	Tue, 21 Jul 2026 22:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674335; cv=none; b=oKWBnWQvQKGzKmY3+RoHh4gjvia9tg7j2HStZSiEsOOeGJbSPFM+AiOCqp4rUhKvu+j4Hx/vjVyGVYUqse+bA2KNgx8M+PI4zyqgV0/mde2uNLLXXsY8gfWafDI70LLpVdkovwYugnr3iHbaFtdlYWRdCF+nLgsHAB1sNDluSfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674335; c=relaxed/simple;
	bh=tIozFqlSHKmPx+OcxiI2ynfwaaM0sJGJlF5zhZumxNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imPCLWnLUlYpYuEz0ntncLE6Ja7Tqq5l7fK+ee6YbbfhsHvIf/JS6STorktV9eZCO/z6Oqbo2aekyno2o++mQ5G6NTVmBnldSm0k4tI07405Cx4bATUhadDXJLFbEQ026Hxx9O3/g1XjbiwcHcNX4oOe9sZNAYJHVDyzr9Ag6iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlolr5mm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlolr5mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DCD1F000E9;
	Tue, 21 Jul 2026 22:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674334;
	bh=PGqq+InuYnawALcKjnVoOsj0TrI/QWPiGXRGwYBmu8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlolr5mmg0CklHowrhJ6Hhxkn/LolntoMXMJulnLvbSk3gKjK+aWdTR8p7gnAX+UX
	 qwSzOi/LllUEln1gc2OMAt0xfq0ypDnrc1bAOnxJ3JuVgvXNrWc5okzyye3J+Z3f1V
	 pduxo9ZD7BSxV3/x/fGEJlbS8NcRKrs0wbebWkTg=
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
Subject: [PATCH 5.10 449/699] netfilter: nf_conncount: fix zone comparison in tuple dedup
Date: Tue, 21 Jul 2026 17:23:28 +0200
Message-ID: <20260721152405.827915876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


