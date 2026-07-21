Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845692F6931;
	Tue, 21 Jul 2026 20:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664110; cv=none; b=rZ1HsirNJNrs4Yv5Naa0bvwa5rvkLThAWUVX5JrD4icIO262NcHciNSxadW5x61PSZ8a53YJbgXIQYdXe0LfSjNxQKSh7e9eZDuXxtD/3M4KEbikN7n83OGfuZ6R8c9G9LeP2y9fm77pDt/FHRcj0qipAz8VAeHrQAEVuIuJsm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664110; c=relaxed/simple;
	bh=2m9oPMJcfaRKHIYOSJl3Dz39MydHEESplE8u1a/+ttQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg5+c5tBYm2GddZnRk3bAXwnepCZgYpSxfZEkqWw4JgyUhNSmt87SJyUG9Nch+yWmkdzkZLxiHRvFD9powZW5cMm+cBG21Q2mSxIl6LYtm3BpHIEM3OSDTZba5My8+DYaYkfDP6mYBwQhxQgRHErbI4vYrYM7cQQksQACnBFbAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcdZZLBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcdZZLBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CF31F000E9;
	Tue, 21 Jul 2026 20:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664109;
	bh=LwQcJuZZU7TiTe+EkJgm+T6+3TldYUom241WddXxL5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcdZZLBV+wjDTzY79uDLemmMfoT0MY4rajPQrQr4QtmWGsZX0LJjtIcT2C3ZjGtx2
	 jVI89J554PE+yh75rfQOjDXdI8eWs3eABL216U9yw1lM9hfdBN+q+9T446les3HUg5
	 SMz1xC5Q4ljG2128UOUG9v/OxZwAahdMT5eYKtoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1077/1276] net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked
Date: Tue, 21 Jul 2026 17:25:20 +0200
Message-ID: <20260721152510.090025020@linuxfoundation.org>
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
 


