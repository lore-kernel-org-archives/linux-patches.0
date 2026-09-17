Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868D44B44C5;
	Thu, 17 Sep 2026 15:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660651; cv=none; b=i1T7b2aG+62mZ6OEuv2lkI8DSiqfeI1Jme9W2Tf7L9yCeSnZZnuxWDfjbtCYQ/jzD38EJu6ePKQ2HdzOAIEDO69Kt3YPfpcpBbKM35ZjH1a1+8nj2sLwFW+C1zgnjMJCIPdSTvQo8dE8lTFRlK56yy7HBnHWSrzxegowdF95DGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660651; c=relaxed/simple;
	bh=mdf899rhnxGiaBAs+eHA93Rf1S9BYJRLPVDxHN58suA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsGZF2+SeDlB+Erz3wXTKwpqEtKF3y6pOYphvGEhyh9yFJEFymnLrT+uamecgPhvjSLKoHmMkbJVWz5/ASPpecDtvtCeY/IXaBzaW3RE2zlZ3yLCkStGqPfnb4nCq+J2pgENukrsAEgYikEGmZzA93QHgPLtxuWtHy/hK8+JgOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0d91/seZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0d91/seZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D869A1F000FF;
	Thu, 17 Sep 2026 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660650;
	bh=h08YwrtwhfmCA3PuqaX+EDascCDkM4Dolj3lVeZpu5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0d91/seZ4NuErETYZlD0oF1FgiZ1gGa/610U51acKILD/ronoNZqNHtlN0jB27uZV
	 jvvqHkiPwsHieBKZohk2XqNBQ44Fh5VcecOQZZPeoL7GH5+NbI2UcIvNte6AZ93yZ8
	 oYQARNniOo0aP/XsOIIsT6a8ac125Rv4hHlG1hRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 626/733] smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()
Date: Thu, 17 Sep 2026 16:15:34 +0100
Message-ID: <20260917151408.149916742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Oliva <diego@bynar.io>

commit 5be5bdda5863eacc964b609ba927764f253431b3 upstream.

The SMB1 synchronous read helper CIFSSMBRead() validates the server's
DataLength against CIFSMaxBufSize and the caller's count, but never
validates DataOffset. The copy source is formed as

	&pSMBr->hdr.Protocol + le16_to_cpu(pSMBr->DataOffset)

and memcpy()'d for DataLength bytes with no check that the
[DataOffset, DataOffset + DataLength) range lies within the response
actually received from the server.

A malicious or compromised SMB1 server can return a response carrying
an in-range DataLength and a large DataOffset, driving the source
pointer past the end of the response buffer. The memcpy() then copies
adjacent kernel heap into the caller's read buffer (information
disclosure), or reads unmapped memory and oopses (denial of service).
SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Both DataOffset and the received response length recorded in
rsp_iov.iov_len are relative to the start of the SMB header, so reject
the response unless DataOffset + DataLength fits within that length,
using overflow-safe arithmetic, before forming the source pointer.
The response length has been validated by the previous patch, so the
DataOffset and DataLength fields can be read safely here.

While here, make data_length unsigned. It holds a length derived from
unsigned on-the-wire fields and is only ever compared against unsigned
quantities; print it with %u accordingly, and add __func__ to the
cifs_dbg() calls in this function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c | 18 +++++++++++++-----
 fs/smb/client/trace.h   |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index be13ab37039d..f9aff0712794 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1728,7 +1728,8 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 			      rsp_iov.iov_len, tcon->ses->server->vals->read_rsp_size);
 		*nbytes = 0;
 	} else {
-		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
+		unsigned int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
+		__u16 data_offset = le16_to_cpu(pSMBr->DataOffset);
 		data_length = data_length << 16;
 		data_length += le16_to_cpu(pSMBr->DataLength);
 		*nbytes = data_length;
@@ -1736,14 +1737,21 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 		/*check that DataLength would not go beyond end of SMB */
 		if ((data_length > CIFSMaxBufSize)
 				|| (data_length > count)) {
-			cifs_dbg(FYI, "bad length %d for count %d\n",
-				 data_length, count);
+			cifs_dbg(FYI, "%s: bad length %u for count %u\n",
+				 __func__, data_length, count);
 			rc = smb_EIO2(smb_eio_trace_read_overlarge,
 				      data_length, count);
 			*nbytes = 0;
+		} else if (data_offset < sizeof(*pSMBr) ||
+			   (size_t)data_offset + data_length > rsp_iov.iov_len) {
+			/* check that the data lies within the received response */
+			cifs_dbg(FYI, "%s: bad data offset %u length %u for response of %zu\n",
+				 __func__, data_offset, data_length, rsp_iov.iov_len);
+			rc = smb_EIO2(smb_eio_trace_read_bad_offset,
+				      data_offset, data_length);
+			*nbytes = 0;
 		} else {
-			pReadData = (char *) (&pSMBr->hdr.Protocol) +
-					le16_to_cpu(pSMBr->DataOffset);
+			pReadData = (char *) (&pSMBr->hdr.Protocol) + data_offset;
 /*			if (rc = copy_to_user(buf, pReadData, data_length)) {
 				cifs_dbg(VFS, "Faulting on read rc = %d\n",rc);
 				rc = -EFAULT;
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 12241abb8e2e..b442cccd1530 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -79,6 +79,7 @@
 	EM(smb_eio_trace_qreparse_setup_count,		"qreparse_setup_count") \
 	EM(smb_eio_trace_qreparse_sizes_wrong,		"qreparse_sizes_wrong") \
 	EM(smb_eio_trace_qsym_bcc_too_small,		"qsym_bcc_too_small") \
+	EM(smb_eio_trace_read_bad_offset,		"read_bad_offset") \
 	EM(smb_eio_trace_read_mid_state_unknown,	"read_mid_state_unknown") \
 	EM(smb_eio_trace_read_overlarge,		"read_overlarge") \
 	EM(smb_eio_trace_read_rsp_malformed,		"read_rsp_malformed") \
-- 
2.55.0



