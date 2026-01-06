Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A96634CFBD;
	Tue,  6 Jan 2026 17:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720008; cv=none; b=sgwSabvzLdwHTxWOryYQlIZBCbdjJnWuFVfs9WOAq0bg5P+WVhuKxmH0kVzJ0nvAiD7+5p+LlrGs1cs9XBFfxtv8plcNHufKuaKwwiYauNOcF4yT0wDDPIVvLbU2SCFsSlGN72ACEPHrppEO5Ten2yJWx2uJxfRq/YSifASMR/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720008; c=relaxed/simple;
	bh=WN8lI+6zStsNOlyUlz2aw3FBQ+xoxhOKCklqEOqjGeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQd7JC+A+epANJAub/Owjp9n8Xk6+kKH1tserVQnYTqS0Ly/80j9N5t1cwlu7ABujP071NP2LXV3+XRPYfn3pBxiRjUnmw0v3zN9W38C7ngxwdY968MO2hr0QzIZ7yn5MPnvJG5OgIRfrbISwegLNDNCq78fsNDPUTcJsr2Df2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mpr3H7Fb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mpr3H7Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42183C116C6;
	Tue,  6 Jan 2026 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720004;
	bh=WN8lI+6zStsNOlyUlz2aw3FBQ+xoxhOKCklqEOqjGeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mpr3H7FbX9wNQW2SZKhu3P/+rRfKU4tQanYf3+dzbQjnZqQc3leBZDDkzT1O3ztCC
	 JcH8yJfhekpWy1rDB/0vWoVSk9Kt/+Q7tFDnFR4z1wUBOgOlTSZFt8nPcLHpP8SxSK
	 fTUNIX6Hf5mLODemQ8/zprFfcMBZsRRqPnbSMB8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/567] net/handshake: duplicate handshake cancellations leak socket
Date: Tue,  6 Jan 2026 17:57:35 +0100
Message-ID: <20260106170454.035193064@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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



