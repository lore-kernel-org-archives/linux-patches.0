Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424C92D3725;
	Wed,  4 Feb 2026 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217474; cv=none; b=AekIyscjnUmjPLhnY/G5++WoxPvblb61u6iz8B12KPxVA/+gY6+kyMA89M7rmUQQeBSROig2LYmMJ/0RQ5dRCIw8EQDNBqz0Gqnvi6cKnI45H4CxtTI+xCa32ZlcbCmcHb6qJm6/aCGaO52XzONrDN/sf2OX4ZlKTXMxxkpdTp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217474; c=relaxed/simple;
	bh=1btNxiqO0gpGdyD3ZaCBkG9Gq/oGtPRkLtSjpWkrXBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsvXEvUhPGtxkYGKOmFdTZrey93CWElMyMc/IRIG0qK2G2QKxiGSgbxfHJ2PSsylnxceCoPHaoUAFQuJIVto3kQMrjmi7g8eLh8YC8Gi7PlKZZ6Rl2a1pSx+8HJwVAYxGG5TcdzBl/um95rzBDwkHuq6dCNyxh++C+TYJPs1sZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L72lZiAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L72lZiAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DD3C4CEF7;
	Wed,  4 Feb 2026 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217474;
	bh=1btNxiqO0gpGdyD3ZaCBkG9Gq/oGtPRkLtSjpWkrXBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L72lZiABM+AUWnlWWb2ECreDJqsn7+hKJD1YdsfKO/TiNG6jl6BhG6PAxKSIe8nfq
	 dX+2QyqB5uWrg/V2xH7ChzjdjhixZiTkUlVg0v9Vfhgp7fru4wIvRoUZAHAW7+RAIB
	 8BIL01jdvsAO3TlFrti3x8uGQrouN1CqcYiyxwTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+07f3f38f723c335f106d@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/280] net/sched: sch_qfq: do not free existing class in qfq_change_class()
Date: Wed,  4 Feb 2026 15:36:40 +0100
Message-ID: <20260204143910.575822527@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3879cffd9d07aa0377c4b8835c4f64b4fb24ac78 ]

Fixes qfq_change_class() error case.

cl->qdisc and cl should only be freed if a new class and qdisc
were allocated, or we risk various UAF.

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Reported-by: syzbot+07f3f38f723c335f106d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6965351d.050a0220.eaf7.00c5.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260112175656.17605-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 80a7173843b90..0047f35504348 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -533,8 +533,10 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	return 0;
 
 destroy_class:
-	qdisc_put(cl->qdisc);
-	kfree(cl);
+	if (!existing) {
+		qdisc_put(cl->qdisc);
+		kfree(cl);
+	}
 	return err;
 }
 
-- 
2.51.0



