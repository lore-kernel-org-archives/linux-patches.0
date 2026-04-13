Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83193368B1;
	Mon, 13 Apr 2026 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099445; cv=none; b=eJk5HVweZR1kNXtvB9btw3Xj50+Gz/mR9L+0dTdNIBoFuJVFNpZq6Zt5k7hIPqmLY8yWE7dgGfWwF1BvanYI4lnkaOW0ffpH5G0rc/vqdy9h/q8hwHLvSi+CG28VDwmrLHfsm+FAnD++ISX53gpLbiC0zTEw+yXbPbJxsSq8RC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099445; c=relaxed/simple;
	bh=Ady4x6us+pwohj1gFdXRQNGe8dGIp9RaC/rn1O1tSCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReJSYzRG01Nv8/jzzE3iKekE2bykFFtuNMzfQGsBqr6UNxZKy/w2Xnt1jubhLDJv5w3NI6q42RFHw2vT8XrmarXhdv95UNijd66octnqtIVK+IZf2kybPFubC7AAyYASc4dXL9tQf0NjhrJlI9/MpQGLm082ls8ZoFTaArAB54M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUuRafOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUuRafOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDEAC2BCAF;
	Mon, 13 Apr 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099444;
	bh=Ady4x6us+pwohj1gFdXRQNGe8dGIp9RaC/rn1O1tSCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUuRafOkJ1YZAMBXlvwsomQv2sk1PDWFvNDB4Z2n8z/r2yCoPPdNeL3CO/WxYhi0u
	 rpsNYkp9zk0+fOg4Khpf4h/tiwE+Yov7erYiUIZgmYQ4M1Ue46hzY5PcVuIRJ41CQE
	 aj7m4LUwztgH7YRUWIY3ubv1Wo7fZX0xCZAcIneA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/491] netfilter: x_tables: restrict xt_check_match/xt_check_target extensions for NFPROTO_ARP
Date: Mon, 13 Apr 2026 17:59:47 +0200
Message-ID: <20260413155831.843629847@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3d5d488f11776738deab9da336038add95d342d1 ]

Weiming Shi says:

xt_match and xt_target structs registered with NFPROTO_UNSPEC can be
loaded by any protocol family through nft_compat. When such a
match/target sets .hooks to restrict which hooks it may run on, the
bitmask uses NF_INET_* constants. This is only correct for families
whose hook layout matches NF_INET_*: IPv4, IPv6, INET, and bridge
all share the same five hooks (PRE_ROUTING ... POST_ROUTING).

ARP only has three hooks (IN=0, OUT=1, FORWARD=2) with different
semantics. Because NF_ARP_OUT == 1 == NF_INET_LOCAL_IN, the .hooks
validation silently passes for the wrong reasons, allowing matches to
run on ARP chains where the hook assumptions (e.g. state->in being
set on input hooks) do not hold. This leads to NULL pointer
dereferences; xt_devgroup is one concrete example:

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000044: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000220-0x0000000000000227]
 RIP: 0010:devgroup_mt+0xff/0x350
 Call Trace:
  <TASK>
  nft_match_eval (net/netfilter/nft_compat.c:407)
  nft_do_chain (net/netfilter/nf_tables_core.c:285)
  nft_do_chain_arp (net/netfilter/nft_chain_filter.c:61)
  nf_hook_slow (net/netfilter/core.c:623)
  arp_xmit (net/ipv4/arp.c:666)
  </TASK>
 Kernel panic - not syncing: Fatal exception in interrupt

Fix it by restricting arptables to NFPROTO_ARP extensions only.
Note that arptables-legacy only supports:

- arpt_CLASSIFY
- arpt_mangle
- arpt_MARK

that provide explicit NFPROTO_ARP match/target declarations.

Fixes: 9291747f118d ("netfilter: xtables: add device group match")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/x_tables.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 92e9d4ebc5e8d..94778fae2d91d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -481,6 +481,17 @@ int xt_check_match(struct xt_mtchk_param *par,
 				    par->match->table, par->table);
 		return -EINVAL;
 	}
+
+	/* NFPROTO_UNSPEC implies NF_INET_* hooks which do not overlap with
+	 * NF_ARP_IN,OUT,FORWARD, allow explicit extensions with NFPROTO_ARP
+	 * support.
+	 */
+	if (par->family == NFPROTO_ARP &&
+	    par->match->family != NFPROTO_ARP) {
+		pr_info_ratelimited("%s_tables: %s match: not valid for this family\n",
+				    xt_prefix[par->family], par->match->name);
+		return -EINVAL;
+	}
 	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
 		char used[64], allow[64];
 
@@ -996,6 +1007,18 @@ int xt_check_target(struct xt_tgchk_param *par,
 				    par->target->table, par->table);
 		return -EINVAL;
 	}
+
+	/* NFPROTO_UNSPEC implies NF_INET_* hooks which do not overlap with
+	 * NF_ARP_IN,OUT,FORWARD, allow explicit extensions with NFPROTO_ARP
+	 * support.
+	 */
+	if (par->family == NFPROTO_ARP &&
+	    par->target->family != NFPROTO_ARP) {
+		pr_info_ratelimited("%s_tables: %s target: not valid for this family\n",
+				    xt_prefix[par->family], par->target->name);
+		return -EINVAL;
+	}
+
 	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
 		char used[64], allow[64];
 
-- 
2.53.0



