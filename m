Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BE3374E6C;
	Tue, 21 Jul 2026 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656324; cv=none; b=jSnXDeCEjcMJbHFa4BUbq/WmL+sDAmjwlm3qyID9ov5Wwrg5NcGuugx/c8q+8U/k1Ge0+7R1Scr1zdH8vk1ciDTjC3YDano29IMRIjw9pIm+jM4hxhvKFbwHKMnNCql74Z2n5hjb846Rt8eE6Rde2XFSAj+J9AeIfEFnAdTXLBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656324; c=relaxed/simple;
	bh=dxIxRuOxboVLj50Fj9k+g0AymCDhGV7JVoc59Ijwdgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/hyYu1EADuADKgDRyPZgChwkBHapKrhZw3TF3UV8wFC9Fo7H9wrmXI6clVelAdaHcsypm+lx+lL+iEaTAyozkY3j9DO61Bxr1+8Nnr+z4Is0lFl8e8p/pG9gGx58hILQEAVx1gFdjZlLK5OrMGMvlSTeOxq9sRorRiAi9SED38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sV2TAhr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sV2TAhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9F91F000E9;
	Tue, 21 Jul 2026 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656323;
	bh=BXaotb5lD2BmbJjgUyY5w/UlaMHtWaYBCcIeIUb8iAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sV2TAhr9Ta4dopQzprbmI87o8rMZ9OGjiDmJjuMRkdNF1a1N2Qu1dfNc8Q6VW9s+
	 QuRdZOsCxklpM0RZCkr4cXNmcoKUNQ12p+QkTEPUwW3VeFGNu0xFq4F/AEpg+x8G46
	 a79uPhI7rzfu/Fr6CE+SHCbG8x+orJCpzyNbXRoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0345/1611] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
Date: Tue, 21 Jul 2026 17:07:41 +0200
Message-ID: <20260721152522.885335779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 9e37388b8070afe73d4ab2d973b28593ed65f3ad ]

nf_ct_seqadj_init() is called without holding the ct lock. This can race
with nf_ct_seq_adjust() when a connection is in CLOSE state due to an
RST or connection reopening. In addition for SYN_RECV state, concurrent
processing of packets can trigger nf_ct_seq_adjust() too. These
situations create a read/write data race.

As synproxy is the only user of nf_ct_seqadj_init() at the moment, fix
this by holding ct->lock inside nf_ct_seqadj_init() until all is done.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_seqadj.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 7ab2b25b57bcc0..b7e99f34dfce86 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -17,12 +17,14 @@ int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	if (off == 0)
 		return 0;
 
+	spin_lock_bh(&ct->lock);
 	set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
 
 	seqadj = nfct_seqadj(ct);
 	this_way = &seqadj->seq[dir];
 	this_way->offset_before	 = off;
 	this_way->offset_after	 = off;
+	spin_unlock_bh(&ct->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
-- 
2.53.0



