Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD922253EE;
	Thu, 25 Jun 2026 13:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393006; cv=none; b=o2as64hhrD8FVrBgdBZEq5GIb6+FTZc8hC+3Hso3guuMLzfMVBjx39Kti68eD0bpuYa9KpWcd9TSAmWJTeIFZYAL5EbnZZ/HeBXbIoXWBO02lEl5G7+7NhoidCB/pj/Zd0RVh1niXtQPdGtuiBVFbriBfXgElXojvX8Y1lelpT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393006; c=relaxed/simple;
	bh=wedskd2z1h9qz6lMNjBoh1ZcAV2+I7l4l4ONKBHs/Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPZVompW/zH7VgQhHDOPt40OQWZxhyTwA0jJqFwETiD2hqBK+xzOLpCL7lKuTf3LyeUi1uiVtdO5jJC+cgLsioVaJF8VbbatTGoJJZzeDkL0X4sZ/meukXbgNfpiay/qYFwQfDOoUr/QN2EcjLh3qj1ONSaDHoxHEG78qJTT78Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usCoZ6Yk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usCoZ6Yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AAF1F000E9;
	Thu, 25 Jun 2026 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393004;
	bh=B75b0xem9CKJ1Bjb3MaVcXa1zrfrT0iCP9R0Cq3eNS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usCoZ6Yk0LGDo+THWtgAdO6IdCtYTDcph9bF+UWIIPSvbJlt8RpccXVh83IlWtmuv
	 MJE48sw/DHJKczDCVKlwqXLT/zUNCR5kG+OBpB0XuXucy+Bz3ccQ2o39P+hxj+t6IL
	 +qqt8MKNONvNr67QUFb8na9+5v67EQhv5THdmu4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 28/49] rose: cancel neighbour timers in rose_neigh_put() before freeing
Date: Thu, 25 Jun 2026 14:03:40 +0100
Message-ID: <20260625125641.474020187@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit 9b222cb1d23ff210975e9df5ebab7b011acb6fad upstream.

rose_neigh_put() kfree()s the neighbour but never cancels its ftimer and
t0timer. Until now every caller that dropped the final reference first
called rose_remove_neigh(), which deletes those timers. The socket
heartbeat reaping path drops the last reference directly, so a neighbour
could be freed with t0timer still armed -- it re-arms itself in
rose_t0timer_expiry() -- leading to a use-after-free write in
enqueue_timer().

Cancel both timers with timer_delete_sync() (the synchronous variant, to
wait out a concurrently running, self-rearming handler) in the
refcount-zero branch of rose_neigh_put().

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/rose.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -160,6 +160,18 @@ static inline void rose_neigh_hold(struc
 static inline void rose_neigh_put(struct rose_neigh *rose_neigh)
 {
 	if (refcount_dec_and_test(&rose_neigh->use)) {
+		/* We are dropping the last reference, so we are about to free the
+		 * neighbour.  Its timers may still be armed -- t0timer in particular
+		 * re-arms itself in rose_t0timer_expiry().  rose_remove_neigh()
+		 * cancels them before its own put, but callers that drop the final
+		 * reference without first calling rose_remove_neigh() (the socket
+		 * heartbeat reaping path) would otherwise kfree() a neighbour with a
+		 * live timer -> use-after-free.  timer_delete_sync() (not the async
+		 * variant) is required: it waits out a concurrently running handler
+		 * and loops until the self-rearming timer stays stopped.
+		 */
+		timer_delete_sync(&rose_neigh->ftimer);
+		timer_delete_sync(&rose_neigh->t0timer);
 		if (rose_neigh->ax25)
 			ax25_cb_put(rose_neigh->ax25);
 		kfree(rose_neigh->digipeat);


