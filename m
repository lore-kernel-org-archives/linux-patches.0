Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BF8186294;
	Fri, 15 Nov 2024 06:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653477; cv=none; b=nE/gCQ/KPU0qxcgIw/QtAE/6lK5dpzqcHC6sBBgDDdHsy2n+9/IkH7LaZTBSIrGOs+ITBdv8vCSugqY0v4iBYDf/cooMj/qxnhd/cIOtaV5gyO9FiDHIWxNp7irgIaI62lYGYuD+mYrekbDBc0UZ1NkEz5HL9MZ8wX9QxMYMnrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653477; c=relaxed/simple;
	bh=r6APzv3Jt2taEHTSDoa6a/gpeoAe6ti2s9hBsu6Ww2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSC6ABHve2x934YXGkn1pYndHdSMRWGEtcWxcz1AZyaoS55TWfz9p4fB0HhU4jtC+Zo5Gm8p4opMNwGf9V+BefsLMeQ0GF5dtwCb/ZuA4Uejw4Rn4gUQQ1g/ZvdTz0a1J5/fn5BGN5pR1ZvBa0XSrr0plnOuOGgK7k3OQKD0InY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dR5YgYmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dR5YgYmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1112CC4CECF;
	Fri, 15 Nov 2024 06:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653477;
	bh=r6APzv3Jt2taEHTSDoa6a/gpeoAe6ti2s9hBsu6Ww2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dR5YgYmRjy4X4jw5ZvQcGaLPfHZXMV6zEjSTIVM1IzG0KuLSjfedPJ4KWbbZq98Fv
	 kkOqTmMz59Wc/6w95jHCCM75U7p+hGz5JhPcgfwm+gFmyG9CooSbZ0U+xXZAr3mcft
	 00n45wa0npunkBOsbNKkxj+K2fPSbrsBcOWoeyhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/48] block: Fix elevator_get_default() checking for NULL q->tag_set
Date: Fri, 15 Nov 2024 07:37:55 +0100
Message-ID: <20241115063723.193436553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: SurajSonawane2415 <surajsonawane0215@gmail.com>

[ Upstream commit b402328a24ee7193a8ab84277c0c90ae16768126 ]

elevator_get_default() and elv_support_iosched() both check for whether
or not q->tag_set is non-NULL, however it's not possible for them to be
NULL. This messes up some static checkers, as the checking of tag_set
isn't consistent.

Remove the checks, which both simplifies the logic and avoids checker
errors.

Signed-off-by: SurajSonawane2415 <surajsonawane0215@gmail.com>
Link: https://lore.kernel.org/r/20241007111416.13814-1-surajsonawane0215@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/elevator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 5ff093cb3cf8f..ba072d8f660e6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -558,7 +558,7 @@ EXPORT_SYMBOL_GPL(elv_unregister);
 static inline bool elv_support_iosched(struct request_queue *q)
 {
 	if (!queue_is_mq(q) ||
-	    (q->tag_set && (q->tag_set->flags & BLK_MQ_F_NO_SCHED)))
+	    (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
 		return false;
 	return true;
 }
@@ -569,7 +569,7 @@ static inline bool elv_support_iosched(struct request_queue *q)
  */
 static struct elevator_type *elevator_get_default(struct request_queue *q)
 {
-	if (q->tag_set && q->tag_set->flags & BLK_MQ_F_NO_SCHED_BY_DEFAULT)
+	if (q->tag_set->flags & BLK_MQ_F_NO_SCHED_BY_DEFAULT)
 		return NULL;
 
 	if (q->nr_hw_queues != 1 &&
-- 
2.43.0



