Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C162848A7;
	Thu, 25 Jun 2026 13:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392844; cv=none; b=ode8Y8GVyFNKERKq9jRC6D2YN0UxZU4OojqZC453nq2p0beWN2nLI5dn6W70U10U6Wbp8qvI6ZzIFZtlI2TiOghZC2QMd1mV3TJFFISPMiKCRA5J9maD/emdKZlh+rPiqeH6J4F6vpieKyLUGs1Dvd8q2maG36iODMGcEcfOHjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392844; c=relaxed/simple;
	bh=ZHpOgrBJGlx2JYK1p3hFsL24UEPylMZUCuuvWgytnDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZETkkN/a1A7yNWKyNIi/ffPj0hPXAyJj7fcSKsx2AkAIqTGlHpknS3nURc9XowJIGrVeeLabDdDT7vSq5FMinxTCnZR9h7BQutp0uMx4i+QuDBs1xD1439sBbrG5KQHL3Uy8DnARe87nAvWwUWJnMAOlNNpQ3xLkPRc7nxh7BJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUHZeju5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUHZeju5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2981F000E9;
	Thu, 25 Jun 2026 13:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392842;
	bh=jrJ57FHoffM1uKo+r86mPA/Sag89ZQv4a/RkrA0HoHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUHZeju5sLgzvk2ZbkXVhRvQie2a/HkVT0wiKkoWroLKO38y5bstkP1ezxfb2MTru
	 F0WYu1G4D1vdT1qRr45aIGBcViar8cmzUN011Nkiu0M4kAu1sBZp8g+lWxD+c/aIlY
	 g5b5nTi0VY5IbTeunWxpo5orqstGFna5Y0iugYZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 26/60] rose: cancel neighbour timers in rose_neigh_put() before freeing
Date: Thu, 25 Jun 2026 14:03:11 +0100
Message-ID: <20260625125649.365512610@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


