Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB34471262;
	Tue, 21 Jul 2026 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657309; cv=none; b=HkRYmnk79YMsqN1eAqsP7If5/43VeKu+y/aLp+IPhD09r+6tHkQwDaYxj0EtE3/GimxF9vPFUFOp60g09jOqIIpW//5M/8uYVRgIWJwnG844ogvp263nm3C2Ldt9XqoPCrqYi+mWwXmrzrqNQoG4jIoHPJqthk22kcyS7dQy6A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657309; c=relaxed/simple;
	bh=kLp8zfmfnPJ5GXQqUFgDprptF6IzGazqENrhFbMAREI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6dgTGMTif1hkPccB2QnjZUo+B49xktA5hs+HE6X/pO9tTSMHIdINAYJgAzUbc7TPSmrwtHKqmjraAmVrVcUxkSN+vOe0/5U89S0UPvN79DZm4S6fIUerFAFovYTb6Ilw/QU8vUhkNte0pF2gv84yZQY2VoIrjqI4Agm8kMht1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+Z2/8Q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+Z2/8Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338C51F000E9;
	Tue, 21 Jul 2026 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657306;
	bh=3/iHj7KX6IY9CDto8IHqT1ODVTMm+wMg7VqBZ90XFX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+Z2/8Q7epu0ac4+Ecb9fJtN/Nqn40iNchktecutQH6c4520i7v+zvrNCiJUqe8Wi
	 Y/jHIxP/xsvBJjVLuXyBBc1MUh0Klgh+GivDrB/aM+0kjyVFm/zOViGirS+3XMeqY6
	 RxpAKGNf78WSlnzKwRkix2ChzgvdskNL6UZkEPPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0698/1611] xprtrdma: Check frwr_wp_create() during connect
Date: Tue, 21 Jul 2026 17:13:34 +0200
Message-ID: <20260721152531.080907337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index dc8629bf294dc4..09fa25a83ce122 100644
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



