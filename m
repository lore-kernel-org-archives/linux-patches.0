Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042602;
	b=mz6+dOD8ob57vqgndUo4Wo/0oVCBtbDATKuiSUlDR4A6Zd285UEhHwmTkZS/9uHQJpF9
	 tVswfNTW26OwPI/9TIit3y4KTXPex81OFz7qI28pwbt3oqpXMBJN+47h7PL8vpWiBRsMX
	 yncRv9sXBleI/Adc0N4Xp+MiXT4sObUVZoE0cfaRC9n4wkzlNbqM4W8qVUwP1OXfs5aqP
	 l4Dfm7HWpDXfUADZD6GyTefBR2oJb+6dAjKc/MxijCXdMcMc7NLbbH0OVoTLufKBNAn5e
	 drJdm+nyLslqQY6miKay8e2wjyXFS/ZUNM74UqLBiNlwHYcq9ltBhrxyVR7XbXSaqOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4czR1cbJDRevV7uzjETwni2NHO0uhc7U2JA5F+gT4eA=;
	b=j1oTTOuwyNWT1iVIJuJwwAYeeHPhzJqPuKmxJ9p9Qqw9tbT1kzUieUYaFed1VIWmeUOs
	 IF23IMV7ZHa6vz1h1SjRPO90yQ1SZznpuISdtgFlChsuVmnqQNJHZi5+zTnUd51DT1dL5
	 WMZ4jZs7We+r/oa9JDG61kckUOJfJU21fCUZIoCKWsgwLBr7d/zwKmzplkZZe7t7GBkZ3
	 ua8oZvJpaXTdm9saFjLLnMdXkN08OxCb5Afglw5FGB9wIlFt1yDc0vQHhzd2mpMzmwgow
	 jDOK9g59g6N0FO+JF5AW2gTgNUMkS7qFMnrYGnOTT3SlE+fmhpLIWYTYxEwamQQAnng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6zHB3tZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583BF606A320;
	Wed, 18 Nov 2026 22:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6zHB3tZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6311F000C4;
	Wed, 18 Nov 2026 22:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042602;
	bh=4czR1cbJDRevV7uzjETwni2NHO0uhc7U2JA5F+gT4eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6zHB3tZsx1/6SUPLr9tCbSOkg7KsVuDNNxzwCWW6DbLDKOOx+ZF8omRGeM9IJI5v
	 YnETx9F8+4dyHdsGTgQbCTQoUX90hrM4inmLudLVfDDIMNiY+5sBpGqTNDj2KOrJDt
	 QgVb8Anlek4abzVz32L+ainu3pJWHcnsXPHX3wtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3228/3318] blk-iolatency: flush enable_work after going offline
Date: Wed, 18 Nov 2026 16:04:10 +0100
Message-ID: <20261118150456.554098466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 020f61242d6ebeba5f8f2ef6e429aeffdd63f1c1 ]

blkcg_iolatency_exit() flushes enable_work before it deactivates the
policy, but iolatency_pd_offline() schedules it again for the last group
with a target, so the blk_iolatency is freed with the work queued. Flush
it after the deactivation.

Fixes: 8a177a36da6c ("blk-iolatency: Fix inflight count imbalances and IO hangs on offline")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-24-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index e50fc4e4240fb..1fd2025ea8b6a 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -645,8 +645,9 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
 
 	timer_shutdown_sync(&blkiolat->timer);
-	flush_work(&blkiolat->enable_work);
 	blkcg_deactivate_policy(rqos->disk, &blkcg_policy_iolatency);
+	/* iolatency_pd_offline() schedules it for the last group with a target */
+	flush_work(&blkiolat->enable_work);
 	kfree(blkiolat);
 }
 
-- 
2.53.0



