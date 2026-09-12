Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB7C3624A5;
	Sat, 12 Sep 2026 09:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204871; cv=none; b=Z++rY0YcxoaUaLW52u90hWP789OLGenOe3kZ8isURfatXeKZ4YWU0xdaPhZWS209Ig/yI2Sxa4RyIbs5XEmi/+h5WGtPE7PO6YKn9S0GZgpURMePIMz51NOVfPunSJ7E3fN5Bu8IZFYVDFqgYPcyu1H9gdqL8t7HOVYDEKRoshw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204871; c=relaxed/simple;
	bh=VnGg3SPrBQKcnrp40/0n87FdfQMD9UzklpI9KNT/o+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzjczWHOulxkMbmjc5uYcfvXNEPiMLkVCF5LEICu1yyqZFevEiMj4gElTHhKg99Yv84gRLAQRxqdQi73Jb9Jwhod86N1btF0oxvm9y1qixcpNSaPGj5VeRJUlCuI1yMWjLGOY+bY0O7wjqHX47r/tMDPxaEIrJ0Z6tTTIibvAY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6xVu7uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6xVu7uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547C71F000FF;
	Sat, 12 Sep 2026 09:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204870;
	bh=4zsntrsh/xFaRlDiUyANN8dM1d2Kt6Jj0UGWCItSVFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6xVu7ujYktoU+vbXtf2epwkvFlmxR2DLkQjtldKgvwqpK+v8xVDoAsRHBFpVilk3
	 SPkSLhGiKFE+d5wrkMZ18bUzpU7u/zafqqOCvyZIKI19nnyPcanIEjf6Dunr6S086Q
	 /Ztn8jtlwGTrTYiZZs/KN/yL7oaLtD+VOZzp98t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1703/1815] net_sched: sch_fq: fix pacing delay underflow with pacing offload
Date: Sat, 12 Sep 2026 08:57:33 +0200
Message-ID: <20260912065728.958891485@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 137b8ae233cabe7fc77cce86f5ba33bf1b369e26 ]

When pacing offload is enabled (q->offload_horizon > 0),
FQ can dequeue packets early (now < f->time_next_packet).

In this case, the drift calculation (now - f->time_next_packet)
underflows to a large unsigned value.

min(len/2, now - f->time_next_packet) then evaluates to len/2,
incorrectly halving the pacing delay for the next packet.

Fix this by only applying drift compensation if now > f->time_next_packet.

This bug was triggered when flow_max_rate was set on the qdisc
or for non EDT packets (packets with a zero skb->tstamp).

Fixes: f26080d47007 ("net_sched: sch_fq: add the ability to offload pacing")
Reported-by: Willem de Bruijn <willemb@google.com>
Closes: https://lore.kernel.org/netdev/CANn89iK6O7ujR9zCJzd04MNLQoDi3mA+HWsR-hgQWYzLS3gZfw@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260820120706.1995449-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 7cae082a98472..4b5f6d896c6d5 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -828,8 +828,12 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 		 * f->time_next_packet was set when prior packet was sent,
 		 * and current time (@now) can be too late by tens of us.
 		 */
-		if (f->time_next_packet)
-			len -= min(len/2, now - f->time_next_packet);
+		if (f->time_next_packet) {
+			s64 drift = now - f->time_next_packet;
+
+			if (drift > 0)
+				len -= min_t(u64, len / 2, drift);
+		}
 		f->time_next_packet = now + len;
 	}
 out:
-- 
2.53.0



