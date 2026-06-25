Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A233528751B;
	Thu, 25 Jun 2026 13:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392774; cv=none; b=ZKm8SJ1wiSK5eJJDy/xtp9SZUmY0gUsHp+k6kn0eB+U5G8c7/mw6Fy++GbxZ6kEyFlk797HkRIqPX0D0UC/TyzQ/a385F8SmQQnVcErQmhoebmo9OBz0Jp47UHrp5wU6oYKraRKNyEaGgK7hkX2Fa7zvZ3pvi+z2HQJ2ZJeKnfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392774; c=relaxed/simple;
	bh=dv093LzPFyea7NcOgtfJycCKzCjQheFZAw+l9INRx8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzv50Tjx0Rkv6Pao16+W6FQwaKZwnkEwS6y7gYyrMGKw+QxS0OXq02+Tk3/NItA7lEtSM4zRFgItBJNWYrQCzNudNwnElS/EF38RhkZzlznA9ZJwe4zy3FzNz74mmN+hbHRQ7MG+fC9+UmG4cByu/vyCF1NLpq4+Di9Zs7m5mgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGkZEOWf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGkZEOWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E411F000E9;
	Thu, 25 Jun 2026 13:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392773;
	bh=URR9NyxMbe3CqJMsrj9kuZRrD+Kom+xlGQgS+lpYtjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGkZEOWfiO4bfqSIJVXk03vtak4RfyjpQaoJlFJfF/Cf2ACfBUV9oiPYxn/HHcP5X
	 BYl2mjJX/HBWN3y34Nm2wufQeCfLT8dIcrIwcyUF1Ma3MNvkIIIOk11v3KIpKLSdh9
	 NnFdEJtEYOr8XkpqPhSqmV8Yz3InqxJ1w4098bhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 19/60] rose: fix netdev double-hold in rose_rx_call_request()
Date: Thu, 25 Jun 2026 14:03:04 +0100
Message-ID: <20260625125648.362185651@linuxfoundation.org>
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
@@ -1078,9 +1078,11 @@ int rose_rx_call_request(struct sk_buff
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


