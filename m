Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEEC39FDD;
	Fri, 24 Nov 2023 18:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwgzW+z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E64C433C8;
	Fri, 24 Nov 2023 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849810;
	bh=bm8uQJkrAF/ultY/N+YzLzIEZjnD8Y3reJz+V0HDP84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xwgzW+z0DMVTZTVukUxMx/sz9V+5NOOY88O+kQWWnbLcFxsclkerO5K95SMKzBtPX
	 P5V8Q0bv4tDdKRzv6BnAjvXx6uHSzRjZru6PFL0xy/G5z3SYHA6CY0tyCd3ozlUssK
	 4mvd9j1QkOoGRPkZUl4LLY8p1z3VVCBYWmGWGmpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 330/530] svcrdma: Drop connection after an RDMA Read error
Date: Fri, 24 Nov 2023 17:48:16 +0000
Message-ID: <20231124172038.069886492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -852,7 +852,8 @@ out_readfail:
 	if (ret == -EINVAL)
 		svc_rdma_send_error(rdma_xprt, ctxt, ret);
 	svc_rdma_recv_ctxt_put(rdma_xprt, ctxt);
-	return ret;
+	svc_xprt_deferred_close(xprt);
+	return -ENOTCONN;
 
 out_backchannel:
 	svc_rdma_handle_bc_reply(rqstp, ctxt);


