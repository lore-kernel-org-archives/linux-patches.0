Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959322FC4E;
	Fri, 24 Nov 2023 18:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pybRJV4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2650AC433C7;
	Fri, 24 Nov 2023 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852019;
	bh=NjOd1AEvJaexb9ShzvYckZYvJ2stydhb8UFzDXb4NNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pybRJV4dB52QoxUookkDgC4O+cuQ/lRsSgS3d0II4JfPo1EelklZqZqZI+dSl2JTJ
	 Mr0i+whmlTfrplltTsgqVzQrOkjeR84bts9o1p7p61RZ+GRtK2619dsie6EE9Ntpuw
	 CnV+4PkRA1gZvbozewFzFYQdE9+nhGsoswvR6FOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 187/372] mm/damon/sysfs: update monitoring target regions for online input commit
Date: Fri, 24 Nov 2023 17:49:34 +0000
Message-ID: <20231124172016.697270416@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 9732336006764e2ee61225387e3c70eae9139035 upstream.

When user input is committed online, DAMON sysfs interface is ignoring the
user input for the monitoring target regions.  Such request is valid and
useful for fixed monitoring target regions-based monitoring ops like
'paddr' or 'fvaddr'.

Update the region boundaries as user specified, too.  Note that the
monitoring results of the regions that overlap between the latest
monitoring target regions and the new target regions are preserved.

Treat empty monitoring target regions user request as a request to just
make no change to the monitoring target regions.  Otherwise, users should
set the monitoring target regions same to current one for every online
input commit, and it could be challenging for dynamic monitoring target
regions update DAMON ops like 'vaddr'.  If the user really need to remove
all monitoring target regions, they can simply remove the target and then
create the target again with empty target regions.

Link: https://lkml.kernel.org/r/20231031170131.46972-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2188,34 +2188,47 @@ destroy_targets_out:
 	return err;
 }
 
-static int damon_sysfs_update_target(struct damon_target *target,
-		struct damon_ctx *ctx,
-		struct damon_sysfs_target *sys_target)
+static int damon_sysfs_update_target_pid(struct damon_target *target, int pid)
 {
-	struct pid *pid;
-	struct damon_region *r, *next;
-
-	if (!damon_target_has_pid(ctx))
-		return 0;
+	struct pid *pid_new;
 
-	pid = find_get_pid(sys_target->pid);
-	if (!pid)
+	pid_new = find_get_pid(pid);
+	if (!pid_new)
 		return -EINVAL;
 
-	/* no change to the target */
-	if (pid == target->pid) {
-		put_pid(pid);
+	if (pid_new == target->pid) {
+		put_pid(pid_new);
 		return 0;
 	}
 
-	/* remove old monitoring results and update the target's pid */
-	damon_for_each_region_safe(r, next, target)
-		damon_destroy_region(r, target);
 	put_pid(target->pid);
-	target->pid = pid;
+	target->pid = pid_new;
 	return 0;
 }
 
+static int damon_sysfs_update_target(struct damon_target *target,
+		struct damon_ctx *ctx,
+		struct damon_sysfs_target *sys_target)
+{
+	int err;
+
+	if (damon_target_has_pid(ctx)) {
+		err = damon_sysfs_update_target_pid(target, sys_target->pid);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * Do monitoring target region boundary update only if one or more
+	 * regions are set by the user.  This is for keeping current monitoring
+	 * target results and range easier, especially for dynamic monitoring
+	 * target regions update ops like 'vaddr'.
+	 */
+	if (sys_target->regions->nr)
+		err = damon_sysfs_set_regions(target, sys_target->regions);
+	return err;
+}
+
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {


