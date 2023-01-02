Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70A28EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44753C433EF;
	Mon,  2 Jan 2023 11:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658893;
	bh=tMJAIonPVg31dWyinuJ+fAMNiUIzYDiOZiuP5WFhTJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5+Y792egWOGUSU1GfrIVV5SmwPJ012Fh9HUvUjZbSbyqwl+vzONPpkKsjYFq7uDo
	 neKmLza9W0UBAG3m48xJWKC86OgG+LZMk9iZzCA2yuEyXMDafvd0wI9jq8hqJvG89R
	 dXLDBF8w696cfJ7vXs9C+r+MoXB3LJXpexXdzrOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	darklight2357@icloud.com,
	Josef Bacik <josef@toxicpanda.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 09/74] blk-iolatency: Fix memory leak on add_disk() failures
Date: Mon,  2 Jan 2023 12:21:42 +0100
Message-Id: <20230102110552.435540001@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 813e693023ba10da9e75067780f8378465bf27cc ]

When a gendisk is successfully initialized but add_disk() fails such as when
a loop device has invalid number of minor device numbers specified,
blkcg_init_disk() is called during init and then blkcg_exit_disk() during
error handling. Unfortunately, iolatency gets initialized in the former but
doesn't get cleaned up in the latter.

This is because, in non-error cases, the cleanup is performed by
del_gendisk() calling rq_qos_exit(), the assumption being that rq_qos
policies, iolatency being one of them, can only be activated once the disk
is fully registered and visible. That assumption is true for wbt and iocost,
but not so for iolatency as it gets initialized before add_disk() is called.

It is desirable to lazy-init rq_qos policies because they are optional
features and add to hot path overhead once initialized - each IO has to walk
all the registered rq_qos policies. So, we want to switch iolatency to lazy
init too. However, that's a bigger change. As a fix for the immediate
problem, let's just add an extra call to rq_qos_exit() in blkcg_exit_disk().
This is safe because duplicate calls to rq_qos_exit() become noop's.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: darklight2357@icloud.com
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Cc: stable@vger.kernel.org # v4.19+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/Y5TQ5gm3O4HXrXR3@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cd682fe46d2f..ee517fb06aa6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -33,6 +33,7 @@
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
+#include "blk-rq-qos.h"
 
 /*
  * blkcg_pol_mutex protects blkcg_policy[] and policy [de]activation.
@@ -1299,6 +1300,7 @@ int blkcg_init_disk(struct gendisk *disk)
 void blkcg_exit_disk(struct gendisk *disk)
 {
 	blkg_destroy_all(disk);
+	rq_qos_exit(disk->queue);
 	blk_throtl_exit(disk);
 }
 
-- 
2.35.1



