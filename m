Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFEE378838;
	Fri,  4 Sep 2026 06:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502184; cv=none; b=cTi257KJd375HLrY4oNwGTKTeGs2Lue/c/raOKRceKre55P5OaOhb6bvd0oF6lyiMQfPYTmQtYD9Lr0vj+jApRbBTytqCgt+n2FcNCI+uselY9BQCr/fXJHb0J6HRHL66PlyXluoT9qpz6ohkXIWrh8VpQXM+j0O2dsWE1gQibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502184; c=relaxed/simple;
	bh=tizPmMZIE9XLtpgwzCurbm/dF28Y8V61+4MRPXMP2vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGO07U3lptqPOjInzv0I96dzQoHAGgLLWq95kZpSf8iyN0t0ntza5otd0BvWP3we8e8EYDIdjzlEmsHyPCtYZ2iCvPo7MLwOOns+yTKrk77N0ZGzOxLkaICFoq2z74U6jeH8xer93545g72dVnhsbPCxjYry5u05oveI/VrbsbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ifskTSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ifskTSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C17F1F00A3E;
	Fri,  4 Sep 2026 06:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502182;
	bh=GCAQcVerLiySPlBFsR5EmmHEtt/t7f0Hs0ct5nm5wn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ifskTSt8eow+7owkSrkFRDCSxoU5Ij9cpRr5RNpvysb1LJ6GusPP0zs+Ap4O/mko
	 GBTHIV20iDdYd7Rljj3pfX6jVe97Dvy/sSGm8+I0aBkfPSPSTUZMORnAK5jYl7dfZS
	 K8MworiaAn1S64pMRabjrMxM+xhoN0rYeZoPAy9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 117/403] ceph: do not repeat ceph_trim_dentries() if no progress possible
Date: Fri,  4 Sep 2026 06:58:40 +0200
Message-ID: <20260904045737.494254989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit e7d7aa7b730178278109c41fa1b17b06873065d5 upstream.

ceph_cap_reclaim_work() re-queues itself for as long as
ceph_trim_dentries() returns -EAGAIN, which happens whenever a lease
walk exhausts its `nr_to_scan` budget.  This creates a busy loop that
consumes CPU without making any progress when there is nothing to
reclaim: with no cap pressure (`count==0`) and every scanned lease
still valid, each pass runs the full scan budget down to zero and
returns `-EAGAIN`, only to be queued again immediately.

The dir-lease walk made this worse.  When `expire_dir_lease` is
`false` (i.e. we have no intention of reclaiming dir leases),
__dir_lease_check() returned `TOUCH` for every valid lease.  `TOUCH`
moves the dentry to the tail of the list and resets `di->time` via
__dentry_dir_lease_touch(), so a walk over N valid leases pointlessly
rewrote the list, refreshed the timestamps (preventing them from ever
aging out) and always drained `nr_to_scan`, guaranteeing the `-EAGAIN`
requeue.

Fix this in three steps:

 - Return `KEEP` instead of `TOUCH` when `expire_dir_lease` is
   `false`.  If we are not going to reclaim the lease, leave it in
   place instead of churning the list and resetting its timestamp; the
   walk then terminates naturally (or via `STOP` at the first fresh
   lease).

 - Only return `-EAGAIN` from the first (dentry-lease) walk when something
   was actually freed.  A full batch that frees nothing means retrying
   the same list immediately is futile; fall through to the dir-lease
   walk instead.

 - After both walks, bail out with success (0) when nothing was freed
   and there is no cap pressure (`count==0`).  There is no reason to
   keep retrying when we are not over the cap limit and made no
   progress.

Under real cap pressure (`count>0`) the reclaim path is unchanged and
still retries via `-EAGAIN`.

Without this patch, I saw 500 ceph_trim_dentries() calls per second on
our web servers.  This is very visible in `/proc/lock_stat` (5 minute
capture):

              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg

 &mdsc->dentry_list_lock:        126180         128218           0.04        8063.44    15986965.20         124.69        1573354        5296812           0.04        8291.28    74164526.48          14.00
 -----------------------
 &mdsc->dentry_list_lock         111736          [<000000007b11e319>] __ceph_dentry_dir_lease_touch+0x7c/0xa8
 &mdsc->dentry_list_lock           2631          [<0000000050597999>] __dentry_leases_walk+0x64/0x2c8
 &mdsc->dentry_list_lock           3878          [<00000000c0022f62>] __ceph_dentry_lease_touch+0x5c/0xa8
 &mdsc->dentry_list_lock           9973          [<000000002f27cb6f>] __dentry_lease_unlist+0x50/0xa0
 -----------------------
 &mdsc->dentry_list_lock         123621          [<0000000050597999>] __dentry_leases_walk+0x64/0x2c8
 &mdsc->dentry_list_lock           1822          [<000000007b11e319>] __ceph_dentry_dir_lease_touch+0x7c/0xa8
 &mdsc->dentry_list_lock           2720          [<000000002f27cb6f>] __dentry_lease_unlist+0x50/0xa0
 &mdsc->dentry_list_lock             55          [<00000000c0022f62>] __ceph_dentry_lease_touch+0x5c/0xa8

With this patch:

              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg

 &mdsc->dentry_list_lock:          1203           1215           0.16         408.88       33082.88          27.23        4320501        7357389           0.04         500.64     1961578.00           0.27
 -----------------------
 &mdsc->dentry_list_lock           1029          [<000000003c9aea8a>] __ceph_dentry_dir_lease_touch+0x7c/0xa8
 &mdsc->dentry_list_lock            169          [<000000002038c577>] __dentry_lease_unlist+0x50/0xa0
 &mdsc->dentry_list_lock             16          [<00000000c991106d>] __ceph_dentry_lease_touch+0x5c/0xa8
 &mdsc->dentry_list_lock              1          [<00000000612fe15f>] __dentry_leases_walk+0x64/0x2c8
 -----------------------
 &mdsc->dentry_list_lock            158          [<000000002038c577>] __dentry_lease_unlist+0x50/0xa0
 &mdsc->dentry_list_lock            858          [<000000003c9aea8a>] __ceph_dentry_dir_lease_touch+0x7c/0xa8
 &mdsc->dentry_list_lock            182          [<00000000612fe15f>] __dentry_leases_walk+0x64/0x2c8
 &mdsc->dentry_list_lock             17          [<00000000c991106d>] __ceph_dentry_lease_touch+0x5c/0xa8

__dentry_leases_walk() is almost gone.  The total wait time is reduced
by a factor of 483.  That will give some latency gains to
ceph_readdir().

Cc: stable@vger.kernel.org
Fixes: 37c4efc1ddf9 ("ceph: periodically trim stale dentries")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/dir.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1755,11 +1755,11 @@ static int __dir_lease_check(const struc
 	if (ret > 0) {
 		if (time_before(jiffies, di->time + lwc->dir_lease_ttl))
 			return STOP;
+		if (!lwc->expire_dir_lease)
+			return KEEP;
 		/* Move dentry to tail of dir lease list if we don't want
 		 * to delete it. So dentries in the list are checked in a
 		 * round robin manner */
-		if (!lwc->expire_dir_lease)
-			return TOUCH;
 		if (dentry->d_lockref.count > 0 ||
 		    (di->flags & CEPH_DENTRY_REFERENCED))
 			return TOUCH;
@@ -1786,7 +1786,7 @@ int ceph_trim_dentries(struct ceph_mds_c
 	lwc.dir_lease = false;
 	lwc.nr_to_scan  = CEPH_CAPS_PER_RELEASE * 2;
 	freed = __dentry_leases_walk(mdsc, &lwc);
-	if (!lwc.nr_to_scan) /* more invalid leases */
+	if (freed > 0 && !lwc.nr_to_scan) /* more invalid leases */
 		return -EAGAIN;
 
 	if (lwc.nr_to_scan < CEPH_CAPS_PER_RELEASE)
@@ -1796,6 +1796,10 @@ int ceph_trim_dentries(struct ceph_mds_c
 	lwc.expire_dir_lease = freed < count;
 	lwc.dir_lease_ttl = mdsc->fsc->mount_options->caps_wanted_delay_max * HZ;
 	freed +=__dentry_leases_walk(mdsc, &lwc);
+	if (freed == 0 && count == 0)
+		/* no progress possible currently, retry futile */
+		return 0;
+
 	if (!lwc.nr_to_scan) /* more to check */
 		return -EAGAIN;
 


