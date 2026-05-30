Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C953C2761;
	Sat, 30 May 2026 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164550; cv=none; b=WtBtKNR9x+4/yFfcJhavC2EC/HZD2+ipIF58bKlh6rjIrFBdK7WPe7DpezKtgPDUmkigNpqNLR5iJq1N5xk+oGCdD0oC2FzjhxLU+5KDiG4M3RENPAK1/3kxxI/XfFYNb6ZIyeJ/V0pUclsGWKH7tG4/sqdV8Nbk+bK5trhCqf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164550; c=relaxed/simple;
	bh=n2ODU8rRXBPpeH3cYPZUPFtMTLTx4o43TEJoEKEiKvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASK20ncPjIW+zGWU+I6+KdIDriMzOE4BJKBoYSv0wypZQWG4O+qt1aA/Iejsf+6pvNWAJLq/DxJOn+P3Q1nJ8QHsokj3s9kGr/k9oiiGk2NfkIAN+JfVDqIIPbUELbjdIGunueeCqQezoE4oAgJ+RD3r2vvq8VfA4f9Arf1OmcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1aCgjLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1aCgjLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B001F00893;
	Sat, 30 May 2026 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164547;
	bh=8GBb+0WFydlACaF6biFDWCm0epNRbDgJ6Y91AhOVioE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1aCgjLOdiH29hk5S0hxPGKkvN+hEq3gm5lTCjJ5+mpFT0ASrPZ7nm8UpVi4ASyIK
	 lL8a497TKBdkxo4HF7orE7rSmAzzHZXRfaIlw6KEe6Z6WP+mqV+vNKb4J/B8qjgnSB
	 yeT3+CxFMzaZUnvz8Qtc99ludHd1Kdjr6CbEexB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 558/776] net/sched: taprio: continue with other TXQs if one dequeue() failed
Date: Sat, 30 May 2026 18:04:32 +0200
Message-ID: <20260530160254.563039514@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 1638bbbe4ececa615b273497d347d59ad71060a2 ]

This changes the handling of an unlikely condition to not stop dequeuing
if taprio failed to dequeue the peeked skb in taprio_dequeue().

I've no idea when this can happen, but the only side effect seems to be
that the atomic_sub_return() call right above will have consumed some
budget. This isn't a big deal, since either that made us remain without
any budget (and therefore, we'd exit on the next peeked skb anyway), or
we could send some packets from other TXQs.

I'm making this change because in a future patch I'll be refactoring the
dequeue procedure to simplify it, and this corner case will have to go
away.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 105425b1969c ("net/sched: taprio: fix use-after-free in advance_sched() on schedule switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8924b439c459d..0a4501854e4b2 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -616,7 +616,7 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 
 		skb = child->ops->dequeue(child);
 		if (unlikely(!skb))
-			goto done;
+			continue;
 
 skb_found:
 		qdisc_bstats_update(sch, skb);
-- 
2.53.0



