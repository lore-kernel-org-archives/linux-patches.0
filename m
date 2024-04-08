Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F21524AF;
	Mon,  8 Apr 2024 13:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584392; cv=none; b=NgMJK6+rcMNfyBFtiN6YBFKPYE/OewKs6wJ+NcB4B1eRnXRmrBWEUXx416vqIAbHV9FSxeBK456ZJMOskvrW1Akogqyk/vmsNWKO6hl9cJQC47YkA1PBzOlgG3uHOh+N77K2TFjXETNSiVGmnc1yQBMgAl7chC63eBlCvjPdH+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584392; c=relaxed/simple;
	bh=5uvflH7q2Jv0Gs7FR3U/xlnYHPzeGRMBkGQL8LUZwl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r45DkDGYq/LOfK2cWSW9RqGoybU/isxqNnbDiqYFIEgm5ZSXA9UB4gNzfnUsHzfpObvz++goI7mGI2cKr+nh4vkAac7Uz62uYvQBYDLS63ktn4VdjEtyFz79YXBK/bGQbDDgoail9OOKecX74xyJE7MNNpDC8EmcXh3rOGpl49c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drCgPkYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drCgPkYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F39C433C7;
	Mon,  8 Apr 2024 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584392;
	bh=5uvflH7q2Jv0Gs7FR3U/xlnYHPzeGRMBkGQL8LUZwl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drCgPkYsPAaowyNJLQXFp8J1maHlCx2Tr4B5HfCmKDg0Q074tTkv8ObVhotfKbEN7
	 GM02NsNdsyKm+x1AWx1BNgqF5Yotib1WR5NV+xF/+qBfdqDjnmWnPE2nA8GVXbIMgR
	 C7Y21xulQFhZHUF3yrbxKdVis+feJePipuhSq66g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 381/690] NFSD: Optimize nfsd4_encode_fattr()
Date: Mon,  8 Apr 2024 14:54:07 +0200
Message-ID: <20240408125413.340268787@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/nfs4xdr.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9eba9afe13794..d5a4aa0da32be 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2825,10 +2825,9 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
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
@@ -2916,10 +2915,9 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
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
@@ -3341,8 +3339,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		*p++ = cpu_to_be32(err == 0);
 	}
 
-	attrlen = htonl(xdr->buf->len - attrlen_offset - 4);
-	write_bytes_to_xdr_buf(xdr->buf, attrlen_offset, &attrlen, 4);
+	*attrlen_p = cpu_to_be32(xdr->buf->len - attrlen_offset - XDR_UNIT);
 	status = nfs_ok;
 
 out:
-- 
2.43.0



