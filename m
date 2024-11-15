Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB2D2BB1B;
	Fri, 15 Nov 2024 06:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653641; cv=none; b=QUle5OXX34aWTiB0e2ZAzvxm2u/Y5uvERPd+4SGKc5w5+RsjOUXHZGAQBxjwrq4MdFb6AxuI6NhTA3cympk1FMC7lk0RJwiv+JX6iIyZs1uCDzWAl+j7yV0ZbcJZXRCuRaEnPvTMk3ctS19Vr4KsMFh1XWIKF8oljAw4UgY1yI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653641; c=relaxed/simple;
	bh=xtprLsi/yXI6LUoWwP4DPli6tZQOkdHyO4WTJVwgXOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRctiCSmDeFG00YEHLwX/itfgvFjnUhmIccLR64SdzXPE0Z5svyynPf2LNTlRV+aJDPbqLO1lIKYuXIgnSzct0cGjqtYt24Jp6bV7+xvvc9QRup8zQbP8e75A4Qdj0WvVKgzBTfM0jHPWx38EQdgNw3qMikDWINa6FtViPNzobw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dyongdxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dyongdxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611FCC4CECF;
	Fri, 15 Nov 2024 06:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653640;
	bh=xtprLsi/yXI6LUoWwP4DPli6tZQOkdHyO4WTJVwgXOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyongdxyLg6uDKGmJpQb0sEFYe22MNSWGnUHGPEEmto5iLJ3YkSacG7L38u0wLQOp
	 lYoikRlIrZQLIcVvQIoip7aMx040++toDOJ6ZptFKLPdQ4wudq5szqjiGMxC2khwKZ
	 /NszteMyX7IbwGBJBMNZy0TNZ3XysHcSbNDt6ojE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/39] block: Fix elevator_get_default() checking for NULL q->tag_set
Date: Fri, 15 Nov 2024 07:38:19 +0100
Message-ID: <20241115063722.946337169@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd71f0fc4e4b6..06288117e2dd6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -624,7 +624,7 @@ static int elevator_switch_mq(struct request_queue *q,
 static inline bool elv_support_iosched(struct request_queue *q)
 {
 	if (!queue_is_mq(q) ||
-	    (q->tag_set && (q->tag_set->flags & BLK_MQ_F_NO_SCHED)))
+	    (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
 		return false;
 	return true;
 }
@@ -635,7 +635,7 @@ static inline bool elv_support_iosched(struct request_queue *q)
  */
 static struct elevator_type *elevator_get_default(struct request_queue *q)
 {
-	if (q->tag_set && q->tag_set->flags & BLK_MQ_F_NO_SCHED_BY_DEFAULT)
+	if (q->tag_set->flags & BLK_MQ_F_NO_SCHED_BY_DEFAULT)
 		return NULL;
 
 	if (q->nr_hw_queues != 1 &&
-- 
2.43.0



