Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A01633C1AD;
	Fri,  7 Aug 2026 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115685; cv=none; b=trXt7YAmuVceuzkFS1i+ADM7pYkUGI/I3VV4iS+wVijfAV2vnyhqoQtDzb2gjdVzqQSLvgzb29LLGKQdlXpMpDYbIUb19CQnnvu1KGF15w+RUzDOSXxsYhOmTUg7iWPGQ7Sum1yGY/XD0mzIGf0khttU32UXqceK5EZj4ofWh1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115685; c=relaxed/simple;
	bh=Sj6U1E3pISnUFTFg4HiRwBwUEUHIinNiT3xr+DaQnMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ad5uQ84pVVf5kcCGb6STECBLtnIoXrjjw1Tl0VvwVUFnZjsMoqnWIPTSWrcIc3flX7+1vf9nCo5oZrEjWvLUVguLtsc5xI5S5Kr7UtE7mfaa1dYzVouI6FjERb8+dL+2Dh2jVNaR4+n/c8x7X+Y9Jvty9yMfZUZdBNqyuVcS44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NuDEu1u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NuDEu1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15B31F000E9;
	Fri,  7 Aug 2026 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115684;
	bh=/mAZmXoVhMCF3DL7ZinmojOWqsqTuiQYWy1pF2NaorY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NuDEu1uUZ1zws5M5AQ0an/SjP8wVfq/bzwqOug2Ptb5z3ekBbdiv05M6LqyoSsGd
	 cLn4NvaHvJ47LqHPctXJpM3wpLkovpAyZIQMer8nZrJ5jIOqoTDvebaKPnSYC5jNia
	 vJrELs+zC7G7Ev9fUYLc0uKZbVqYlVhIQBi4slt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/396] net/handshake: Close the submit-side sock_hold race
Date: Fri,  7 Aug 2026 16:38:42 +0200
Message-ID: <20260807143432.092721150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5da98f55b13173c08f003011b76531b25c821c07 ]

handshake_req_submit() publishes the request via
handshake_req_hash_add() and __add_pending_locked(), drops
hn_lock, and calls handshake_genl_notify() (which can sleep)
before taking sock_hold() on req->hr_sk. A fast tlshd ACCEPT
followed by DONE can drive handshake_complete()'s sock_put()
into the window between the spin_unlock and the late
sock_hold(); on a system where the consumer's fd held the
only sk reference, the late sock_hold() then operates on an
sk whose refcount has reached zero.

The preceding two patches install an explicit file reference
on struct handshake_req. That file pins sock->file, which
pins the embedded struct socket, which defers inet_release()'s
sock_put(). As long as hr_file is held, sk cannot reach refcount
zero from the consumer side, and the submit-side sock_hold()
with its matching sock_put() calls in handshake_complete() and
handshake_req_cancel() is now redundant.

Drop all three. The file reference already keeps each request's
socket alive, and the lifetime story is contained in a single
get_file()/fput() pair.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260525-handshake-file-pin-v3-6-66c616906ead@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 5da98f55b13173c08f003011b76531b25c821c07)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/request.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/handshake/request.c b/net/handshake/request.c
index 4bf98793491aa..035bb2d7471c9 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -301,13 +301,6 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
 			goto out_err;
 	}
 
-	/*
-	 * Pin struct sock so sk_destruct does not run until the
-	 * handshake completion path releases it; struct socket is
-	 * held separately via hr_file above.
-	 */
-	sock_hold(req->hr_sk);
-
 	trace_handshake_submit(net, req, req->hr_sk);
 	return 0;
 
@@ -337,9 +330,6 @@ void handshake_complete(struct handshake_req *req, int status,
 		trace_handshake_complete(net, req, sk, status);
 		req->hr_proto->hp_done(req, status, info);
 
-		/* Handshake request is no longer pending */
-		sock_put(sk);
-
 		fput(file);
 	}
 }
@@ -387,8 +377,6 @@ bool handshake_req_cancel(struct sock *sk)
 out_true:
 	trace_handshake_cancel(net, req, sk);
 
-	/* Handshake request is no longer pending */
-	sock_put(sk);
 	fput(req->hr_file);
 	return true;
 }
-- 
2.53.0



