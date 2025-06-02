Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF0F22259B;
	Mon,  2 Jun 2025 14:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874499; cv=none; b=swP84LoZfb9tNFJOsVB+utViG86zXWvo5u7KXoIx/uR9fo/fYkhjNftIitkKueN45H0pc6ltlFtuhMs/s/DVgFomMJ/o2NAwQvi/p4Pz8udlvAPX00V2bO6/c594R2bNzqQsybuPV4NAHLrR/skmAkulM+cJt2lMrzAhOzMHUSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874499; c=relaxed/simple;
	bh=FgSHl9GFibSVUmQ7cc96r6+jinGzY4qB2HZFFkp7hlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjmhSvTJw3GmZClTEfx5+et0pzGuu2pZ4iu7hiANMAbmTSYV9aHIZYTHvL0TD27JMmdF2UVqiHEEIUrGOLrNjhpGNflx9CVDFHCDx4aTqqVU7vxqnBSlDtSwH/7YwZ7p0QUq70blWRjSdUijqwUEMGK6csand2phLslWqxznlQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx5JE2Rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx5JE2Rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB96DC4CEF0;
	Mon,  2 Jun 2025 14:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874499;
	bh=FgSHl9GFibSVUmQ7cc96r6+jinGzY4qB2HZFFkp7hlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xx5JE2Rg/NOXsudyb1nDE+G1AEDbdacjKdIqjqB4r+ORJSGtO3puR6KAE8Klgf8Dd
	 LQ016O3BJfyswFLh6VAE+CFriEWkVeZ9EdFZr0xQyaStZ3qo7+KK/B98Qnf2SHgiv0
	 8Xe5XaHlDndxdWQVPVApJtN4Jsvk3LDP2QHU5HB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/204] net_sched: hfsc: Fix a UAF vulnerability in class with netem as child qdisc
Date: Mon,  2 Jun 2025 15:45:45 +0200
Message-ID: <20250602134255.970665884@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 79c63c4610d3a..5d73d02b8dce7 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1573,7 +1573,7 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 		return err;
 	}
 
-	if (first) {
+	if (first && !cl->cl_nactive) {
 		if (cl->cl_flags & HFSC_RSC)
 			init_ed(cl, len);
 		if (cl->cl_flags & HFSC_FSC)
-- 
2.39.5



