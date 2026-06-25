Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D4A28640B;
	Thu, 25 Jun 2026 13:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393032; cv=none; b=H80Vm5+PuuNLbF38Zgvg6+bFmLQ0EeOZArFjrI8+wuThc29R0I++0SeMYSAk3UsxLeAl5haC9swWFgLqDBnFu2q36JK9hAYFHQ7WEDQBqli+OT9mUAIkcUz5bBG33Ql2T+uVt+5X1Gf8bG7X1zhIBQ7jNcfhZYqJHbK5zzOD/XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393032; c=relaxed/simple;
	bh=tF0/oRVYAAmNir0LoL0GKqgGC+FuZUqwSzL3j5LiAYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvWQGIUUzhLW8Vdva7L67va09U5wBdk239JfxqXMy9GQS6A/Lxj8lKviicGnmFpzpCcui6WIa/BfEQ44WLf05TKSU/FxFG5df/xV198WEUjWZO7HgcrAiTe2x2Zw2LRLhIPfiGbiX1EUe1OM8zFyigaVTuNuMu50JtjrvqjZ2Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oynWl09t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oynWl09t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35291F000E9;
	Thu, 25 Jun 2026 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393031;
	bh=5vmq2/y9MVgVBPpoJW7Y0bzvQSvtKQLaIuySx8snikQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oynWl09t6B3xg4y/j6QUK3xayWYSt7ha4thn7RWZaQ1i59B1u2xuEY7EYEHS2GKhM
	 3MEwl7dzS0mFUQvgGYxh8f0gCfQ8f65d/CgUE8FQ2pwfN2fyhxVn082YG/7UZ9N2j5
	 IOHhbJJgQBwgNvYQFY9znwJW9smkl3rjhqjz9QWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 21/49] rose: fix netdev double-hold in rose_rx_call_request()
Date: Thu, 25 Jun 2026 14:03:33 +0100
Message-ID: <20260625125640.448597542@linuxfoundation.org>
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

commit c675277c3ba0d2310e0825577d58308c39931e14 upstream.

rose_rx_call_request() used netdev_tracker_alloc() after assigning
make_rose->device, intending to take ownership of the reference passed
by the caller.  But every caller -- rose_route_frame() and
rose_loopback_timer() -- already calls dev_put() for its own hold after
the function returns, so the socket ended up with a tracker entry
pointing at a reference that had already been released.

The result was spurious refcount_t warnings ("saturated", "decrement
hit 0") on every incoming CALL_REQUEST, leading to refcount corruption
and eventual silent freeze.

Replace netdev_tracker_alloc() with netdev_hold() so that
rose_rx_call_request() acquires its own independent reference.  Each
caller retains its own hold from rose_dev_get() and releases it via
dev_put() as before; socket cleanup releases the socket's separate hold
via netdev_put().

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1079,9 +1079,11 @@ int rose_rx_call_request(struct sk_buff
 		make_rose->source_digis[n] = facilities.source_digis[n];
 	make_rose->neighbour     = neigh;
 	make_rose->device        = dev;
-	/* Caller got a reference for us. */
-	netdev_tracker_alloc(make_rose->device, &make_rose->dev_tracker,
-			     GFP_ATOMIC);
+	/* Take an independent reference for this socket; callers keep their
+	 * own reference (from rose_dev_get / dev_hold) and will release it
+	 * themselves via dev_put().
+	 */
+	netdev_hold(make_rose->device, &make_rose->dev_tracker, GFP_ATOMIC);
 	make_rose->facilities    = facilities;
 
 	rose_neigh_hold(make_rose->neighbour);


