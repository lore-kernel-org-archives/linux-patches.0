Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D622852F27A;
	Wed, 30 Sep 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790547; cv=none; b=ZOzNTqlgXUWE3ntFoDd5pyhaZA0wyubrwrth90WYEnCBgljkSMnkXpbW3gkonQ3eTrQIwMjhsTzEzn+6thmMY+S3qTVtFyTduoQw3HHub/00rukhDQQOtD/xH8VSi5LOO3nHmhiMLyrj9iT5JfvrgZOlpN0EKq3ymZ+C4fhPP7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790547; c=relaxed/simple;
	bh=RtcvjS6deIS9yyQ6uuj33YjM+AvFXwaYWWTi7pVGN74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AB+P3UhmVnKSsvQbipbb5fQLhOKxXLiRvBukzn3GDSfhbkUvmi3GxGXCQFgdN9pdwLN7ikqGEyPJTcodG2S9FhtlIP3u8kxyhxcGKsvMtfpwljt2cdkDqvqrx9tySvjjZyhhBHXbg04inknbJtPHir5slJB7NFzKb1nyZ5uhyIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjNqFJgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjNqFJgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1971F000FF;
	Wed, 30 Sep 2026 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790545;
	bh=dqVFSPxbaTA6ZtH7Slbao5qGn5zLXSNgG3txJIzIgmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjNqFJgkta6KnO7q+5hdrqm8g5k6Apuxg0Xk77HbN2gkETSxHb+S8FkMGRJKorbLA
	 oiYnfWTPUuTCZmpCc5KylQvz3pS78XcXs6CDh+pnMjthHqu6y5f3CyLhK5DXiSU71j
	 Mfg/jFmMVhRgme6KVGAqmFP0ucaKnWJPwxAfMvfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 866/877] rose: cancel neighbour timers in rose_neigh_put() before freeing
Date: Wed, 30 Sep 2026 17:29:37 +0200
Message-ID: <20260930152433.422386624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


