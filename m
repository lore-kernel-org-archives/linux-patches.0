Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95817334695;
	Sat, 30 May 2026 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161863; cv=none; b=HHVjj5lpGAQCZx3/bZuTzrxvvgaNNGdqhL9Lok5CbYWbvx9jkD7gGKxq4boEF0Z0k9yj4Kx9Bew8OMUttdatQ1cUOb5CZzHs6g7a6e9QTUTykDtBTocjXbLdwSBegvYoOsgopyaAOJhYNd9Z7kcxYI3Dl8ofvR+iSl5NCfy+D28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161863; c=relaxed/simple;
	bh=81RrSrxcVfxzgnIwjWtSdPXmCoy6EvXbtAh6ffNEmBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1zmgKvti8AD6af1g09CHGVD2ImB5O8PEqCKOkoarUdhSRleUwTsFR90qkBC36vyuVtzCMwH8UXkwNK5bjVygsYDXgw5mTCMQVo0+l5BifO/+a+CKvRXCeBGyobWSmZF3+9F8OSdYldXB+WEoupkEdGohxNRFzKulpGxg+hMGyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrC3iUkW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrC3iUkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88EB1F00893;
	Sat, 30 May 2026 17:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161862;
	bh=WWBn0cMIvhMtqhM8gEX9cjOAnVEGY6LUOTIYz76cuTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrC3iUkWBJy6aMb3+4yQY4MqjBBQixibaMtXSGh4yGKazX8+AsGhSNRw5NxvXT52l
	 5rMQcG7JK9kL0UsAVeZxL8CGOeg6FpCNVeXsm4BzLHLVNuTRtYD1U5ieNaimc34uIQ
	 DoIYyk+aiUdqtmHbl2Unpt+Hvw8kQWs6NJbbOEUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 749/969] net/sched: netem: fix slot delay calculation overflow
Date: Sat, 30 May 2026 18:04:33 +0200
Message-ID: <20260530160321.242762995@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index adb2bab79c87c..2c47bd8dba647 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -647,9 +647,8 @@ static void get_slot_next(struct netem_sched_data *q, u64 now)
 
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



