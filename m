Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B624335C68B;
	Tue, 21 Jul 2026 22:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671588; cv=none; b=lxaMbVUOjVyTg9tlViE2/FhcPR671LwhkGL4W2Be/E7kMqsRPSNFs+O5lDOGR1FizZbw14OUXPZv/l/uMhHpqyV+ArmJFn6S07jJc8d25V64E8FhcaZK9QtH/SX/iu/ueLGnQjTQgc7rcgdW1pI2NpZcdmyQhsY3hhcA7ADlz70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671588; c=relaxed/simple;
	bh=6Eyv9w3UI3woYAs+MhU3xnw2yKlO7cGlrVid59UNG+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=um5dHXu5zYgCSGOxRXc/smqIhrRsx5BK0Su7xQFMb0GjIauLGitWmeR2XNujBwLanjmpkSeAA99g0CNUCcVQzUvv8l+Fle4CLKKgncdISKEjhk0HtZaMH4qh/lSFoJlgmkwoepU+n1HugK5e8Y2BgMJH+q/aQePbjgHrExPLJts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRjoVjEA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRjoVjEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC431F000E9;
	Tue, 21 Jul 2026 22:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671587;
	bh=FzTooLLQlM7SxPHlM7NbOoirL089T5xOL7PiA4P9yCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRjoVjEA0z2yWsV7636Rg2kmAACmh+7HGO9HbjSZurMjgzJVkJiUuG5E9FY1CMOaP
	 UF6OKDDd+PdzaF2pG+ntr/+mxG1IQc0ReaM33e3mEECRsbRClEhqXhvhh7W/XJKB9a
	 qVtjJMIDGNOLxrfEOwTtXrADo2VgqMmzjP1PR7/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/843] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
Date: Tue, 21 Jul 2026 17:18:57 +0200
Message-ID: <20260721152412.820763849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3066449f8bd8a3..bcb4adf9879dcf 100644
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



