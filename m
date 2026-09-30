Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2199852B1FB;
	Wed, 30 Sep 2026 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790527; cv=none; b=teD6OTq+H29GhwU+Muc4S+ZEV0nfbkJFbn9G2IADXz4t6E9viYiBqKwkBDksqDOHTMlyNa4zRFSmyqLK/BRS1HXXn/Z6qt5MRt3wDexLI05n9vt3Aiyt3EIMAuwXl6fsTjazJMM17+2WsEN+SaQMHwHyq6HL4q06cTcYmOOMYm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790527; c=relaxed/simple;
	bh=enbd3XE+0G7xZnqRNzmh1//4I3te/Oy4wkoEX+rsKKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2XjPbkNMUXxjOtXGv31+fjEIPelwIUeZkENZnk6T/M3pZO00+NKhnqp2debpm75YQdCiGQHX8nUNjc5PG5VH2UGT45QszHCWneAgkSIPKabmN6+/2R3VH3abfRNVzP6Xzsd44d/O16G0R21ClndGs67SuamaDZ91I7I2S/BQZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWxmUTGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWxmUTGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC631F000FF;
	Wed, 30 Sep 2026 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790526;
	bh=/cIJWVMpBaKdUeNqAZIbe3I8ojztSDQrIhByeuqQsRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWxmUTGaAXjmOtJjl+oY1RUTy+D3QetutjX4pLudJc+p2SWIt0+hHB4rju+n5bSO0
	 ael5wcQ++bI+eNqoeDtulmtDNhVhZZAQNXNmAP7wtfi9m4AsstKRDjmKUm+waRFg/v
	 8hR0WqyhM/VYH/1kKPuZhoGsXfr9J9clbOLkE5K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 859/877] rose: fix netdev double-hold in rose_rx_call_request()
Date: Wed, 30 Sep 2026 17:29:30 +0200
Message-ID: <20260930152433.275631832@linuxfoundation.org>
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


