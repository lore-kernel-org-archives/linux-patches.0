Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F061431A5C;
	Tue, 21 Jul 2026 19:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661909; cv=none; b=SOcLG776BTYO5fHD2hag+BQWs1WZMRunP+CK5hs790npSdmUw60ofmEj+ely1mcOurnDTsvc+Gyskz4Q52Qc0UymZPsN6lJwS+NCdcvMxBb/xllxD6w9TxpEUIVqlUjkXvOu1cB26L9SbJk5AJr8GFoYx6hLU0OcbiAikvtR1nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661909; c=relaxed/simple;
	bh=Jy/IjohM7pYJD32w7yUV/r4GPMddlKRiy+uYvLDuUVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB9gaCQV0iJxM8+Qa1eCPqnko0NI8kPszXkt103CL3JQ/3JlPW/6WEmQsJNLmYzCNqK9ExsIbOWniVDcLXd6Mk4qEsk8qGhskqx4Kjms4e3EvFXQk17LKGPB9eHr9vguWWz8RBdr+TQ2t5T1T5WMGhbmWwdFmeRLLippBqNTSNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaYQsX3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaYQsX3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A291F000E9;
	Tue, 21 Jul 2026 19:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661908;
	bh=bFpwGrYiMIndRAOqtQpy+7DCOCMDqlKR11ORRr3VX9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaYQsX3hFX/qsvLCjKN3mB4/djibbe4EpEIt8/kFstApokIzr1aTapVNKOK/v3TVV
	 DREgykLbt58BlY+IztKAOFSFfeBwS/rlnDESboAUvgeToA14HHcE9yJlrppyHZ7bFt
	 xHmM1hgXSuHR01vzMgQTwOsGI0oDP8uYBBpTu3DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0245/1276] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
Date: Tue, 21 Jul 2026 17:11:28 +0200
Message-ID: <20260721152451.572442578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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



