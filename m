Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DFB2E84A;
	Fri, 24 Nov 2023 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wossuNR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54C1C433C7;
	Fri, 24 Nov 2023 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852162;
	bh=LZxdEw4Tr0nqQbLTrsivE+uVh3W8FIwKVLg3VNv69CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wossuNR1YXXQJa6GnO1ZVvvnYI0LGIDapeCR+5pVUVUf0oacp1+cDhuQC/Y+MFRI6
	 3FAnSvvYDsmycN5COEQfRLCGEhR8NBFO7KMeskUD97B8lzxhenaGk4L1A+/DnyXWcb
	 FwzA0RVl7BcDYQDqjWygJ4+kvLNrhjlbQxQYswSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 220/372] svcrdma: Drop connection after an RDMA Read error
Date: Fri, 24 Nov 2023 17:50:07 +0000
Message-ID: <20231124172017.819375551@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 197115ebf358cb440c73e868b2a0a5ef728decc6 upstream.

When an RPC Call message cannot be pulled from the client, that
is a message loss, by definition. Close the connection to trigger
the client to resend.

Cc: <stable@vger.kernel.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -857,7 +857,8 @@ out_readfail:
 	if (ret == -EINVAL)
 		svc_rdma_send_error(rdma_xprt, ctxt, ret);
 	svc_rdma_recv_ctxt_put(rdma_xprt, ctxt);
-	return ret;
+	svc_xprt_deferred_close(xprt);
+	return -ENOTCONN;
 
 out_backchannel:
 	svc_rdma_handle_bc_reply(rqstp, ctxt);


