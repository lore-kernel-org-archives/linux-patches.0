Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941C52144C1;
	Wed,  7 May 2025 19:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645019; cv=none; b=BzvQzfVAf68oavTDSpf0eOCHfQ55atsP8SqiCDD6Kez72ilRCrOOiSLKse/qLiZS60ziKGQl+SxoAb6LJNOqqB1KtvUPpesOPgrY80N/uKDzSQLh+OqNRr9fzd6IwqsG5TPmpS5iubTRfiK56+3DZsa921ssCMinXYKzwfqxrTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645019; c=relaxed/simple;
	bh=LOAm3oT3089Y73TaQuLl63N86/3Nprm6+kasIZr+Ll0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fns/UuXWpI2K41HnDm7ws0EuEfmTXnKf23ZCfJT6DVGc3oATNMkHOoHD255Er85C5G2o0PdJzEzYJswJBziHCRnkUjCJoc+Rg0uiCdt+3mItYmAUTVE3qPbU7TGXL7QCmTh4BCQK+BHs7R/D9+tsGa6meOELAVy93E6PJ7vBB2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vb0jl+6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vb0jl+6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FEDC4CEE2;
	Wed,  7 May 2025 19:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645019;
	bh=LOAm3oT3089Y73TaQuLl63N86/3Nprm6+kasIZr+Ll0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vb0jl+6DaQVk+21poO8aH8dnnOq64y7nleZpNuU8BiRNB/F1J2u/cVL5WfulnDJxh
	 z7JAH97CrWUsHjIW4J/aW/Esa+oi2OpyIahZzvNMVdMdWv2gk40E7wvCKGaO51+8DZ
	 7/vYDx861u8tX00z6/DkiSkOGI4MrSIXBcKEfRiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/129] net_sched: hfsc: Fix a UAF vulnerability in class with netem as child qdisc
Date: Wed,  7 May 2025 20:40:05 +0200
Message-ID: <20250507183816.318007866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 141d34391abbb315d68556b7c67ad97885407547 ]

As described in Gerrard's report [1], we have a UAF case when an hfsc class
has a netem child qdisc. The crux of the issue is that hfsc is assuming
that checking for cl->qdisc->q.qlen == 0 guarantees that it hasn't inserted
the class in the vttree or eltree (which is not true for the netem
duplicate case).

This patch checks the n_active class variable to make sure that the code
won't insert the class in the vttree or eltree twice, catering for the
reentrant case.

[1] https://lore.kernel.org/netdev/CAHcdcOm+03OD2j6R0=YHKqmy=VgJ8xEOKuP6c7mSgnp-TEJJbw@mail.gmail.com/

Fixes: 37d9cf1a3ce3 ("sched: Fix detection of empty queues in child qdiscs")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20250425220710.3964791-3-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 371255e624332..4be8760b8bc3c 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1566,7 +1566,7 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 		return err;
 	}
 
-	if (first) {
+	if (first && !cl->cl_nactive) {
 		if (cl->cl_flags & HFSC_RSC)
 			init_ed(cl, len);
 		if (cl->cl_flags & HFSC_FSC)
-- 
2.39.5



