Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8384C1DF98B;
	Mon, 23 Jun 2025 21:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713226; cv=none; b=I54ot3r7SPO1HFBT7Gjxs4dqWYlln0DP1c3jNVdukgBRk8ISmL2+Ei71TSqG3kEaxZ9i5uBBG9TnSe904LPKBWyJOUGoBidLEKHeH6QXH406CRIJklo535q6K/F0WkHS2ETzlkMpSXv1V7ZXyYYJNPCxW9NDoAXzUUUA8CtZSc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713226; c=relaxed/simple;
	bh=xBr224TaNc/D1iBDAkGcAPHLkAMKlPwPcnLYLcdTJMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvfrhuqaQZOM/hNWIBcSXdq7D2XrXMrT+Hu2jC28MgVx29/cqk2HpjKVBgEctLPBv72bTSjGeYKBx9Fxxz9MjlscILm5VWVHiPf9r2yjaBKwVdK3uKnSQkIvmvCLhWsVNo4TYTL2cSx2FOssVO/alm5X8ZrxSu1LrxvrIS0xuyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQMGbXdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQMGbXdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A941C4CEEA;
	Mon, 23 Jun 2025 21:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713226;
	bh=xBr224TaNc/D1iBDAkGcAPHLkAMKlPwPcnLYLcdTJMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQMGbXdNunOFUE2w0d5Lz/pRZKcj3uGbI2K+zigBaLEa5vP30pvs5yVJPfcKvdx+f
	 /B1TSEdHeRG89f3FMyZOFf0PnlnurGZ2MYDZG6/97mEDjEmZix6BxwrlQeGFUkq3e/
	 6tnVJvD1dJMUCk79OxxvrFHCb3LRegue1pxJCY0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Sears <sjs@hammerspace.com>,
	Jakub Kacinski <kuba@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.12 033/414] SUNRPC: Prevent hang on NFS mount with xprtsec=[m]tls
Date: Mon, 23 Jun 2025 15:02:50 +0200
Message-ID: <20250623130642.855638549@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 0bd2f6b8996d4f1ca4573652454987826730a04a upstream.

Engineers at Hammerspace noticed that sometimes mounting with
"xprtsec=tls" hangs for a minute or so, and then times out, even
when the NFS server is reachable and responsive.

kTLS shuts off data_ready callbacks if strp->msg_ready is set to
mitigate data_ready callbacks when a full TLS record is not yet
ready to be read from the socket.

Normally msg_ready is clear when the first TLS record arrives on
a socket. However, I observed that sometimes tls_setsockopt() sets
strp->msg_ready, and that prevents forward progress because
tls_data_ready() becomes a no-op.

Moreover, Jakub says: "If there's a full record queued at the time
when [tlshd] passes the socket back to the kernel, it's up to the
reader to read the already queued data out." So SunRPC cannot
expect a data_ready call when ingress data is already waiting.

Add an explicit poll after SunRPC's upper transport is set up to
pick up any data that arrived after the TLS handshake but before
transport set-up is complete.

Reported-by: Steve Sears <sjs@hammerspace.com>
Suggested-by: Jakub Kacinski <kuba@kernel.org>
Fixes: 75eb6af7acdf ("SUNRPC: Add a TCP-with-TLS RPC transport class")
Tested-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtsock.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2743,6 +2743,11 @@ static void xs_tcp_tls_setup_socket(stru
 	}
 	rpc_shutdown_client(lower_clnt);
 
+	/* Check for ingress data that arrived before the socket's
+	 * ->data_ready callback was set up.
+	 */
+	xs_poll_check_readable(upper_transport);
+
 out_unlock:
 	current_restore_flags(pflags, PF_MEMALLOC);
 	upper_transport->clnt = NULL;


