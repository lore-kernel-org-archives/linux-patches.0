Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE104F68A4;
	Tue, 13 Oct 2026 12:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896101; cv=none; b=R7bZWSM7Vy9U0fJ3S+XvHjzsHaqMkTHA86B4XzDS2PSQL+4HvHKllgE22QYlt284wIybJBVbb2pnFFA+cqXRQ3tU6kdYniJwZon84LjTkVlko7KLHZOrNVsYRSy7gB0IC20cVpTE2ckIDyGo+R8BpcGr3QLbWwJhat5rqbWGXOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896101; c=relaxed/simple;
	bh=9GDOfQojLgyi3MFN64Kjaq6BoKRG4dpUCeLbjsrO4oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSF4tyEUuWDyoLJpbun4tQQgSR3HHq4pHnUKSc/88GN012tQXSvJ0UZXYgVS3/LGZ0SsRjELcSNyXntqXL+CdWZx5HfZOLBRQgrLR6rfwkrmJ/Mm1L5q15rJN7Q7wwqVQVT6OVdqmUVWYW9nhC7qHNTg6iHggBgf6oblPKm3YQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjj1MTFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjj1MTFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756651F000FF;
	Tue, 13 Oct 2026 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896099;
	bh=YEbyMKnjg0aLzvfsTb1PnmOkw5/p0ENQfXWCZmWvWIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjj1MTFkgxjNgJjuITTAn9fycWNXH6xac1SbYVwc1/ipfmc7NU0PrnyYSFjXEJkHI
	 EN9UWjuhpV0i/ti3LRGicbaYMApwDgw2h64G+WX/ZRKuxdg00hxFPcFr5ZNeJ6MvuR
	 43lDcf659gfbzZA5otIzobDPLeyZ3kNQLNBsZc+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 496/497] netfilter: conntrack: fix erronous removal of offload bit
Date: Tue, 13 Oct 2026 13:41:03 +0200
Message-ID: <20261013112919.648549970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit d2d31ea8cd80b9830cdab624e94f9d41178fc99d upstream.

The blamed commit exposes a possible issue with flow_offload_teardown():
We might remove the offload bit of a conntrack entry that has been
offloaded again.

1. conntrack entry c1 is offloaded via flow f1 (f1->ct == c1).
2. f1 times out and is pushed back to slowpath, c1 offload bit is
   removed.  Due to bug, f1 is not unlinked from rhashtable right away.
3. a new packet arrives for the flow and re-offload is triggered, i.e.
   f2->ct == c1.  This is because lookup in flowtable skip entries with
   teardown bit set.
4. Next flowtable gc cycle finds f1 again
5. flow_offload_teardown() is called again for f1 and c1 offload bit is
   removed again, even though we have f2 referencing the same entry.

This is harmless, but clearly not correct.
Fix the bug that exposes this: set 'teardown = true' to have the gc
callback unlink the flowtable entry from the table right away instead of
the unintentional defer to the next round.

Also prevent flow_offload_teardown() from fixing up the ct state more than
once: We could also be called from the data path or a notifier, not only
from the flowtable gc callback.

NF_FLOW_TEARDOWN can never be unset, so we can use it as synchronization
point: if we observe did not see a 0 -> 1 transition, then another CPU
is already doing the ct state fixups for us.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_flow_table_core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -351,8 +351,8 @@ static void flow_offload_del(struct nf_f
 void flow_offload_teardown(struct flow_offload *flow)
 {
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow->ct);
+	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		flow_offload_fixup_ct(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -531,10 +531,12 @@ static void nf_flow_offload_gc_step(stru
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
-	    nf_flow_custom_gc(flow_table, flow))
+	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
-	else if (!teardown)
+		teardown = true;
+	} else if (!teardown) {
 		nf_flow_table_extend_ct_timeout(flow->ct);
+	}
 
 	if (teardown) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {


