Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBAB158D60;
	Tue, 18 Jun 2024 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716288; cv=none; b=KBLqLQZ2fvuodyP31X+GJv1p118qpfXcLWTkIiJfmgWF+UNrrljdLoPBbXtzuFpMmzea72T0l0ejdEE8g90f0BaHfNlR/NpjURmKnXYeO31ld67y9a61UGzQHo199EVdgTcAbfWyYrXJBG0xS91rB+D7Irdk7XJN32suc44giG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716288; c=relaxed/simple;
	bh=Yeb7rpRr6dc50jubTKN4anXTriNIHXB5dSvQzWP9es4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/dt77kk//GobGG/o3sM9hOtK6oKBdByff18WkpDaF1lhSCmtFEf6OabhsUkDW6SAUrBZCEzzk5Q9rEU37s6wZvU6ClEF51ECuOKaff9FwtWJT7eLWgtdJpfEQjkBqXFW+SbB4CnHdIR0yTcy8RkmLuVbt1rXR+AGvCoPcD0vJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcJEMvOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcJEMvOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638A7C3277B;
	Tue, 18 Jun 2024 13:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716287;
	bh=Yeb7rpRr6dc50jubTKN4anXTriNIHXB5dSvQzWP9es4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcJEMvObmrLd+1SZT+4hvUzuL0r6xSlM6cSw3u3Ae4w9pIvXou1WikcvGeykvR65i
	 sdyexe7utc1n3Ue3HdABfgt72nRbw0nAxKLUYS/ZBER9r6nZa+/RYl9FBf3z/WdVmG
	 xOFJXTpEftllC+u6mqfuUIByGH4JJ2UZztw9usg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 596/770] NFSD: Clean up nfsd4_encode_readlink()
Date: Tue, 18 Jun 2024 14:37:29 +0200
Message-ID: <20240618123430.299470700@linuxfoundation.org>
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

[ Upstream commit 99b002a1fa00d90e66357315757e7277447ce973 ]

Similar changes to nfsd4_encode_readv(), all bundled into a single
patch.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4d74eb1fee8f1..a98513cb35b10 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4019,16 +4019,13 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 static __be32
 nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd4_readlink *readlink)
 {
-	int maxcount;
-	__be32 wire_count;
-	int zero = 0;
+	__be32 *p, *maxcount_p, zero = xdr_zero;
 	struct xdr_stream *xdr = resp->xdr;
 	int length_offset = xdr->buf->len;
-	int status;
-	__be32 *p;
+	int maxcount, status;
 
-	p = xdr_reserve_space(xdr, 4);
-	if (!p)
+	maxcount_p = xdr_reserve_space(xdr, XDR_UNIT);
+	if (!maxcount_p)
 		return nfserr_resource;
 	maxcount = PAGE_SIZE;
 
@@ -4053,14 +4050,11 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd
 		nfserr = nfserrno(status);
 		goto out_err;
 	}
-
-	wire_count = htonl(maxcount);
-	write_bytes_to_xdr_buf(xdr->buf, length_offset, &wire_count, 4);
-	xdr_truncate_encode(xdr, length_offset + 4 + ALIGN(maxcount, 4));
-	if (maxcount & 3)
-		write_bytes_to_xdr_buf(xdr->buf, length_offset + 4 + maxcount,
-						&zero, 4 - (maxcount&3));
-	return 0;
+	*maxcount_p = cpu_to_be32(maxcount);
+	xdr_truncate_encode(xdr, length_offset + 4 + xdr_align_size(maxcount));
+	write_bytes_to_xdr_buf(xdr->buf, length_offset + 4 + maxcount, &zero,
+			       xdr_pad_size(maxcount));
+	return nfs_ok;
 
 out_err:
 	xdr_truncate_encode(xdr, length_offset);
-- 
2.43.0



