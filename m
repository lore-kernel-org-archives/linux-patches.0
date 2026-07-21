Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7593401A29;
	Tue, 21 Jul 2026 17:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654323; cv=none; b=e2Lh/Pd2gLnXruQSDFo308brarxBOs/qeeuTAjRx8MJIVaI5/OBbI7Cux71HsB+6cgBFS8CfS2FcTYlQwNxoahVoJEyAMJfWDK/uSx4umZl1iosPyLK6zqyMafoIkc5+0468VUhyA/NilHfKJp6rrZLIZHe3nSMIDrwlbb1a3t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654323; c=relaxed/simple;
	bh=+1pvZZdmabvxagnDn1aOBb85WUa9pg8x4iY97PeQSr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdc8OyZRZpmFlhSrfowS4TylBfaPulxYAPddWvDVga9fSqkj4SpNyDrXvC10hEhOrCODo2Ul5BfsV1iGAJCCuwkSAGKuuZHtArSjzL5GKFSviJs6bSnDTM62oCEDIiK9UMy6Va+xOe0nzoLgLCKelUlnlZVUz/3YdGyNRrHj1J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFmqb/JI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFmqb/JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB5E1F000E9;
	Tue, 21 Jul 2026 17:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654322;
	bh=expeNyuLfvYnlTlqQgU8+ge0YR5FlwXyNe6J8nFhG6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFmqb/JIAEBB2ybta8wfXhLHDh8Fu5P7rWRLApbYjJHdgfaRgoxdhZF3QEKnycFR4
	 DSZz+rPW7j3Ss6eFE4Pgj5hHVla/LKTro0SiTRDGnwlEtLcLI2FDgg+epj+8WohqmC
	 Wwj7dG0SChwyGLnEr+euJyMI7u79/RufoJbzab9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1617/2077] netfilter: flowtable: use correct direction to set up tunnel route
Date: Tue, 21 Jul 2026 17:21:30 +0200
Message-ID: <20260721152630.901679619@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 90941d9c925d66a482c9121919ec3546a6988c16 upstream.

The layer 2 encapsulation and layer 3 tunnel information in the xmit
path is taken from the other tuple, because the tunnel information that
is included in the tuple for hashtable lookups is also used to perform
the egress encapsulation in the transmit path.

This patch uses the correct direction when setting up the tunnel, the
original proposed patch to address this fix uses the reversed direction.

While at it, remove the redundant check to call dst_release() to drop
the reference on the dst that was obtained from the forward path, which
is not useful in the direct xmit path unless tunneling is performed.

Fixes: fa7395c02d95 ("netfilter: flowtable: support IPIP tunnel with direct xmit")
Cc: stable@vger.kernel.org
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_flow_table_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,18 +127,18 @@ static int flow_offload_fill_route(struc
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		if (flow_tuple->tun_num) {
+		if (route->tuple[!dir].in.num_tuns) {
 			flow_tuple->dst_cache = dst;
 			flow_tuple->dst_cookie =
 				flow_offload_dst_cookie(flow_tuple);
+		} else {
+			dst_release(dst);
 		}
 		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
 		       ETH_ALEN);
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
-		if (!flow_tuple->tun_num)
-			dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:


