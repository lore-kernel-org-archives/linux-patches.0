Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FA04C6E;
	Mon, 23 Jun 2025 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686022; cv=none; b=tKnlGn3x42Xu7gsfZP3p+xBQRo47Uzo3SaccIg86SsOjElsA1ZXwNdxHZhhW3aSBb4C8ofqtZMOATWah79cuvFw42pOvK6haDSaH8B+1DytmhOO/xjifpN37Mj6XH5OEJe+AX8kYX1zzg2GwVvix7BT3SQSKhGlMwzl/3W7+2L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686022; c=relaxed/simple;
	bh=HK03IS5nRIz2NAxuwJ+5FCIHuMoozhcXnlcCsENU+Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Epol5ezc/3SpG4HN/EG19EE+SO6YsZ3WzEZmpU+/1OCzKRhDdKl0jobVUXY/cllp+sC63n6IZjU+08mGi8MNLbTYiNsy7ZHOSdUwCLHl8HXPKuIuvfHjMuEczH/tPZldU0VsXC2eFwzce9sdZRg0ZsQXlhtrJynFyV34R2RYWxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7TShvdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7TShvdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39827C4CEF1;
	Mon, 23 Jun 2025 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686022;
	bh=HK03IS5nRIz2NAxuwJ+5FCIHuMoozhcXnlcCsENU+Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7TShvdD5u5ElKNq6pbV1ssO/czWVf86ddQGcsXokzLnEJjEg0w7B85q8ZaZh2C9t
	 ee68/y7t1gCaceVy1ITiikILfcA2e18GbuOn1jQBsD71qrD+nnbkYFpu55iYVVn2dw
	 Jmv1q3PWq3WVxAWwGJpoWhtOzrxQ089d6EXAwdB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Sears <sjs@hammerspace.com>,
	Jakub Kacinski <kuba@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.6 018/290] SUNRPC: Prevent hang on NFS mount with xprtsec=[m]tls
Date: Mon, 23 Jun 2025 15:04:39 +0200
Message-ID: <20250623130627.532697286@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2724,6 +2724,11 @@ static void xs_tcp_tls_setup_socket(stru
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


