Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBDB20E026;
	Mon,  2 Jun 2025 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875076; cv=none; b=FyihLOz6vrIEkTPu/tpbMt4P7kdPkad+T9qlxVNJxLFZUW0pWdSU7N+AwO4LLsezB0hOudTmSRtXnI3XZWiytKzdlQtOqqflo0LSbUSY95l3zrr1h+a/t8VANPOxKaJPOc8KzB5AQbFkYIrFuy5GpmchRYDJXGWGHp8mylZ6WLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875076; c=relaxed/simple;
	bh=98eVskZbYuNxuccGyYCC2ykTrSr8xFzuktvy3fMkvws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0lIyBNfPMVIm6I6SIHyL4kF1MkuRcz0Gzk5kR4sgQLzkdVYu/iMvYMG/zmRJQKczAcpKEshsCdqwkpOJqBW/dFZPp0Yxj4Zgad0G3o8/m5SMK3PIuPQzWhDWbjv/yl1ukTQoN/whf7gUjGFrC8k1BR1bYtK96eyctYDxvmce3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILhD93Bi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILhD93Bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913B7C4CEEB;
	Mon,  2 Jun 2025 14:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875076;
	bh=98eVskZbYuNxuccGyYCC2ykTrSr8xFzuktvy3fMkvws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILhD93BicVTfFZUZh0DH84+2rRzoqZdyc78yZPp25MxjUXGnaKInOtvNLD2rDqnTk
	 o8MQBNLA8ZHJVEgmZM4ynOwy518endWwyrKKaNOwWoUxcQ2Aj/+Kg/b0ZeEGSZ5hp5
	 znGaY9dZPWqutAWNq0We3Fa4hSEDPkg/zVNeMJKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/270] net_sched: hfsc: Fix a UAF vulnerability in class with netem as child qdisc
Date: Mon,  2 Jun 2025 15:45:05 +0200
Message-ID: <20250602134308.025163617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aad090fd165b0..adc16643779fb 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1571,7 +1571,7 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 		return err;
 	}
 
-	if (first) {
+	if (first && !cl->cl_nactive) {
 		if (cl->cl_flags & HFSC_RSC)
 			init_ed(cl, len);
 		if (cl->cl_flags & HFSC_FSC)
-- 
2.39.5



