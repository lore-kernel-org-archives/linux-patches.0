Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F748359F99;
	Fri,  9 Jan 2026 12:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960397; cv=none; b=PQfN7DsA7s5mTqQm9MYJA7pdQq11xG77cPcW1cW9csM5xp+FgjoemAb1khvR3QX2VbhtJI2u/6vr1m4gBIP6jcM89VGC5edqMKbCmHl/KFFJ+hRANerL4lDeOEOBLuGnhHOWXQsKUpm+Zg8eybsxYRVJGoDwTZlaiMt4iA5nULs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960397; c=relaxed/simple;
	bh=GKnUI5ICdQ5/w5l68qXilXw9Z1TNyvfRN8tMDuKpjYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW9GdNahiQ3ImRdTJclKJASR3p/hNeO03VDy9uoGtprmJz4mgtFJQCbBRYBLswfQBrJ7BjO6i4/2WvdBI7Y9KWwPWaJhujZIvlZCMhIQljdd2q9Wo5nWO0jmUbJf771tD7pKBhCyRdvKyGC+BuCOsNAK8dI1D8SXoqn1Rysdd38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHm1BjBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHm1BjBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3227C4CEF1;
	Fri,  9 Jan 2026 12:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960397;
	bh=GKnUI5ICdQ5/w5l68qXilXw9Z1TNyvfRN8tMDuKpjYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHm1BjBYEydPj4ZbZQ3KTwx3FsbntyNH+7qBuGpJd+6CTKzZEh1Xq0POg0SZwRFjq
	 bPTafFi7CXavHQtyPvweNqHLaYX9fcD3RX8FrTpExS0Vq9xbDs1fuASDi0BmIOG8Mu
	 IbGYdoi67XvUpfBPVguyhJRzPvApD8pLtuHlNU7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 356/737] net/handshake: duplicate handshake cancellations leak socket
Date: Fri,  9 Jan 2026 12:38:15 +0100
Message-ID: <20260109112147.387460494@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 15564bd67e2975002f2a8e9defee33e321d3183f ]

When a handshake request is cancelled it is removed from the
handshake_net->hn_requests list, but it is still present in the
handshake_rhashtbl until it is destroyed.

If a second cancellation request arrives for the same handshake request,
then remove_pending() will return false... and assuming
HANDSHAKE_F_REQ_COMPLETED isn't set in req->hr_flags, we'll continue
processing through the out_true label, where we put another reference on
the sock and a refcount underflow occurs.

This can happen for example if a handshake times out - particularly if
the SUNRPC client sends the AUTH_TLS probe to the server but doesn't
follow it up with the ClientHello due to a problem with tlshd.  When the
timeout is hit on the server, the server will send a FIN, which triggers
a cancellation request via xs_reset_transport().  When the timeout is
hit on the client, another cancellation request happens via
xs_tls_handshake_sync().

Add a test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED) in the pending cancel
path so duplicate cancels can be detected.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Suggested-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20251209193015.3032058-1-smayhew@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/request.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/handshake/request.c b/net/handshake/request.c
index 94d5cef3e048b..0ac126b0add60 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -325,7 +325,11 @@ bool handshake_req_cancel(struct sock *sk)
 
 	hn = handshake_pernet(net);
 	if (hn && remove_pending(hn, req)) {
-		/* Request hadn't been accepted */
+		/* Request hadn't been accepted - mark cancelled */
+		if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
+			trace_handshake_cancel_busy(net, req, sk);
+			return false;
+		}
 		goto out_true;
 	}
 	if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
-- 
2.51.0



