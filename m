Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48BF1474CC;
	Tue, 21 Jul 2026 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659265; cv=none; b=IXXTuB27f+jpWQNPHDsvqkXDH56i5d2VEwo8Y7xd8qrvbjZBevXw2p+Q9uR0zFByNok1iYQwrvVw1q1T3cooJ1axDGQvbW0RLUa41p7Vz+sW7hmsoGxWAfk0jQA7VRf8ZKROG6uq4RrQQqA1w7me9VzLCNno60lvnkgJ3t+Xz6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659265; c=relaxed/simple;
	bh=op0GJU1xMDdLSZq7ARYHsDndXpJ0A4dECpNEbqyLeNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZT3TjTP8z/fzn6L9diLRrLg/hxHTy8PQ6ETcQWuiZGzPEc84g/Wix/JAYiLZWO4ukhwkpO4SmYsERbIRXH9JRtHNeJygyQnt5aotCXiVu1fhWvN8gAMzXQD3apMgobmVdVBfEks2vHKgaJSvI5O1XTZxUYfPa1of2HEqVHfKsQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll01Q9kv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll01Q9kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507ED1F000E9;
	Tue, 21 Jul 2026 18:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659263;
	bh=G75TE9JdG9r538jByrWJ4ZibA0//cbsWGqmpFoZpAIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll01Q9kvY/cC7PRnqsOk/QerTu9U1n53XZtU50DeeAneKROIZVZRsf6j0X4cvITQs
	 2hZrK5GIhgtVlHDSoH7fh7gN4CtdVa5r2Zrx1q14D4rAUtdkkEWGS0Ahv8k8zEXFDM
	 SwJKRdKq9EP44JJoyxet/3hWuTkNxcDRIGs/lpnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1438/1611] net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked
Date: Tue, 21 Jul 2026 17:25:54 +0200
Message-ID: <20260721152547.792272599@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit e056e1dfcddca877dd46d704e8ec9860cfc9ec44 upstream.

When taprio's software path peeks a non-work-conserving child qdisc, the
child stashes the peeked skb in its gso_skb; taprio_dequeue_from_txq()
then takes the packet with a direct child ->dequeue() call, which ignores
that stash, orphans the peeked skb and desyncs the child's qlen/backlog.
With a qfq child this re-enters the child on an emptied list and
dereferences NULL, panicking the kernel from softirq on ordinary egress.

Take the packet through qdisc_dequeue_peeked(), as sch_red and sch_sfb
now do. The helper returns the child's stashed skb first and is a no-op
when there is none, so a work-conserving child is unaffected and the
gated path now consumes the skb whose length was charged to the budget.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Cc: stable@vger.kernel.org
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260625-b4-disp-31bcb279-v1-1-85c40b83c529@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -748,7 +748,7 @@ static struct sk_buff *taprio_dequeue_fr
 		return NULL;
 
 skip_peek_checks:
-	skb = child->ops->dequeue(child);
+	skb = qdisc_dequeue_peeked(child);
 	if (unlikely(!skb))
 		return NULL;
 


