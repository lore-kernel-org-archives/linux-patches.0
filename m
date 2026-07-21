Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A7944AB79;
	Tue, 21 Jul 2026 21:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669368; cv=none; b=CW92xijBDicbe9raeS1NGkwpDoB7gXtV8MzoUTTYxEG1e6FwpXX9zymll1sDo9Y2K8ca6faAZJY2axjn38vyCebpIxwbo6x1ZJb+xO5qTScasqMrVtKXNdlAuZmjhfGYBZO8UXW3epfgEo/Kx11+HZ9j4u3s/i8FONvZyoa72jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669368; c=relaxed/simple;
	bh=BtodqOJfb25CxfDby0pV/UaSste7r0PQpBfNHrx2Hao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dB+v0q0FM0C3x/BpZ91cJ+egv4sPI3x/Tpnrepc3wu1rs7G2saorku8P8aF9Py2dF5JBLUNntv2i0vsMHjv8jy+PJ4Txe4WJZvAAIn3qmiqhJvc9k6tuQgcLzh9pEDZRMoPGcdUZbOPTiC3ElPsdjc8xZ0qHG943CpK8CTwVdn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xzv5+yj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xzv5+yj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC1D1F000E9;
	Tue, 21 Jul 2026 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669366;
	bh=CzXzuMWD37ByaqkwtQ86TethBd4i2jtVYPcEyMLFSDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xzv5+yj+zGax/8ff0uUbdGC8nzYMSYFWYr8gCFQqwZWhFgGbgcNFyCFWp9sHDS366
	 o5N0b4SVq+y7M3pyfsl6y2oQTB/n7CrIS+kbQL5oF63Ar4eh2jTC3Js1F2LtwULj3x
	 04e72eV95gQm6qAgKYwCu52ItRdsha8x9P9cCorI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0529/1067] xprtrdma: Check frwr_wp_create() during connect
Date: Tue, 21 Jul 2026 17:18:50 +0200
Message-ID: <20260721152436.441387192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0f13fc7c7d2e0427517e63c739277a4cd338b0c5 ]

frwr_wp_create() creates the singleton Memory Region used to encode
padding for Write chunks whose payload length is not XDR-aligned. Its
failure paths return a negative errno and leave ep->re_write_pad_mr set
to NULL.

rpcrdma_xprt_connect() currently ignores that return value. If
frwr_wp_create() fails after the rest of the connection setup succeeds,
xprt_rdma_connect_worker() treats the connection attempt as successful
and sets XPRT_CONNECTED. A later NFS/RDMA read with a non-4-byte-aligned
receive page length reaches rpcrdma_encode_write_list(), passes the NULL
write-pad MR to encode_rdma_segment(), and dereferences it.

This is locally triggerable on an NFS/RDMA client after a connect or
reconnect hits a local MR allocation, DMA-map, MR-map, or post-send
failure; a remote peer alone cannot force the local MR setup failure.

Check the return value and fail the connect as -ENOTCONN, matching the
adjacent setup failures. This keeps XPRT_CONNECTED clear and lets the
normal reconnect path retry.

Fixes: 21037b8c2258 ("xprtrdma: Provide a buffer to pad Write chunks of unaligned length")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index ad463196f8e95d..46e3db61f1b4e7 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -536,7 +536,17 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
 		goto out;
 	}
 	rpcrdma_mrs_create(r_xprt);
-	frwr_wp_create(r_xprt);
+
+	/*
+	 * rpcrdma_encode_write_list() dereferences the write-pad
+	 * MR with no NULL check, so fail the connect rather than
+	 * publish a transport whose write-pad MR is NULL.
+	 */
+	rc = frwr_wp_create(r_xprt);
+	if (rc) {
+		rc = -ENOTCONN;
+		goto out;
+	}
 
 out:
 	trace_xprtrdma_connect(r_xprt, rc);
-- 
2.53.0



