Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1352D33AD88;
	Sat, 12 Sep 2026 09:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204882; cv=none; b=KJB9UwMyFXsJzOb+DLBYKqB0JGURYOeT/RPrXrSvu7+iLCbVTjuUTpt1obDIBvP2VucyMZ4298Ap2mp6Nd9jz6RHK5F9/48nrTMFmHeH7VVZKeFqE8GflY8tLWJMJWMNXmHpGvrNooLX78nXq8C6rIoVNfKNiL/Q+cqZWzE0cS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204882; c=relaxed/simple;
	bh=E9VKBdsvGveRKMJMsFRxmgcUH8GPPByKV1KLXNiivC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PX4ADjHiNKboTTWFnHkh+di+OWa00PICqZpr/fPFDoxxiRSmZkKd/ArxRS23yFe73R7qn90EhUp45wAlbcObq5RrIYc1AKb0RO2/zShqFuMTtQZottMeQDwMs2cXEVedHcRmI6t2jXUflPbT+kwRg+pFOTBkkQjyqRwQVEpkn3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgYbZWF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgYbZWF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A529B1F00893;
	Sat, 12 Sep 2026 09:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204881;
	bh=prGElH5R+KOEv9NY8qWggqh1STKDM0uUXretdqK/AoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgYbZWF0OBcUWPcKgBiZPiioLoHlRy7uYZjORS1HocBuL4IcqnNON/ClBq0QSiMMI
	 vaUiT5GdHU3Ut+4krUGCRLCkbLP/oAPO1nYSb2gJ8ohWS0FfQ2yGC9LQjcF0cU7N/I
	 c5K6jIwBQ9EQzzC/x0Vf6Pjjrq87yAjgshXj0DMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1705/1815] net/sched: sch_cake: fix autorate reconfiguration throttling
Date: Sat, 12 Sep 2026 08:57:35 +0200
Message-ID: <20260912065729.006154285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Piscitelli <ooonea@gmail.com>

[ Upstream commit 7cbfb180945ce529608e4d4e24a6d483699fab1e ]

CAKE's autorate-ingress path intends to limit shaper reconfiguration to
once per 250 ms, but last_reconfig_time is only checked and never updated.
Since the field stays zero, every qualifying capacity-estimate window can
call cake_reconfigure(), causing avoidable rate churn and scheduler work
under bursty traffic.

Store the current timestamp when autorate actually reconfigures the qdisc
so the guard enforces the intended interval.

Fixes: 7298de9cd725 ("sch_cake: Add ingress mode")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260820154503.892214-1-ooonea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index f25f60978631a..dc93267029e70 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1907,6 +1907,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 					ktime_add_ms(q->last_reconfig_time,
 						     250))) {
 				q->config->rate_bps = (q->avg_peak_bandwidth * 15) >> 4;
+				q->last_reconfig_time = now;
 				cake_reconfigure(sch);
 			}
 		}
-- 
2.53.0



