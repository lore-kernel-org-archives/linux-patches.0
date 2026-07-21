Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654903E49C4;
	Tue, 21 Jul 2026 19:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660496; cv=none; b=ZAR/JLRw1OZLH5nN1pWcXMpgVkaf35bCcRirJ9PAD75UMH0LryDN14vzh1c9+B13myljsr663wyismMGrLdImX0jaao1V7pyrA16JfmJfSDOkhKtLlTwkFdQjxED4FHv6X+29MMysZsTM8LLcf97k1IccC37BF1pjTk8hVxwT+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660496; c=relaxed/simple;
	bh=7LUtrsZgq+1MnB2jbTEr0+m5Qzmihh2xw+FbajDJcZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr697hThFx87ATZudmAsFRhM6SqbStzxHd1P2E9wPb44O3TAEZgguoTEDTl8h2TtolHKnSR87MetA5C93jY97NygtODrymRLYBUPY1TXY9UtHocHE2MMeJ8ywXfP05AMwfMOSzGCtm3uuRVr1TJx1R/sfocXxbBVF5rRlJKXcAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVIjy8na; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVIjy8na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19951F01562;
	Tue, 21 Jul 2026 19:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660478;
	bh=/9DaBDu7z4vUexBGT21anXZ4HVeI/kFZ3iebhZdZlZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVIjy8naPLy4kUXj+2nUHgN5WKWcdV8HL+IE2TUmQZzyJy3ZLXC1LITzl/bxAikm3
	 qZp8KVBp9+kmhqAcg9LuA6Vxlj2zIw1n30gEb6zDZLIZg4EGDqWtMEHMo1aFb3UX67
	 dAAF7jxdQDhyv7KzuGv1tsFPS6/5cUPHGLF0hfQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0994/2077] xprtrdma: Check frwr_wp_create() during connect
Date: Tue, 21 Jul 2026 17:11:07 +0200
Message-ID: <20260721152616.261962247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b2c186fd221b8..d48d681bb49f44 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -549,7 +549,17 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
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



