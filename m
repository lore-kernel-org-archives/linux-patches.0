Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0419A1591E3;
	Tue, 18 Jun 2024 13:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716561; cv=none; b=pW0pqqH94XEHgkwYHf8mOk/g5P/xA5mojyvLRUPrsYQ5p5cB+tJ4t/GwkCVPk/hEtPd0cSC6ebAn7w/b2XkAL9/6AGQ6eZddU/ArZfq1xmUKdIxR4ysOv8YD5wCHHua4v/aDz/7ppk1pGJR8/qmX3mmBcqVh6I5PWSbms181fQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716561; c=relaxed/simple;
	bh=41dqMHFC4TKl3Gtu5jSMj3Ug7M4C40NALqmgiTsBIJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRSgsVFKo0UGyzv2vzykg9j8bXZZtiWc9Ur+GH4+QmKi8ejZkHDm3yp2lcX7uTHtmehfs/alGw/jQunNOH+f+EtdSvUoB1CeuORdbUCFzf9JJOFE3rdbSz2yJ1IL5EOpt8mFE+apBz9N/elX6W5LdCRAqNVdtVsNaAyc55uPoU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSOocLOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSOocLOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC43C3277B;
	Tue, 18 Jun 2024 13:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716560;
	bh=41dqMHFC4TKl3Gtu5jSMj3Ug7M4C40NALqmgiTsBIJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSOocLOMU1jsD1DebMyRI8+CAPYTh45pspyAL13UM9LqmS77JtyfbhBJiIFTcYXww
	 hSIokiUEqyQghnok8/Ng0QSgfBKoxvA1Olc4+dp1q57P1cX+vlhDOM1Ou8+2/h9O+N
	 wVPp/JrUDMOJoiO7lLSpu1zv1/8dj9HqqT/Zhs0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 654/770] NFSD: Clean up nfs4svc_encode_compoundres()
Date: Tue, 18 Jun 2024 14:38:27 +0200
Message-ID: <20240618123432.531519836@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9993a66317fc9951322483a9edbfae95a640b210 ]

In today's Linux NFS server implementation, the NFS dispatcher
initializes each XDR result stream, and the NFSv4 .pc_func and
.pc_encode methods all use xdr_stream-based encoding. This keeps
rq_res.len automatically updated. There is no longer a need for
the WARN_ON_ONCE() check in nfs4svc_encode_compoundres().

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 04699198eace7..fc587381cd087 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5467,12 +5467,8 @@ bool
 nfs4svc_encode_compoundres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 {
 	struct nfsd4_compoundres *resp = rqstp->rq_resp;
-	struct xdr_buf *buf = xdr->buf;
 	__be32 *p;
 
-	WARN_ON_ONCE(buf->len != buf->head[0].iov_len + buf->page_len +
-				 buf->tail[0].iov_len);
-
 	/*
 	 * Send buffer space for the following items is reserved
 	 * at the top of nfsd4_proc_compound().
-- 
2.43.0



