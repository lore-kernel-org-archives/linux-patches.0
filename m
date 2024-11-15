Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C55185949;
	Fri, 15 Nov 2024 07:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654019; cv=none; b=LrbjNmT5+lTVk0vdx4SgyIYY9+D0GbrJ8jZmCIXLG59cHWLxpdTqrgh/Nc04BdNXo55LVvQxKi0ePMZxFpZV1YsNgOnb1rRT1GhZ5SddYjT6pAV9TFx9YsT4N+1Uj6aN0uyEOWZWPBatufEupm1hDJvhlBnkAae0cBNAPotT7vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654019; c=relaxed/simple;
	bh=0m6mV5T+uKav4jseUtG2ikeMIfZyyJzj/Y115fc3tMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd6+ZaXYKmY0nnD7awCDr6/dQWxyxHl6T4IJ/xTk7J0xx9ZLAbBjgJu5VtRor0SWn3qlEjcI5SBRx1KtCqwunNF/VbWMEbcng7uG3uxHubctHbW0BnZE7w9ElA8qTWFVeO7wOkTS+UNTDVbwyp8serDVQuKaUBl3hcfnKD1uco4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j69kq6me; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j69kq6me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE07DC4CECF;
	Fri, 15 Nov 2024 07:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654019;
	bh=0m6mV5T+uKav4jseUtG2ikeMIfZyyJzj/Y115fc3tMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j69kq6mecjlFMwL+L0ZUEark4wzKhikOSE3zzPsthe6RME/hzhJ2Sq3BZMy3n+ulM
	 LNaL7nncDgpCHOjTRhqCD1b+HQtoY1OvmivQ8yWfYQc5jcl29vCF9OX7fDLFXdfaPg
	 nrsJD3gFHSwHt5rTSys2zb97YXBp8Qj53st5y6fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/22] block: Fix elevator_get_default() checking for NULL q->tag_set
Date: Fri, 15 Nov 2024 07:38:49 +0100
Message-ID: <20241115063721.298354328@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1b5e57f6115f3..a98e8356f1b87 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -620,7 +620,7 @@ int elevator_switch_mq(struct request_queue *q,
 static inline bool elv_support_iosched(struct request_queue *q)
 {
 	if (!queue_is_mq(q) ||
-	    (q->tag_set && (q->tag_set->flags & BLK_MQ_F_NO_SCHED)))
+	    (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
 		return false;
 	return true;
 }
@@ -631,7 +631,7 @@ static inline bool elv_support_iosched(struct request_queue *q)
  */
 static struct elevator_type *elevator_get_default(struct request_queue *q)
 {
-	if (q->tag_set && q->tag_set->flags & BLK_MQ_F_NO_SCHED_BY_DEFAULT)
+	if (q->tag_set->flags & BLK_MQ_F_NO_SCHED_BY_DEFAULT)
 		return NULL;
 
 	if (q->nr_hw_queues != 1 &&
-- 
2.43.0



