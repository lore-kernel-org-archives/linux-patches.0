Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8432D94AF;
	Thu, 25 Jun 2026 13:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393045; cv=none; b=S5n8W2+d1Mvw0W49RLiVTe7bfEcf11JBGZSVZc6Yt4dDYuJKCijQEb7SO/EIV9BP83l9aaxNQTmoA0Qd3AyOO+0xJGcvftyo6q8WQB/pHFQLu9A8/BDvfwcO4SNtL4ytOXTKwneYl9BLNHlJmPP8HrDjgjYfMncUevPVx+elDA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393045; c=relaxed/simple;
	bh=uGd0KRmafnSu5AdV2hEqVkJgbIKFJulHHVC4pBHOiJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdiRVdYKKVcdyG+DBwG4/qEbyjnDiOQnskHGLqM2iNLjoLT4AU9Zq400q2ibVdz3wDM1nlZCtdwnYTTDOm06s/6fCmxg0gr0Nsb24cDceSLtW3dAqCsXCrCiga/9Nxu+GhcByZi7sONm3omZ6xMEDQ3oM+zUYdQKZrkbJ6gAl/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+mCzHgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+mCzHgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FB31F000E9;
	Thu, 25 Jun 2026 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393044;
	bh=kmSX2CV272tf/xWdGoL6/6yZrTMuKKnurWMSpMTBTvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+mCzHgVzyks1bUjvlj5PNzAOodrSAqQlZzGF9vA9txRJi6yb8c4es+7a2rohrSp8
	 FsM2WzxX1W6fNLKsrJlD1MUtAxU/AXwoto/SHdm6kAFEzVdAkPP/DgjyAOhkI8TYNZ
	 cj0mgEmp83DNYU58incnAE8nTgm8JCGaKPO6qYpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 25/49] rose: fix netdev double-hold in rose_make_new()
Date: Thu, 25 Jun 2026 14:03:37 +0100
Message-ID: <20260625125641.052593371@linuxfoundation.org>
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


