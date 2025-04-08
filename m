Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54805268FDD;
	Tue,  8 Apr 2025 11:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111588; cv=none; b=DlOW9pcRQDhYbkO5adQHg6OYbOI15/0hSZFO5sJwhmqORNeFHRPoBaonxnBOXEqMIMd2WiXS2N6kMdPg4BCekyLIyWgqYB1fZwy1m6R7oE7LkskEfVlgdD/Lfyvg3rEX2FknQsyg0bZOsu6EgJn9s9tCT+4Rds+FHkjsCKELbZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111588; c=relaxed/simple;
	bh=sPcLjZND1VoFj4bzVEDjIUG400YjdOjxQn0NjQzZTTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh9w8gdYE1ylGRID1X792/m56d/NWTYLJps2UVACt6zFc0g4IKK1BU7iLphSGiUY8T3662oAwI8l5FZFiU9YB4vdY9WQA8n95LePDi5/HWBKKYbW+0xFSV8NmUGF3X0IlHvx5C1hQs/8RbEECwohlm0WZne2RHMAwCAWJp8Rvr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLhuEHul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLhuEHul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B28C4CEEA;
	Tue,  8 Apr 2025 11:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111588;
	bh=sPcLjZND1VoFj4bzVEDjIUG400YjdOjxQn0NjQzZTTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLhuEHulrwWDoGsr5p12Ue10Y3ADpgSQ6cQP3fJy3SzA8K78vwd0USWecm4kuJXpF
	 jmTqSrlbUeZzUvxPejq3j91PQZVNUNOrVUfwu/skfRdrHFKzSL/FhShAtAa/5umnib
	 cJYTLsY8Mg5CVKUT9IrJzNDlfFYkdFuUogFZ79fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 485/731] NFSD: Fix callback decoder status codes
Date: Tue,  8 Apr 2025 12:46:22 +0200
Message-ID: <20250408104925.557198157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8ce35dcaf3aed7113cd692759dc0a26cec8cd0c3 ]

fs/nfsd/nfs4callback.c implements a callback client. Thus its XDR
decoders are decoding replies, not calls.

NFS4ERR_BAD_XDR is an on-the-wire status code that reports that the
client sent a corrupted RPC /call/. It's not used as the internal
error code when a /reply/ can't be decoded, since that kind of
failure is never reported to the sender of that RPC message.

Instead, a reply decoder should return -EIO, as the reply decoders
in the NFS client do.

Fixes: 6487a13b5c6b ("NFSD: add support for CB_GETATTR callback")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 484077200c5d7..d649a3d65a3a5 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -101,15 +101,15 @@ static int decode_cb_fattr4(struct xdr_stream *xdr, uint32_t *bitmap,
 
 	if (bitmap[0] & FATTR4_WORD0_CHANGE)
 		if (xdr_stream_decode_u64(xdr, &fattr->ncf_cb_change) < 0)
-			return -NFSERR_BAD_XDR;
+			return -EIO;
 	if (bitmap[0] & FATTR4_WORD0_SIZE)
 		if (xdr_stream_decode_u64(xdr, &fattr->ncf_cb_fsize) < 0)
-			return -NFSERR_BAD_XDR;
+			return -EIO;
 	if (bitmap[2] & FATTR4_WORD2_TIME_DELEG_ACCESS) {
 		fattr4_time_deleg_access access;
 
 		if (!xdrgen_decode_fattr4_time_deleg_access(xdr, &access))
-			return -NFSERR_BAD_XDR;
+			return -EIO;
 		fattr->ncf_cb_atime.tv_sec = access.seconds;
 		fattr->ncf_cb_atime.tv_nsec = access.nseconds;
 
@@ -118,7 +118,7 @@ static int decode_cb_fattr4(struct xdr_stream *xdr, uint32_t *bitmap,
 		fattr4_time_deleg_modify modify;
 
 		if (!xdrgen_decode_fattr4_time_deleg_modify(xdr, &modify))
-			return -NFSERR_BAD_XDR;
+			return -EIO;
 		fattr->ncf_cb_mtime.tv_sec = modify.seconds;
 		fattr->ncf_cb_mtime.tv_nsec = modify.nseconds;
 
@@ -682,15 +682,15 @@ static int nfs4_xdr_dec_cb_getattr(struct rpc_rqst *rqstp,
 	if (unlikely(status || cb->cb_status))
 		return status;
 	if (xdr_stream_decode_uint32_array(xdr, bitmap, 3) < 0)
-		return -NFSERR_BAD_XDR;
+		return -EIO;
 	if (xdr_stream_decode_u32(xdr, &attrlen) < 0)
-		return -NFSERR_BAD_XDR;
+		return -EIO;
 	maxlen = sizeof(ncf->ncf_cb_change) + sizeof(ncf->ncf_cb_fsize);
 	if (bitmap[2] != 0)
 		maxlen += (sizeof(ncf->ncf_cb_mtime.tv_sec) +
 			   sizeof(ncf->ncf_cb_mtime.tv_nsec)) * 2;
 	if (attrlen > maxlen)
-		return -NFSERR_BAD_XDR;
+		return -EIO;
 	status = decode_cb_fattr4(xdr, bitmap, ncf);
 	return status;
 }
-- 
2.39.5



