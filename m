Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FE3433BCA;
	Tue, 21 Jul 2026 21:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668101; cv=none; b=WjYo6Vf1wW0AJTwNvnMyxjMwMVyRogeQW1xLenfc7F+IWHmVx4ZJnOI09KB/pbThRGaR+lGUgMj7zfVgx3xhLx57g8p3g7luPMMic64pSPcfyr7GdsO0p+owLcpTu3BTtGe3LJAQulx1g42mMmqhnb6bLmoCvLxgNoLRscnwznk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668101; c=relaxed/simple;
	bh=YmY2gE+SFBn/OKEdvL1x3uy56DEaNvWtZ6WvhPYrgms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrDBN7buAKkIsmjFSRcMhZI6UxsW7A7DbYfp/OicaC9HSl0DYzkdL0t6lPeWxfbPxZBT7Ej0isp53lqosHcbnX0FVb5w8BXCAx1kvhxluqDIjFhYroBdzxTIS+5ovKZhEIN+mlUREcJZW75IthBnD5yLZt753NSWu1BtbL6bwCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLJi4pC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLJi4pC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AAE1F000E9;
	Tue, 21 Jul 2026 21:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668100;
	bh=Xo0UqODDeblbTmVsKYUHZn610zYUgFcBQ2XNwOLfN/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLJi4pC9qyuYapyLmUadqQoGYqyy/v4243aTTlS9e7M0glXyw1gjysHeP78OZMDt6
	 3na1692qq/l7kOnJ2Dsf7B9SPy/4bTuSTrDjQJoUdid/ZZvvU9kewGHuWUKyN4Elrv
	 E5mDbXoycg78QqN4lTsFwOvkGsR9UjcjATfMAK28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	carnil@debian.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.1 0046/1067] eventpoll: fix ep_remove struct eventpoll / struct file UAF
Date: Tue, 21 Jul 2026 17:10:47 +0200
Message-ID: <20260721152425.590221009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a6dc643c69311677c574a0f17a3f4d66a5f3744b ]

ep_remove() (via ep_remove_file()) cleared file->f_ep under
file->f_lock but then kept using @file inside the critical section
(is_file_epoll(), hlist_del_rcu() through the head, spin_unlock).
A concurrent __fput() taking the eventpoll_release() fastpath in
that window observed the transient NULL, skipped
eventpoll_release_file() and ran to f_op->release / file_free().

For the epoll-watches-epoll case, f_op->release is
ep_eventpoll_release() -> ep_clear_and_put() -> ep_free(), which
kfree()s the watched struct eventpoll. Its embedded ->refs
hlist_head is exactly where epi->fllink.pprev points, so the
subsequent hlist_del_rcu()'s "*pprev = next" scribbles into freed
kmalloc-192 memory.

In addition, struct file is SLAB_TYPESAFE_BY_RCU, so the slot
backing @file could be recycled by alloc_empty_file() --
reinitializing f_lock and f_ep -- while ep_remove() is still
nominally inside that lock. The upshot is an attacker-controllable
kmem_cache_free() against the wrong slab cache.

Pin @file via epi_fget() at the top of ep_remove() and gate the
critical section on the pin succeeding. With the pin held @file
cannot reach refcount zero, which holds __fput() off and
transitively keeps the watched struct eventpoll alive across the
hlist_del_rcu() and the f_lock use, closing both UAFs.

If the pin fails @file has already reached refcount zero and its
__fput() is in flight. Because we bailed before clearing f_ep,
that path takes the eventpoll_release() slow path into
eventpoll_release_file() and blocks on ep->mtx until the waiter
side's ep_clear_and_put() drops it. The bailed epi's share of
ep->refcount stays intact, so the trailing ep_refcount_dec_and_test()
in ep_clear_and_put() cannot free the eventpoll out from under
eventpoll_release_file(); the orphaned epi is then cleaned up
there.

A successful pin also proves we are not racing
eventpoll_release_file() on this epi, so drop the now-redundant
re-check of epi->dying under f_lock. The cheap lockless
READ_ONCE(epi->dying) fast-path bailout stays.

Fixes: 58c9b016e128 ("epoll: use refcount to reduce ep_mutex contention")
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-6-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
(cherry picked from commit a6dc643c69311677c574a0f17a3f4d66a5f3744b)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -801,22 +801,26 @@ static bool ep_remove_epi(struct eventpo
  */
 static void ep_remove(struct eventpoll *ep, struct epitem *epi)
 {
-	struct file *file = epi->ffd.file;
+	struct file *file __free(fput) = NULL;
 
 	lockdep_assert_irqs_enabled();
 	lockdep_assert_held(&ep->mtx);
 
 	ep_unregister_pollwait(ep, epi);
 
-	/* sync with eventpoll_release_file() */
+	/* cheap sync with eventpoll_release_file() */
 	if (unlikely(READ_ONCE(epi->dying)))
 		return;
 
-	spin_lock(&file->f_lock);
-	if (epi->dying) {
-		spin_unlock(&file->f_lock);
+	/*
+	 * If we manage to grab a reference it means we're not in
+	 * eventpoll_release_file() and aren't going to be.
+	 */
+	file = epi_fget(epi);
+	if (!file)
 		return;
-	}
+
+	spin_lock(&file->f_lock);
 	ep_remove_file(ep, epi, file);
 
 	if (ep_remove_epi(ep, epi))


