Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DE22FA625;
	Tue, 17 Jun 2025 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179399; cv=none; b=BPdKgsQ8DTmxjihhc0QgsRUltLH/XtU1I31zBYWTuEbIwlNCJpb1SRi31EPI7nA5r2maxXCODx2qUyL4BMrQQ0E1ZOsFDYYtnaK9G6WAssJgt/1wXwYcwP+EQZwvxhLJ1/XBGelAyyEKUlaoisihDgYYqnjY25XIGwUj+C5PKa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179399; c=relaxed/simple;
	bh=WfeON4poukMny33221lkE3pWOWhIycsdMJANlsZrJvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G702dWf/3eEPc4/dnyVcXSg7g7aRouXBqrBh+QmMsNg/AsIPpEuklbdSgJpYXtDTLiCEcEHVjhgSxqNpO5LJhThFqdlAfvXcPvjb4amv+LBcO15CT99JZYdWCvghGcsYRNw2ovxv2p2V9vmFVV8CK0+tEWVhofps+k6iyKnp8CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9WVKXu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9WVKXu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37F3C4CEE3;
	Tue, 17 Jun 2025 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179398;
	bh=WfeON4poukMny33221lkE3pWOWhIycsdMJANlsZrJvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9WVKXu8ubiNw0pNVjpHnYIljCIwRZ49hK43OuFl053pVLbRflUBCB4NZEQPVSxBY
	 OyMJIRc2IBt2tQmanbcFsAwhZ9VrjG5czY/gxdMn2POr9aj/e78YtQRro4kfhMLSGh
	 1lIphaPwnBQZe0B2Ac+dtscboAth90RF40DdQX9g=
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
Subject: [PATCH 6.15 732/780] block: use q->elevator with ->elevator_lock held in elv_iosched_show()
Date: Tue, 17 Jun 2025 17:27:20 +0200
Message-ID: <20250617152521.304523735@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b4d08026b02ce..dc4cadef728e5 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -744,7 +744,6 @@ ssize_t elv_iosched_store(struct gendisk *disk, const char *buf,
 ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 {
 	struct request_queue *q = disk->queue;
-	struct elevator_queue *eq = q->elevator;
 	struct elevator_type *cur = NULL, *e;
 	int len = 0;
 
@@ -753,7 +752,7 @@ ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 		len += sprintf(name+len, "[none] ");
 	} else {
 		len += sprintf(name+len, "none ");
-		cur = eq->type;
+		cur = q->elevator->type;
 	}
 
 	spin_lock(&elv_list_lock);
-- 
2.39.5



