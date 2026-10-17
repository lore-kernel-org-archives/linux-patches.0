Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5B03A6B65;
	Sat, 17 Oct 2026 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257435; cv=none; b=DZmaCsbPpH0VY+hiHwhj5iD41UkqKCv42lvsHCgHeY+HMbH2GiorjYT0DZbNKM38dPNOnZOXbjsnLtvfGyarYKrD9gFtMyqkehG0z2+4R+e0m29Q22y2oGU32HXVQU6dhNZthnAHRknREoT9R0dIVv3Mv8DudR60RQJAuXCy6KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257435; c=relaxed/simple;
	bh=GONEyYOL+HqwbwXX6zINSDaQKV/UI2J7iJz5qAONwcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdNuA+wSuth2/w2cB+4xIr6jK9S3lNj1KWzed3TGTWdzSGcUmRmgyQOjPYD8s5ZN6nQVPrvbQ0+SOvTXRIUUUQVkd9tQNjZ3iEFoeER8rE/YOFPiTh+WTuEC6R8SUFsOIV6+KRZRt/bi9RAVxKD+BhDcsQVO4FDrNMzqpEqEXhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnFgtHas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnFgtHas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FBC1F000C5;
	Sat, 17 Oct 2026 17:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257434;
	bh=dOi9SqvNzulh4aeQamZ4MwUdOJwK7As3ME6xAL3CrVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnFgtHas8oIdnkHA4vJr1kT+muzibGXYLiJxqpcEeNXUet7J2mLjPxsaJrLrfXp2/
	 JZKk9yia8PA/Xctv0k1EBjBIsu4e8ZhfIeX+JwwXPANGMGPi+hEVN87VVj985haaR4
	 BnibW2wOTLtxBJsd3f9N3OhQihLhH67K44XSEMIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 0557/1674] netfilter: conntrack: fix erronous removal of offload bit
Date: Sat, 17 Oct 2026 17:47:09 +0200
Message-ID: <20261017160445.393599462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


