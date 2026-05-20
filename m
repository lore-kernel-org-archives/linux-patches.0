Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1FE369D78;
	Wed, 20 May 2026 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296789; cv=none; b=rNr17yLvSLWgXbgVSjZQd2sXpvLIY/qLjNVTBPKwS3Z4iD7wKVGY2TKSYMbQxmaNS4YbnVMkFLpd4Mokwc/3pOEmsw5+R/gWdCC9IWTli1HhqnhOAcnTE8rJX350dW7QlRPA8sBZxiyLtBsPJsz8AOnjiSwlG1EQx/5eZpfvb8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296789; c=relaxed/simple;
	bh=FqU8HVX73zK3xNrUWwDwj8k+hx5rndrHNFeI3rr2lIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri08/HQPV4Cug2cXy7A0JExvxdulL43MJDzMUQpBmKrUc1gtZ2o8dfwo1M5jMuTTsCczQfbqlSvXRzJwFuKy7py5drh1SbNkQlkJ5CQP91LMD/eMNOLX9tixk4eeQpk4yvVb5e/8AcGwxbpMDncAFpXb3kx1rn/M0n1WKVuTtF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p96k9HGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p96k9HGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A228C1F000E9;
	Wed, 20 May 2026 17:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296788;
	bh=1Arx4XvJgLDq4l01CNxDpcTXEsbNufKD1a/AvK+tWm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p96k9HGcygroRPPTxdJktYDW3idBkDNE7XE0lql6NJ3YcDFe4NCd9ZvWwSOrTz36u
	 m5x3l21arbuY9XhXCmWOhMgoujD5WLok29rtBxyKLP2S32xAl9RVzr6Ujxnm8BoAc3
	 Q7/GAtb6JuCm2M05nkMGy5aeXa8q2mkJOdrwJHdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0932/1146] net/sched: netem: fix slot delay calculation overflow
Date: Wed, 20 May 2026 18:19:42 +0200
Message-ID: <20260520162209.328412503@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 51e94e1e2fef351c74d69eb53666df808d26af95 ]

get_slot_next() computes a random delay between min_delay and
max_delay using:

  get_random_u32() * (max_delay - min_delay) >> 32

This overflows signed 64-bit arithmetic when the delay range exceeds
approximately 2.1 seconds (2^31 nanoseconds), producing a negative
result that effectively disables slot-based pacing. This is a
realistic configuration for WAN emulation (e.g., slot 1s 5s).

Use mul_u64_u32_shr() which handles the widening multiply without
overflow.

Fixes: 0a9fe5c375b5 ("netem: slotting with non-uniform distribution")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260418032027.900913-6-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 640b51be807aa..475c14b3dbdbf 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -659,9 +659,8 @@ static void get_slot_next(struct netem_sched_data *q, u64 now)
 
 	if (!q->slot_dist)
 		next_delay = q->slot_config.min_delay +
-				(get_random_u32() *
-				 (q->slot_config.max_delay -
-				  q->slot_config.min_delay) >> 32);
+			mul_u64_u32_shr(q->slot_config.max_delay - q->slot_config.min_delay,
+					get_random_u32(), 32);
 	else
 		next_delay = tabledist(q->slot_config.dist_delay,
 				       (s32)(q->slot_config.dist_jitter),
-- 
2.53.0



