Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216052;
	b=qIA6njybBE0vC7vTrsLAMtYLzPvqf5nqcfLfppRq3AeDueJGwMzUCgo31+d8hp5561Ua
	 amXP1ToBnj5M+S77g/IL62iExhRZspKJ/luV3nVqYhyrAnaHgLN9lqLLAR8xVCyGrNovD
	 qPsL1GKYQ9WIt74YSUaMhoC7789V3w6ILu4cS8DK7paWyQpu2J5fTZe8GIt9PKtBMPu0X
	 4lb8Uirt2Xug+vOX+t1I4kub0Y8GOV4N69APWYHzTHm/cASQOHoGGcbQ2x2/NyoUzG/d6
	 BThf42x+8cpuycWsJ3fFQUZwP0NGbO/F6Xa3O0ACuO/DoAgQe3eZU0Hq6gI0f6kaV1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vLnZV7aEIbsnuUano31ZaMt0zmOXI/sxe4Gdw32KwYc=;
	b=AYqGuX6Vi5gTnkRkAz9lYiZORpl3vmaK2B7Z9jkfJTwEqeRPdeyw0huqhrYMc9XPDPph
	 TMULfnfciNujwLs4dgxZOI46oBgKBM2/r4jmuQD7vaExfTJZDjPc4O8tQ0xCLfFGu0j8O
	 qW6QeDHNao7IVCMLORamd7QkgcTVbuLbrnwVjaRBQSpZIJN1f84rV6wyRG3nDd8+RGPfA
	 fPfLFVzrqqgLPWBqtr6x/dP/KuGaNerCMExCxofbthZsLrsBk/BM80JhE9tWcpkQ2+Fjt
	 6QCdX4B++z3x3zZk2Zp2m3ip9ztzvaKCtvmO4+wxGSNXnHi0c75CnICEaa+8aUNJg7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z8hAFmYj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCB0606A31A;
	Wed, 28 Oct 2026 19:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z8hAFmYj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903C31F01828;
	Wed, 28 Oct 2026 19:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216052;
	bh=vLnZV7aEIbsnuUano31ZaMt0zmOXI/sxe4Gdw32KwYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8hAFmYjLsz6lJqkqkc6Rs6ZRPsMFMjH7yZ9Hq/MQ9qHeQQKL7/xC33jKAYXt1blz
	 LXw4Itm+Gbmus22EdWwlcNqP34oEHlMQ/GQRMlNTNTryeXTkmx2qBkIfrslU6e55GK
	 q20H8BgeZe0EXGn4Qk2fN48E11jQBQ4m+u4xt0tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1425/1887] ceph: do not repeat ceph_trim_dentries() if no progress possible
Date: Wed, 28 Oct 2026 17:58:41 +0100
Message-ID: <20261028170531.886621384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit e7d7aa7b730178278109c41fa1b17b06873065d5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 67a9b735899bb..6b189276d7662 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1564,11 +1564,11 @@ static int __dir_lease_check(struct dentry *dentry, void *arg)
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
@@ -1595,7 +1595,7 @@ int ceph_trim_dentries(struct ceph_mds_client *mdsc)
 	lwc.dir_lease = false;
 	lwc.nr_to_scan  = CEPH_CAPS_PER_RELEASE * 2;
 	freed = __dentry_leases_walk(mdsc, &lwc, __dentry_lease_check);
-	if (!lwc.nr_to_scan) /* more invalid leases */
+	if (freed > 0 && !lwc.nr_to_scan) /* more invalid leases */
 		return -EAGAIN;
 
 	if (lwc.nr_to_scan < CEPH_CAPS_PER_RELEASE)
@@ -1605,6 +1605,10 @@ int ceph_trim_dentries(struct ceph_mds_client *mdsc)
 	lwc.expire_dir_lease = freed < count;
 	lwc.dir_lease_ttl = mdsc->fsc->mount_options->caps_wanted_delay_max * HZ;
 	freed +=__dentry_leases_walk(mdsc, &lwc, __dir_lease_check);
+	if (freed == 0 && count == 0)
+		/* no progress possible currently, retry futile */
+		return 0;
+
 	if (!lwc.nr_to_scan) /* more to check */
 		return -EAGAIN;
 
-- 
2.53.0



