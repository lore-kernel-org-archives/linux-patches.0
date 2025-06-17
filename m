Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA66323A9B3;
	Tue, 17 Jun 2025 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178301; cv=none; b=B5J6Zy9KA0066H9YOq4kcWU6SAAhVAGGRJaFkEcpoMItcegl9II0Y/Y1CIjWljVzwvA4lSgMdYT+1tVuX6I2aRlcvhMMFKmz6H3TAfKsMnjZX6ANNlKaIBcjLHc+5BlSxZ7+v8P9L+BeiBuRrETrSrtNWlUHnOayGzT2uLPQccw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178301; c=relaxed/simple;
	bh=TG4Zg8nUig5u0tJhs9tNXmuinUOT2FSk/6WuTYc/2vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edqMfeXUQFBjq6XAaSzSQpTvPL+fD0EppirWgN4YU+IkYEhiWjYM9OEYmt2DCfLXc4p6xfQ28XeA/9CkxvAGCCnBWWBarKYBKBZsoqQV2vQHLfPVyrM+IEo9ctKbrn5h9JSjHhjIHCBRgti96nWy6HpbAJzuY2gwWVfBvKJeqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wf4vhOoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wf4vhOoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C46DC4CEE3;
	Tue, 17 Jun 2025 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178301;
	bh=TG4Zg8nUig5u0tJhs9tNXmuinUOT2FSk/6WuTYc/2vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wf4vhOoCqJZ2esHkxadpOlBHn3m29VZlkn+ZvWb1IblBzzafIi7iDyEohQTVJEXO0
	 Ab6zL9x3Iyf+FHp70On1ESSz8dv96bmQcWFHfzaSZCPZTzdvQijH4PhjMukIVUfnKO
	 RlJK3L8vvme/MItRjYmCZ3ZnwX5zmkmyG34EG7NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 476/512] block: use q->elevator with ->elevator_lock held in elv_iosched_show()
Date: Tue, 17 Jun 2025 17:27:22 +0200
Message-ID: <20250617152438.868820045@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 94209d27d14104ed828ca88cd5403a99162fe51a ]

Use q->elevator with ->elevator_lock held in elv_iosched_show(), since
the local cached elevator reference may become stale after getting
->elevator_lock.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250505141805.2751237-5-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/elevator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 43ba4ab1ada7f..1f76e9efd7717 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -752,7 +752,6 @@ ssize_t elv_iosched_store(struct gendisk *disk, const char *buf,
 ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 {
 	struct request_queue *q = disk->queue;
-	struct elevator_queue *eq = q->elevator;
 	struct elevator_type *cur = NULL, *e;
 	int len = 0;
 
@@ -763,7 +762,7 @@ ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 		len += sprintf(name+len, "[none] ");
 	} else {
 		len += sprintf(name+len, "none ");
-		cur = eq->type;
+		cur = q->elevator->type;
 	}
 
 	spin_lock(&elv_list_lock);
-- 
2.39.5



