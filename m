Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8E651AFF6;
	Wed, 30 Sep 2026 17:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790538; cv=none; b=lUdzBoCu47lakikdGhtOGnwxD2kzlgZM/YhoiTy8SHVHb8eg6Dp8Owp6JJa3DR01PBmk5iwYTa3HhgX6p5OgdynvXeWdiQaawG+gv8RMW77+Ecmw7OXw8ieIrfLVi6BeVm6Sd34/8o40lD2rh7J6BgjoDLHkL04gb2yuFRImKjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790538; c=relaxed/simple;
	bh=UXteuGVVxiNTGm0T4uSr8kefcd4kD9PNjTIq5xQjYJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zm3a7H/KmZLrOElLlITXmLpfOAgNKG0fsYPk7pcNKXm1P6sJmfTfcT+6eE0TudnL+QdmwKwaCnbfH2l/IyCD3Dkh78gAl1oD4/L7XvdqI4TQrYyHS0TIr59QfqIkzNE2yy3mgw0Yvgr+TjpQH1UEayq04oRAIEsOIraDUekf5SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDRKYLhn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDRKYLhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F2A1F000FF;
	Wed, 30 Sep 2026 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790537;
	bh=eckB75hCmW9r1ZEblGQ+JOyHWXC65uQS4Z8Yz/5ZKJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDRKYLhnDky0d00QVHzcWE6e6Rdm5GGYo67MLeYJ1G3kSYqxT/Vl7L4858eVBcBXo
	 xXyFaa/J4JwRag+maiW+Y8/NhCXolEWTjhBpWnqWaGPYL4dZKDqZy80X4egpj8FmvK
	 NPHyFvkQekb1qFIBS5auJPmw8O3sx8dyQWb8PTvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 863/877] rose: fix netdev double-hold in rose_make_new()
Date: Wed, 30 Sep 2026 17:29:34 +0200
Message-ID: <20260930152433.359888412@linuxfoundation.org>
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

commit b9fb21ceb4f0d043767a1eba60786ec84809033b upstream.

rose_make_new() copies orose->device from the listener socket and calls
netdev_hold(), storing the tracker in rose->dev_tracker.  The only
caller, rose_rx_call_request(), then overwrites both make_rose->device
and make_rose->dev_tracker with a fresh netdev_hold() for the actual
incoming-call device.

This orphans the tracker allocated by rose_make_new(): it remains in
the device's refcount_tracker list but no pointer exists to free it
via netdev_put().  The result is one spurious outstanding reference per
accepted CALL_REQUEST, visible at rmmod time as:

  ref_tracker: netdev@X has 2/2 users at
      rose_rx_call_request+0xba3/0x1d50 [rose]
      rose_loopback_timer+0x3eb/0x670 [rose]

The second entry is the orphaned tracker from rose_make_new(); the
first is the correctly-managed socket reference from rose_rx_call_request().

Fix: initialise rose->device to NULL in rose_make_new() and let
rose_rx_call_request() -- the sole caller -- assign the correct device
and take the sole netdev_hold() as it already does.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -631,9 +631,7 @@ static struct sock *rose_make_new(struct
 	rose->hb	= orose->hb;
 	rose->idle	= orose->idle;
 	rose->defer	= orose->defer;
-	rose->device	= orose->device;
-	if (rose->device)
-		netdev_hold(rose->device, &rose->dev_tracker, GFP_ATOMIC);
+	rose->device	= NULL;  /* rose_rx_call_request() sets this */
 	rose->qbitincl	= orose->qbitincl;
 
 	return sk;


