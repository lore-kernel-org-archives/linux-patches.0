Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7998442FDA;
	Thu, 20 Aug 2026 17:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247884; cv=none; b=dNL6OvopudsCWV0aa8yTHGWYhOrFzT1Oc+OS0aMoPJWahe4qfaLoicvFgRPG8eDYZEc1Awyi6gBuCszXMwxwV95M0Cl0Dmv/+ehEyXSol2Ba+Y1yy6239bGMq8YN91epIn4uNHCFiNvHDA5gzfYw+xeyB4Wk/7iUUhRgnUav3jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247884; c=relaxed/simple;
	bh=UjurXePB54y08fgmZbVcnWP0y3RR7B0rQTebmkeKp5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnJSSW5Zqmtb/lrEcYcoUzn2miR4GHHuKrDjjn7P/cE/KsRqCEZMr9XYUxfIuKMQrSupZBQqJWDAtc28Sx0NtLEjLDxJgMPcgp7kccGHMacw451mPlGSNgVZveBnPCG9k/ZRREfNKzcR50gDtTy5s1G1t7bMjRdfLqApJjxFcWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SH14jcPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SH14jcPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEE61F000E9;
	Thu, 20 Aug 2026 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247883;
	bh=Gs97XhMn/iZvoZ8uYo+1PRFnrFEgL1uPfmpqQGqBIGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SH14jcPg7l1+UvFhceiWwGm91pNkKK7zvcSebJNOG4+0sRwnza26Vq2+fckT3xvxA
	 a3AIsuP0JgmWf25o5ra8d2kR846nRV5s0o0XGH35uxy49I83iHQSt8itbdssfcj4Jk
	 NMmaAyKVcCEUVdjHWay0TcK00P3Sig2uc8ts2Cfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 036/303] libceph: Avoid using invalid osd indices from primary_temp
Date: Thu, 20 Aug 2026 16:52:52 +0200
Message-ID: <20260820145254.272631894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 3660b98d1204b419f6a77e9a295f148dcf38d042 upstream.

A corrupted osdmap received from a Ceph monitor or OSD may contain osd
indices in its pg_temp, primary_temp, pg_upmap, and pg_upmap_items parts
that don't exist, i.e., that are greater than max_osd or smaller than
CEPH_HOMELESS_OSD (-1). These indices are used to create the up and
acting set in ceph_pg_to_up_acting_osds(), called from calc_target().
While most of these osd indices are checked, the one from primary_temp
is not. Subsequently, this may lead to calc_target() returning this
(potentially invalid) index as target osd for a (linger) request.
Because the osd_state, osd_weight, and osd_addr arrays only contain
max_osd entries (with indices 0 to max_osd -1), this leads to
out-of-bounds accesses when trying to read values from these arrays.

This patch fixes the issue by adding a check to get_temp_osds(), so that
only valid osd indices from primary_temp are used, and it falls back to
using the primary from pg_temp or the up set if it is invalid.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Fixes: 5e8d4d36bf23 ("libceph: add support for primary_temp mappings")
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -2811,9 +2811,10 @@ static void get_temp_osds(struct ceph_os
 		}
 	}
 
-	/* primary_temp? */
+	/* primary_temp? (shouldn't ever be a nonexistent or down OSD) */
 	pg = lookup_pg_mapping(&osdmap->primary_temp, pgid);
-	if (pg)
+	if (pg && !WARN_ON_ONCE(ceph_osd_is_down(osdmap,
+						 pg->primary_temp.osd)))
 		temp->primary = pg->primary_temp.osd;
 }
 


