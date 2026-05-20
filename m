Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83A617A309;
	Wed, 20 May 2026 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296953; cv=none; b=GOuV3XdaPAjWU7uOCjNy20wL8YWrRW0678BJyTBUvpDqAvv7cOM+3sE/G4MQyudiRYjP2e55b58i2mpYobiSxPAFa5rzj7oKsq0V7aJyruD8S+hzS5Q/ihRGW9DlZHDDLXi1on20Fe+Y3EnDcv5slhNmPthoRX4kIKUyd+Iq5iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296953; c=relaxed/simple;
	bh=Z4PPliaY5WLqVw4cST1sAk+hKhUHCF0UZut1reww1CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tep60b0v0F1gKXqC9PE3fKVsclWCj9guJonJOlDWTB0Y+zqQaqxs7qPKDFA+rBL4Z56jb1EklzigXEFgSlmkZNPxPN2EvmWxhOXlDFg6K72jRr4yvPkN7PGh52NuyFQ3W6ibUrfrLc4+6EmuPgoY8cQRk1TR5INxHoAz/MMxA1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMdKiYHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMdKiYHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257311F00893;
	Wed, 20 May 2026 17:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296951;
	bh=wmKwcWlwz9YBYnb57TAOvfRwBBCw1Uc/a5GupAaCij4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMdKiYHQy9ZQIiGjfWj2MaCh3mA6P8ML6OW4As0mKjgBoSKOtHF2VvdfNOBExWCA1
	 6DHWewxja4Zow9cqXrXL9QZq+z0PPWhge8nj0qCUrILLlHw9wlQvTAFwibbByhp+PL
	 43VBRTRhotz4IYExfL6cPII0oeu1Z/Gn10g6brAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0993/1146] net/sched: sch_cake: annotate data-races in cake_dump_stats() (V)
Date: Wed, 20 May 2026 18:20:43 +0200
Message-ID: <20260520162210.704794620@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a6c95b833dc17e84d16a8ac0f40fd0931616a52d ]

cake_dump_stats() runs without qdisc spinlock being held.

In this final patch, I add READ_ONCE()/WRITE_ONCE() annotations
for cparams.target and cparams.interval.

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: "Toke Høiland-Jørgensen" <toke@toke.dk>
Link: https://patch.msgid.link/20260427083606.459355-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 804e8f4c46f32..7033f859a3948 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2356,10 +2356,11 @@ static void cake_set_rate(struct cake_tin_data *b, u64 rate, u32 mtu,
 
 	byte_target_ns = (byte_target * rate_ns) >> rate_shft;
 
-	b->cparams.target = max((byte_target_ns * 3) / 2, target_ns);
-	b->cparams.interval = max(rtt_est_ns +
-				     b->cparams.target - target_ns,
-				     b->cparams.target * 2);
+	WRITE_ONCE(b->cparams.target,
+		   max((byte_target_ns * 3) / 2, target_ns));
+	WRITE_ONCE(b->cparams.interval,
+		   max(rtt_est_ns + b->cparams.target - target_ns,
+		       b->cparams.target * 2));
 	b->cparams.mtu_time = byte_target_ns;
 	b->cparams.p_inc = 1 << 24; /* 1/256 */
 	b->cparams.p_dec = 1 << 20; /* 1/4096 */
@@ -3042,9 +3043,9 @@ static int cake_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		PUT_TSTAT_U32(BACKLOG_BYTES, READ_ONCE(b->tin_backlog));
 
 		PUT_TSTAT_U32(TARGET_US,
-			      ktime_to_us(ns_to_ktime(b->cparams.target)));
+			      ktime_to_us(ns_to_ktime(READ_ONCE(b->cparams.target))));
 		PUT_TSTAT_U32(INTERVAL_US,
-			      ktime_to_us(ns_to_ktime(b->cparams.interval)));
+			      ktime_to_us(ns_to_ktime(READ_ONCE(b->cparams.interval))));
 
 		PUT_TSTAT_U32(SENT_PACKETS, READ_ONCE(b->packets));
 		PUT_TSTAT_U32(DROPPED_PACKETS, READ_ONCE(b->tin_dropped));
-- 
2.53.0



