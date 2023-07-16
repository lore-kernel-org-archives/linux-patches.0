Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D038F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8691CC433C8;
	Sun, 16 Jul 2023 20:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541080;
	bh=y/EoI4KziwaiscMxShkNHscVQPz8OttEbzjiuxCsC2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1go+FPRFx6qxeHglmIgRQ0KABvJPwL2p34Fz2nZBR5YQZus2o6uQb/vA5KvrstD9
	 usRFWMC1Ne7IAyiY2vO0DC+8Qum9gIFKHspnEru/ojrmvhNyJDtyo8USorBjsr7yGC
	 65BsHN4zm8E7dBSWZKlTsMX3VwxK62JzghMDDTkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 582/591] blk-cgroup: Reinit blkg_iostat_set after clearing in blkcg_reset_stats()
Date: Sun, 16 Jul 2023 21:52:01 +0200
Message-ID: <20230716194938.912863484@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

commit 3d2af77e31ade05ff7ccc3658c3635ec1bea0979 upstream.

When blkg_alloc() is called to allocate a blkcg_gq structure
with the associated blkg_iostat_set's, there are 2 fields within
blkg_iostat_set that requires proper initialization - blkg & sync.
The former field was introduced by commit 3b8cc6298724 ("blk-cgroup:
Optimize blkcg_rstat_flush()") while the later one was introduced by
commit f73316482977 ("blk-cgroup: reimplement basic IO stats using
cgroup rstat").

Unfortunately those fields in the blkg_iostat_set's are not properly
re-initialized when they are cleared in v1's blkcg_reset_stats(). This
can lead to a kernel panic due to NULL pointer access of the blkg
pointer. The missing initialization of sync is less problematic and
can be a problem in a debug kernel due to missing lockdep initialization.

Fix these problems by re-initializing them after memory clearing.

Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230606180724.2455066-1-longman@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -544,8 +544,13 @@ static int blkcg_reset_stats(struct cgro
 			struct blkg_iostat_set *bis =
 				per_cpu_ptr(blkg->iostat_cpu, cpu);
 			memset(bis, 0, sizeof(*bis));
+
+			/* Re-initialize the cleared blkg_iostat_set */
+			u64_stats_init(&bis->sync);
+			bis->blkg = blkg;
 		}
 		memset(&blkg->iostat, 0, sizeof(blkg->iostat));
+		u64_stats_init(&blkg->iostat.sync);
 
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];


