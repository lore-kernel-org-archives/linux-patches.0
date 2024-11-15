Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528B9EAD0;
	Fri, 15 Nov 2024 06:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653182; cv=none; b=qmgea9lSdDrIrHuDmIJvPrlziC9GzDjjDOkJv1l0z3kE3JZO1KF+7+Qnul38HbLZnL0G4B9K8rMNvB3UPoDa6HoNwmbyKI2FeQ+8nkE9UObzx9ymVt3w7fplYywtDO4BSstIGk/ekcs1W506w75ogUz/VXOjMRpDeL2rx/EXwuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653182; c=relaxed/simple;
	bh=43jLgVqYTfitqesq0mmBU4ah2dHleNgBIuye3HNcUE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGzKwpW0Dodo5AKEqFZYXwiATiYKODbB+348oOuRjnPCLH62Kfh1Kt4TKekxMmnf7dFls7tYIxDRxuyNOezCSkEcXzZenWY0+UcH+J7xs0ic/dLPCSjuORj5pydnof1z6IhODHTaqLkNCjddQDnPVROKRIpMD0bk13P66XW6OrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjhae6g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjhae6g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5214C4CECF;
	Fri, 15 Nov 2024 06:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653182;
	bh=43jLgVqYTfitqesq0mmBU4ah2dHleNgBIuye3HNcUE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjhae6g7nchckHrlTsbdZ69Lx6f71bSiuBwlyTF3QrsM+rjFZxJw0jqgfRINgCqIW
	 swmbejdX8STnMHjqqsHCTzpU1EJ7fpxL/9cIN2nELU13H7R6l0DRSU64paHpLhHZpA
	 eGGghigH4FbVJ8dpNGJ+vm+9/RrIEmT2dSVhx4ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 11/63] block: Fix elevator_get_default() checking for NULL q->tag_set
Date: Fri, 15 Nov 2024 07:37:34 +0100
Message-ID: <20241115063726.304802172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 640fcc891b0d2..9430cde13d1a4 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -550,7 +550,7 @@ EXPORT_SYMBOL_GPL(elv_unregister);
 static inline bool elv_support_iosched(struct request_queue *q)
 {
 	if (!queue_is_mq(q) ||
-	    (q->tag_set && (q->tag_set->flags & BLK_MQ_F_NO_SCHED)))
+	    (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
 		return false;
 	return true;
 }
@@ -561,7 +561,7 @@ static inline bool elv_support_iosched(struct request_queue *q)
  */
 static struct elevator_type *elevator_get_default(struct request_queue *q)
 {
-	if (q->tag_set && q->tag_set->flags & BLK_MQ_F_NO_SCHED_BY_DEFAULT)
+	if (q->tag_set->flags & BLK_MQ_F_NO_SCHED_BY_DEFAULT)
 		return NULL;
 
 	if (q->nr_hw_queues != 1 &&
-- 
2.43.0



