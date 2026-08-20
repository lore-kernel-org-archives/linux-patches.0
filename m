Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C0A47CC97;
	Thu, 20 Aug 2026 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244312; cv=none; b=H9FaPWvm5+oC6h7C2wLDpx52ulYyOUweAQFI3exQyRbh95VaMpN1sUxSCEQnsV/VpvCGnF16G/Y28F34fdevUngAwu4CswsR9UDnx6Bb8wGpwMa+2yRpS4prtAW1wzoeek2xppRbsH1tvrPSedgV73n+FH4eS2iVHTyFd7gxusk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244312; c=relaxed/simple;
	bh=zjWyQrNM3C/rTRCQ01pYchQsyeAHg4UgFk6cPC776FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGbIXQfVbVA8gAiC8z5Y5vWoEf+UICoZZXfcVFtapTOMSxoeAiqinH3t2FeYLBJ7oX2c9ZlJbzVzGk7bY/TANZ8u71o0xtKm9wcXdUxI4kQoG53bOI4Uq+YZK3xUknR5Xn4P22fnD7PZWjm9E70UmNXYdCmk2GCe5C2hoPUHan0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouZIx3NE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouZIx3NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09BD1F000E9;
	Thu, 20 Aug 2026 16:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244311;
	bh=ILcFuxIVvF/yNF9aT2AJteAH96xOemfqqondZ/9UKG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouZIx3NEwdbVEXGwuOUDtpwRUh1j5/pq2fcxi4TreOoNj3J64GtzBJkVtk8HRJNUK
	 24MCk5eROD2SJf2zmXGHgL/tnBDDYibgyC/xXJoZnq8UCjKl2FQ0pEbv7w6fjDEAj9
	 bystUlUuS+5yHASPifEmT9Bh34n9FU35+CHylFqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/235] net/sched: taprio: avoid calling child->ops->dequeue(child) twice
Date: Thu, 20 Aug 2026 16:56:00 +0200
Message-ID: <20260820145220.201815744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4c22942734f0814d3c928c25a80f48df0a6ce45e ]

Simplify taprio_dequeue_from_txq() by noticing that we can goto one call
earlier than the previous skb_found label. This is possible because
we've unified the treatment of the child->ops->dequeue(child) return
call, we always try other TXQs now, instead of abandoning the root
dequeue completely if we failed in the peek() case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e056e1dfcddc ("net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -559,12 +559,8 @@ static struct sk_buff *taprio_dequeue_fr
 	if (unlikely(!child))
 		return NULL;
 
-	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-		skb = child->ops->dequeue(child);
-		if (!skb)
-			return NULL;
-		goto skb_found;
-	}
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags))
+		goto skip_peek_checks;
 
 	skb = child->ops->peek(child);
 	if (!skb)
@@ -591,11 +587,11 @@ static struct sk_buff *taprio_dequeue_fr
 	    atomic_sub_return(len, &entry->budget) < 0)
 		return NULL;
 
+skip_peek_checks:
 	skb = child->ops->dequeue(child);
 	if (unlikely(!skb))
 		return NULL;
 
-skb_found:
 	qdisc_bstats_update(sch, skb);
 	qdisc_qstats_backlog_dec(sch, skb);
 	sch->q.qlen--;


