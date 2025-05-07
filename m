Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808C52144BF;
	Wed,  7 May 2025 19:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644684; cv=none; b=ssp5qB+qMqrI4pABzrQIlYzXqE4rallQyf/WcWkPZ55aqCL6YIliBf6pZLnqWCojoojoyEPCZ2kExveqvVP0kvdvhaDsDiMTk0SeoF4WXS1zr0teo1jcxtGgP7uBJT8lzAkX8ii15rSmLptTD60lb+QWbT0Aixpx2EH8X6N7JQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644684; c=relaxed/simple;
	bh=RsB+zi3NO07NntiSg4reANZZPQx3uSJ+g8rQGSZBeXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1o7SXkV3FRaWeNcc2OLCw5PP3LWneCrsWMc+yvxYXQhbGMZ8FdPtRCPEfHk9GGpj30xZnsx+9wdol9b5odIZ3XLuTp1XvvRtU7PiBzvlq1oJ+VhnJCgKVQ6GKT4L/UVSUxR0uifex2DAtki9kTseayIDZYUAqTMqF8rJv5Cg/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tC+x2LcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tC+x2LcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3785C4CEE2;
	Wed,  7 May 2025 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644684;
	bh=RsB+zi3NO07NntiSg4reANZZPQx3uSJ+g8rQGSZBeXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC+x2LcAlH3kbY4w4SrrRmUSdkGtqnJK1B/dv0+ul5WlFIdl8fsIX4jDsM7bu1QD3
	 JgmOhGm/s07sw+DzKNH1VFxuUSY1QjgdtjY5LGCEyKh0zdrsuClZZ9y4BteMyLcxvx
	 WXh1QMTS9G720xbG/jyAeA3WKvpAautqvlq+pyKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/164] net_sched: hfsc: Fix a UAF vulnerability in class with netem as child qdisc
Date: Wed,  7 May 2025 20:39:37 +0200
Message-ID: <20250507183824.689768851@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5bb4ab9941d6e..1c857dc95e4f3 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1565,7 +1565,7 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 		return err;
 	}
 
-	if (first) {
+	if (first && !cl->cl_nactive) {
 		if (cl->cl_flags & HFSC_RSC)
 			init_ed(cl, len);
 		if (cl->cl_flags & HFSC_FSC)
-- 
2.39.5



