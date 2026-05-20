Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B948346E55;
	Wed, 20 May 2026 18:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302755; cv=none; b=H/on6s5kZmc/mQ1WagDKyDH7WU3OO5BuGUaas1987stcs9rKwcrUBynl3sth1pW+Q4mDw5LZ5IpV+XGOThO68U2fFFK7V/SpCNCLSTiv5ooTLL1gbVldIYaVY/vcQbdZ7AW/PY9ATcJgLAzLZaC3BvGs40r3K9KlO5inVhOw9LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302755; c=relaxed/simple;
	bh=SncHukTGTUwM9ShYmGf4QkSlTR2mlOw9751uBbUrhqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDLvuR+hexWl+1hoerIXLLVzFU3OY2ddIdcfNXhKEL9UKlkTNoL8z0exB5ATWAn9r9TDJ1wBdfuyXSkw1g+NSudYaZ3eTJRDSQZ4JhouxwjzIgMk/6BhN8Vk+9SF/n616SFCOGL+ZaL9X9hczX7l/MM9Ps63YxGUgBvqUrrlfpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D328Nxmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D328Nxmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853891F000E9;
	Wed, 20 May 2026 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302754;
	bh=P2csOcgrCUwk9bO6r+/rsJCE59heTYB+lhbgJwNS6lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D328NxmpG6D2ebnBDugnrr4WpSz9Ze34iar+HMuL6RSC7ZmWuIzFjXS+6GmXjRnbw
	 7nDhUkiwgYKVHh22JdFeiP1wxTdu33vNMnwliAqF/Nz6FTqttYBkxfcg7WcS3mHf71
	 U0L9i/I9hzvX/7GbY4BqTcPLaz4Sh6HrZSQA8h6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 385/508] net/sched: netem: fix slot delay calculation overflow
Date: Wed, 20 May 2026 18:23:28 +0200
Message-ID: <20260520162106.962047802@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1bb399cf40328..b632e6678881a 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -657,9 +657,8 @@ static void get_slot_next(struct netem_sched_data *q, u64 now)
 
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



