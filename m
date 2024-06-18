Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165C51586DB;
	Tue, 18 Jun 2024 13:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716270; cv=none; b=IupTG9i9yTLwZznqqZ04FQY0LWuTJ1c1QE6+IpdNMGv9oOlXus4UWr0IvoeMO502TzPFr6rTLF+BS8INItGoWBDp3NoEhVqsaIJSetYA7goLpZx5BP517XsFPFbgshKEQQCFRIizNzhnQMrDPHdnQYmdiSm+5Bxtltiy9QNIabY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716270; c=relaxed/simple;
	bh=I3w7ATQmc7eXqfNYJ0gm161og4C9RMQoTSvIWrDvcVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUePnNmREQO2McaCqvj7+owICYKacaIFfeLpr1CozVXEoWbjQIPREjX/hXNTGU3xwagswX8JuSDxbHgTtyBiT1AzZCtCj830W0UytwrrxYEgLI/Ef3Xhn/IG4MNMDpE2StQBK2XJ2KHOf+XfpJP4QUn5P5sPt4KothsFKcDfqek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnYtrb15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnYtrb15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933F3C3277B;
	Tue, 18 Jun 2024 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716270;
	bh=I3w7ATQmc7eXqfNYJ0gm161og4C9RMQoTSvIWrDvcVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnYtrb1537P0f+xfLAHyr7Wf5cTFgeKr2Us0ygMAPoz33bt9hbWFTJOql58JEnJjn
	 nw8eukucre1AFRcB32TnhG7Zy1Ns/ZYvxLkbXm0xQ3y6XxOIAThryjlCPpWW43REuU
	 r9NTLVhZb6VZxfWCDusapRGRz0qqDjasu3J9pVg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 590/770] NFSD: Optimize nfsd4_encode_fattr()
Date: Tue, 18 Jun 2024 14:37:23 +0200
Message-ID: <20240618123430.069305539@linuxfoundation.org>
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

[ Upstream commit ab04de60ae1cc64ae16b77feae795311b97720c7 ]

write_bytes_to_xdr_buf() is a generic way to place a variable-length
data item in an already-reserved spot in the encoding buffer.

However, it is costly. In nfsd4_encode_fattr(), it is unnecessary
because the data item is fixed in size and the buffer destination
address is always word-aligned.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 14e8e37550609..1e388cdf9b005 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2828,10 +2828,9 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	struct kstat stat;
 	struct svc_fh *tempfh = NULL;
 	struct kstatfs statfs;
-	__be32 *p;
+	__be32 *p, *attrlen_p;
 	int starting_len = xdr->buf->len;
 	int attrlen_offset;
-	__be32 attrlen;
 	u32 dummy;
 	u64 dummy64;
 	u32 rdattr_err = 0;
@@ -2919,10 +2918,9 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		goto out;
 
 	attrlen_offset = xdr->buf->len;
-	p = xdr_reserve_space(xdr, 4);
-	if (!p)
+	attrlen_p = xdr_reserve_space(xdr, XDR_UNIT);
+	if (!attrlen_p)
 		goto out_resource;
-	p++;                /* to be backfilled later */
 
 	if (bmval0 & FATTR4_WORD0_SUPPORTED_ATTRS) {
 		u32 supp[3];
@@ -3344,8 +3342,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		*p++ = cpu_to_be32(err == 0);
 	}
 
-	attrlen = htonl(xdr->buf->len - attrlen_offset - 4);
-	write_bytes_to_xdr_buf(xdr->buf, attrlen_offset, &attrlen, 4);
+	*attrlen_p = cpu_to_be32(xdr->buf->len - attrlen_offset - XDR_UNIT);
 	status = nfs_ok;
 
 out:
-- 
2.43.0



