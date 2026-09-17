Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC508547068;
	Thu, 17 Sep 2026 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668744; cv=none; b=Uvj9ia3WVme8Z52xYFMHqkTKciaIYa7sNuglNX/HAAhkB+uPctpztymVIQOhIox7eQd5L6sdj+CNyjSJy/jJlkKef+kzIwP7L9EY9gKg8cJ92cxP9gQQBP95RBudOC4jGhZ+vGrxMXZFtygrssBPt8+XsnEnxRoetU+uzfbMPx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668744; c=relaxed/simple;
	bh=JnmqSEpdu7XOUhgm1qSYV5lyIB/7wYULMZDzqTyElMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYL/gDcbuZ+RCnpemSW4B3cwXgnurOROFp6owhUnI0nY03pDWYVe5tjljv8CxX3GBuSpbQrQSC7q5S7Aobq4SP6w5Pi1z7PKKDofpcHUgloacExAb+kP//zK5iOH+8GUauBWKhDjLk3CVSubwANaGza+TzWb0lLJGlx62NdJ2yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIY3MZgZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIY3MZgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEA21F000FF;
	Thu, 17 Sep 2026 18:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668741;
	bh=0j/uUvIVxugoTnxZkdcSNOgAH6Rx01MxFEIp5DAlz3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIY3MZgZcJMVHcWpGdZ6ypRIToowKx3eUlcsRPZ7tSyyEaeQBkWxtA4NAABI+dcb/
	 KE1nTiUiOKn9qegKXc3TbeOnc/H6qJYtDfFxDmbg/QaGjsSBLhA9OClO9hKhiwtijE
	 8a7pUqtcSjd0HxrDlb6jPuWqnKUSj/r9AqdC2l0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0527/1102] smb: client: batch SRV_COPYCHUNK entries to cut round trips
Date: Thu, 17 Sep 2026 16:07:50 +0100
Message-ID: <20260917151553.024332484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit 68d2e2ca1cba9259e943bcd188671b619b9770b4 ]

smb2_copychunk_range() used to send a single SRV_COPYCHUNK per
SRV_COPYCHUNK_COPY IOCTL.

Implement variable Chunks[] array in struct copychunk_ioctl and fill it
with struct copychunk (MS-SMB2 2.2.31.1.1), bounded by server-advertised
limits.

This reduces the number of IOCTL requests for large copies.

While we are at it, rename a couple variables to follow the terminology
used in the specification.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 0923ae9f23cc ("smb/client: fix data corruption in emulated insert range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 306 +++++++++++++++++++++++++---------------
 fs/smb/client/smb2pdu.h |  16 ++-
 fs/smb/client/trace.h   |   2 +-
 3 files changed, 207 insertions(+), 117 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9661fef35b5c8..88cad8e81d489 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1832,140 +1832,226 @@ smb2_ioctl_query_info(const unsigned int xid,
 	return rc;
 }
 
+/**
+ * calc_chunk_count - calculates the number chunks to be filled in the Chunks[]
+ * array of struct copychunk_ioctl
+ *
+ * @tcon: destination file tcon
+ * @bytes_left: how many bytes are left to copy
+ *
+ * Return: maximum number of chunks with which Chunks[] can be filled.
+ */
+static inline u32
+calc_chunk_count(struct cifs_tcon *tcon, u64 bytes_left)
+{
+	u32 max_chunks = READ_ONCE(tcon->max_chunks);
+	u32 max_bytes_copy = READ_ONCE(tcon->max_bytes_copy);
+	u32 max_bytes_chunk = READ_ONCE(tcon->max_bytes_chunk);
+	u64 need;
+	u32 allowed;
+
+	if (!max_bytes_chunk || !max_bytes_copy || !max_chunks)
+		return 0;
+
+	/* chunks needed for the remaining bytes */
+	need = DIV_ROUND_UP_ULL(bytes_left, max_bytes_chunk);
+	/* chunks allowed per cc request */
+	allowed = DIV_ROUND_UP(max_bytes_copy, max_bytes_chunk);
+
+	return (u32)umin(need, umin(max_chunks, allowed));
+}
+
+/**
+ * smb2_copychunk_range - server-side copy of data range
+ *
+ * @xid: transaction id
+ * @src_file: source file
+ * @dst_file: destination file
+ * @src_off: source file byte offset
+ * @len: number of bytes to copy
+ * @dst_off: destination file byte offset
+ *
+ * Obtains a resume key for @src_file and issues FSCTL_SRV_COPYCHUNK_WRITE
+ * IOCTLs, splitting the request into chunks limited by tcon->max_*.
+ *
+ * Return: @len on success; negative errno on failure.
+ */
 static ssize_t
 smb2_copychunk_range(const unsigned int xid,
-			struct cifsFileInfo *srcfile,
-			struct cifsFileInfo *trgtfile, u64 src_off,
-			u64 len, u64 dest_off)
+		     struct cifsFileInfo *src_file,
+		     struct cifsFileInfo *dst_file,
+		     u64 src_off,
+		     u64 len,
+		     u64 dst_off)
 {
-	int rc;
-	unsigned int ret_data_len;
-	struct copychunk_ioctl *pcchunk;
-	struct copychunk_ioctl_rsp *retbuf = NULL;
+	int rc = 0;
+	unsigned int ret_data_len = 0;
+	struct copychunk_ioctl *cc_req = NULL;
+	struct copychunk_ioctl_rsp *cc_rsp = NULL;
 	struct cifs_tcon *tcon;
-	int chunks_copied = 0;
-	bool chunk_sizes_updated = false;
-	ssize_t bytes_written, total_bytes_written = 0;
+	struct copychunk *chunk;
+	u32 chunks, chunk_count, chunk_bytes;
+	u32 copy_bytes, copy_bytes_left;
+	u32 chunks_written, bytes_written;
+	u64 total_bytes_left = len;
+	u64 src_off_prev, dst_off_prev;
+	u32 retries = 0;
+
+	tcon = tlink_tcon(dst_file->tlink);
+
+	trace_smb3_copychunk_enter(xid, src_file->fid.volatile_fid,
+				   dst_file->fid.volatile_fid, tcon->tid,
+				   tcon->ses->Suid, src_off, dst_off, len);
+
+retry:
+	chunk_count = calc_chunk_count(tcon, total_bytes_left);
+	if (!chunk_count) {
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
 
-	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
-	if (pcchunk == NULL)
-		return -ENOMEM;
+	cc_req = kzalloc(struct_size(cc_req, Chunks, chunk_count), GFP_KERNEL);
+	if (!cc_req) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
-	cifs_dbg(FYI, "%s: about to call request res key\n", __func__);
 	/* Request a key from the server to identify the source of the copy */
-	rc = SMB2_request_res_key(xid, tlink_tcon(srcfile->tlink),
-				srcfile->fid.persistent_fid,
-				srcfile->fid.volatile_fid, pcchunk);
+	rc = SMB2_request_res_key(xid,
+				  tlink_tcon(src_file->tlink),
+				  src_file->fid.persistent_fid,
+				  src_file->fid.volatile_fid,
+				  cc_req);
 
-	/* Note: request_res_key sets res_key null only if rc !=0 */
+	/* Note: request_res_key sets res_key null only if rc != 0 */
 	if (rc)
-		goto cchunk_out;
+		goto out;
 
-	/* For now array only one chunk long, will make more flexible later */
-	pcchunk->ChunkCount = cpu_to_le32(1);
-	pcchunk->Reserved = 0;
-	pcchunk->Reserved2 = 0;
+	while (total_bytes_left > 0) {
 
-	tcon = tlink_tcon(trgtfile->tlink);
+		/* Store previous offsets to allow rewind */
+		src_off_prev = src_off;
+		dst_off_prev = dst_off;
 
-	trace_smb3_copychunk_enter(xid, srcfile->fid.volatile_fid,
-				   trgtfile->fid.volatile_fid, tcon->tid,
-				   tcon->ses->Suid, src_off, dest_off, len);
+		chunks = 0;
+		copy_bytes = 0;
+		copy_bytes_left = umin(total_bytes_left, tcon->max_bytes_copy);
+		while (copy_bytes_left > 0 && chunks < chunk_count) {
+			chunk = &cc_req->Chunks[chunks++];
 
-	while (len > 0) {
-		pcchunk->SourceOffset = cpu_to_le64(src_off);
-		pcchunk->TargetOffset = cpu_to_le64(dest_off);
-		pcchunk->Length =
-			cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk));
+			chunk->SourceOffset = cpu_to_le64(src_off);
+			chunk->TargetOffset = cpu_to_le64(dst_off);
+
+			chunk_bytes = umin(copy_bytes_left, tcon->max_bytes_chunk);
+
+			chunk->Length = cpu_to_le32(chunk_bytes);
+			/* Buffer is zeroed, no need to set chunk->Reserved = 0 */
+
+			src_off += chunk_bytes;
+			dst_off += chunk_bytes;
+
+			copy_bytes_left -= chunk_bytes;
+			copy_bytes += chunk_bytes;
+		}
+
+		cc_req->ChunkCount = cpu_to_le32(chunks);
+		/* Buffer is zeroed, no need to set cc_req->Reserved = 0 */
 
 		/* Request server copy to target from src identified by key */
-		kfree(retbuf);
-		retbuf = NULL;
-		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
-			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
-			(char *)pcchunk, sizeof(struct copychunk_ioctl),
-			CIFSMaxBufSize, (char **)&retbuf, &ret_data_len);
+		kfree(cc_rsp);
+		cc_rsp = NULL;
+		rc = SMB2_ioctl(xid, tcon, dst_file->fid.persistent_fid,
+			dst_file->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
+			(char *)cc_req, struct_size(cc_req, Chunks, chunks),
+			CIFSMaxBufSize, (char **)&cc_rsp, &ret_data_len);
+
+		if (rc && rc != -EINVAL)
+			goto out;
+
+		if (unlikely(ret_data_len != sizeof(*cc_rsp))) {
+			cifs_tcon_dbg(VFS, "Copychunk invalid response: size %u/%zu\n",
+				      ret_data_len, sizeof(*cc_rsp));
+			rc = -EIO;
+			goto out;
+		}
+
+		bytes_written = le32_to_cpu(cc_rsp->TotalBytesWritten);
+		chunks_written = le32_to_cpu(cc_rsp->ChunksWritten);
+		chunk_bytes = le32_to_cpu(cc_rsp->ChunkBytesWritten);
+
 		if (rc == 0) {
-			if (ret_data_len !=
-					sizeof(struct copychunk_ioctl_rsp)) {
-				cifs_tcon_dbg(VFS, "Invalid cchunk response size\n");
-				rc = -EIO;
-				goto cchunk_out;
-			}
-			if (retbuf->TotalBytesWritten == 0) {
-				cifs_dbg(FYI, "no bytes copied\n");
-				rc = -EIO;
-				goto cchunk_out;
-			}
-			/*
-			 * Check if server claimed to write more than we asked
-			 */
-			if (le32_to_cpu(retbuf->TotalBytesWritten) >
-			    le32_to_cpu(pcchunk->Length)) {
-				cifs_tcon_dbg(VFS, "Invalid copy chunk response\n");
+			/* Check if server claimed to write more than we asked */
+			if (unlikely(!bytes_written || bytes_written > copy_bytes ||
+				     !chunks_written || chunks_written > chunks)) {
+				cifs_tcon_dbg(VFS, "Copychunk invalid response: bytes written %u/%u, chunks written %u/%u\n",
+					      bytes_written, copy_bytes, chunks_written, chunks);
 				rc = -EIO;
-				goto cchunk_out;
+				goto out;
 			}
-			if (le32_to_cpu(retbuf->ChunksWritten) != 1) {
-				cifs_tcon_dbg(VFS, "Invalid num chunks written\n");
-				rc = -EIO;
-				goto cchunk_out;
+
+			/* Partial write: rewind */
+			if (bytes_written < copy_bytes) {
+				u32 delta = copy_bytes - bytes_written;
+
+				src_off -= delta;
+				dst_off -= delta;
 			}
-			chunks_copied++;
-
-			bytes_written = le32_to_cpu(retbuf->TotalBytesWritten);
-			src_off += bytes_written;
-			dest_off += bytes_written;
-			len -= bytes_written;
-			total_bytes_written += bytes_written;
-
-			cifs_dbg(FYI, "Chunks %d PartialChunk %d Total %zu\n",
-				le32_to_cpu(retbuf->ChunksWritten),
-				le32_to_cpu(retbuf->ChunkBytesWritten),
-				bytes_written);
-			trace_smb3_copychunk_done(xid, srcfile->fid.volatile_fid,
-				trgtfile->fid.volatile_fid, tcon->tid,
-				tcon->ses->Suid, src_off, dest_off, len);
-		} else if (rc == -EINVAL) {
-			if (ret_data_len != sizeof(struct copychunk_ioctl_rsp))
-				goto cchunk_out;
-
-			cifs_dbg(FYI, "MaxChunks %d BytesChunk %d MaxCopy %d\n",
-				le32_to_cpu(retbuf->ChunksWritten),
-				le32_to_cpu(retbuf->ChunkBytesWritten),
-				le32_to_cpu(retbuf->TotalBytesWritten));
 
-			/*
-			 * Check if this is the first request using these sizes,
-			 * (ie check if copy succeed once with original sizes
-			 * and check if the server gave us different sizes after
-			 * we already updated max sizes on previous request).
-			 * if not then why is the server returning an error now
-			 */
-			if ((chunks_copied != 0) || chunk_sizes_updated)
-				goto cchunk_out;
-
-			/* Check that server is not asking us to grow size */
-			if (le32_to_cpu(retbuf->ChunkBytesWritten) <
-					tcon->max_bytes_chunk)
-				tcon->max_bytes_chunk =
-					le32_to_cpu(retbuf->ChunkBytesWritten);
-			else
-				goto cchunk_out; /* server gave us bogus size */
+			total_bytes_left -= bytes_written;
+			continue;
+		}
 
-			/* No need to change MaxChunks since already set to 1 */
-			chunk_sizes_updated = true;
-		} else
-			goto cchunk_out;
+		/*
+		 * Check if server is not asking us to reduce size.
+		 *
+		 * Note: As per MS-SMB2 2.2.32.1, the values returned
+		 * in cc_rsp are not strictly lower than what existed
+		 * before.
+		 */
+		if (bytes_written < tcon->max_bytes_copy) {
+			cifs_tcon_dbg(FYI, "Copychunk MaxBytesCopy updated: %u -> %u\n",
+				      tcon->max_bytes_copy, bytes_written);
+			tcon->max_bytes_copy = bytes_written;
+		}
+
+		if (chunks_written < tcon->max_chunks) {
+			cifs_tcon_dbg(FYI, "Copychunk MaxChunks updated: %u -> %u\n",
+				      tcon->max_chunks, chunks_written);
+			tcon->max_chunks = chunks_written;
+		}
+
+		if (chunk_bytes < tcon->max_bytes_chunk) {
+			cifs_tcon_dbg(FYI, "Copychunk MaxBytesChunk updated: %u -> %u\n",
+				      tcon->max_bytes_chunk, chunk_bytes);
+			tcon->max_bytes_chunk = chunk_bytes;
+		}
+
+		/* reset to last offsets */
+		if (retries++ < 2) {
+			src_off = src_off_prev;
+			dst_off = dst_off_prev;
+			kfree(cc_req);
+			cc_req = NULL;
+			goto retry;
+		}
+
+		break;
 	}
 
-cchunk_out:
-	kfree(pcchunk);
-	kfree(retbuf);
-	if (rc)
+out:
+	kfree(cc_req);
+	kfree(cc_rsp);
+	if (rc) {
+		trace_smb3_copychunk_err(xid, src_file->fid.volatile_fid,
+					 dst_file->fid.volatile_fid, tcon->tid,
+					 tcon->ses->Suid, src_off, dst_off, len, rc);
 		return rc;
-	else
-		return total_bytes_written;
+	} else {
+		trace_smb3_copychunk_done(xid, src_file->fid.volatile_fid,
+					  dst_file->fid.volatile_fid, tcon->tid,
+					  tcon->ses->Suid, src_off, dst_off, len);
+		return len;
+	}
 }
 
 static int
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 3c09a58dfd073..101024f8f7256 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -201,16 +201,20 @@ struct resume_key_req {
 	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
+
+struct copychunk {
+	__le64 SourceOffset;
+	__le64 TargetOffset;
+	__le32 Length;
+	__le32 Reserved;
+} __packed;
+
 /* this goes in the ioctl buffer when doing a copychunk request */
 struct copychunk_ioctl {
 	char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32 ChunkCount; /* we are only sending 1 */
+	__le32 ChunkCount;
 	__le32 Reserved;
-	/* array will only be one chunk long for us */
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length; /* how many bytes to copy */
-	__u32 Reserved2;
+	struct copychunk Chunks[];
 } __packed;
 
 struct copychunk_ioctl_rsp {
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 7b3675cfa7717..724ca0d7eeecb 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -271,7 +271,7 @@ DEFINE_EVENT(smb3_copy_range_err_class, smb3_##name, \
 	TP_ARGS(xid, src_fid, target_fid, tid, sesid, src_offset, target_offset, len, rc))
 
 DEFINE_SMB3_COPY_RANGE_ERR_EVENT(clone_err);
-/* TODO: Add SMB3_COPY_RANGE_ERR_EVENT(copychunk_err) */
+DEFINE_SMB3_COPY_RANGE_ERR_EVENT(copychunk_err);
 
 DECLARE_EVENT_CLASS(smb3_copy_range_done_class,
 	TP_PROTO(unsigned int xid,
-- 
2.53.0



