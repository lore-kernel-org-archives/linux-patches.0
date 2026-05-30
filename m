Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A35F25B0B3;
	Sat, 30 May 2026 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165517; cv=none; b=sQ4dYRIGLnSagIzRTLSHd3hcwUbT+yDBmQtJ9AVKbgFqrYTjzSyhCxY2AX5CGMyonSEbFpu6a5TkzyXJul/y9gsnx7oRwh9wEUHt070ZbmzBwxb79xDe8njAPAu2tuVsW3xdZXMv7IUyS6vaEz3s1ep9MKJFBZrIjpy7xX/q4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165517; c=relaxed/simple;
	bh=YLTCxmlRXm9tuMnRsvz2mnt2Uh1EDf1EMqbdPnT2PQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZByehfN6gRbm7VtSfhvty55+VXf1MTrk0Qckv3pxYiZyf2aiJA34gxSI5v+JSxDDlPs/VArqZjqG0EUnKeNbcamhmr1u0XKnStyhg5WGa9Ys/Ei31TCIhPKcX4wAcyCcsW5milXR/SfiF+BHLeb2q64QEZqulJlId07M+hpPUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0qUj6Rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0qUj6Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEC51F00893;
	Sat, 30 May 2026 18:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165516;
	bh=ADUOyzuBEp37s4vrHYCm5gY1zk3rJ7eM7HYjl85WLUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0qUj6Rhj662YJrLyZl5V3YcTfgnZ2ND5v2lHxfdzM6NygwFlxBj39DZfV8YEt/E/
	 J0XdIkIUHcX5YwNZjGq3Iqx/XkFJIMhNjQ9+1H9SRIHZm3HSvKkMyQ8vVfjHXVS522
	 zgsaZQlgxc7QhKTBACWa7tHxuBg3Lg8oih5hcWzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alva Lan <alvalan9@foxmail.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/589] blk-cgroup: Reinit blkg_iostat_set after clearing in blkcg_reset_stats()
Date: Sat, 30 May 2026 17:59:35 +0200
Message-ID: <20260530160227.165115952@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 3d2af77e31ade05ff7ccc3658c3635ec1bea0979 ]

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
[ Remove this line: bis -> blkg = blkg for blkg was introduced by commit
  3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()") since v6.2. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 0561aa6033dd181594116d705c41fc16e97161a2)
[ kovalev: bp to fix CVE-2023-53421 ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index dbd18b75ec915..7ffdc3360a6c2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -464,8 +464,12 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 			struct blkg_iostat_set *bis =
 				per_cpu_ptr(blkg->iostat_cpu, cpu);
 			memset(bis, 0, sizeof(*bis));
+
+			/* Re-initialize the cleared blkg_iostat_set */
+			u64_stats_init(&bis->sync);
 		}
 		memset(&blkg->iostat, 0, sizeof(blkg->iostat));
+		u64_stats_init(&blkg->iostat.sync);
 
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];
-- 
2.53.0



