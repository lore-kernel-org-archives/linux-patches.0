Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4663749F7;
	Wed, 23 Sep 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174531; cv=none; b=XjxbfsgUj0U20IsphgtF7v4cth42gTBiF65ODyCsatHkm/NkB1vU6ZVsOtPry1EzRbeWPMID8UNa12qvcD9D92P4WXnJy9kt3j2D6xOqB4FRIyx1pX+BQAAM+GFJul+gtfBgaV2M53/Jxf6nruWZRYYiIj0yZkYTPdF8hU1aNhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174531; c=relaxed/simple;
	bh=kJ3yOp52uUWg5E2zgVGCsRLD+YJwuP+5pU1+8vt9op4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A01YylgfKY8mjekmn9+HT7KkmroitKbPgcO6BKTfiWOO14LTgqVdBpA/3vT1kN4mpdXVzI0GZonw6wFxe0EqxHN0nrTUNTQ06mQw5dnw6r8pS2thCj1p8bCeVelP0cL5YBLqMk2KrtSMcuFE9bwO8Ys8f3bKpG9BSjuqv9B5qh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykfg+BOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykfg+BOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A141F000FF;
	Wed, 23 Sep 2026 14:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174529;
	bh=zN4iG7NahzkGWvMnk8/eNvJt/Kmpn6hWetY/qTVhX/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykfg+BOe4e9jJsol/0NdwW42BVeQO0NNxXZoM/ABFtSfv8v9aD7KRRG9YXzbcwo9a
	 vSU7TAkg+i4AdEHdOJfoLzaN21u7E6BB86S/ZToRdH0wLAcAX/0q5qFgOAkLQUR4JO
	 0nR6piCcYytjtVOTufrgv0Yh6Dyyu7YvBCoEvVFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/398] ksmbd: return buffer overflow for partial filesystem info
Date: Wed, 23 Sep 2026 16:03:31 +0200
Message-ID: <20260923140646.984733474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 0ecd35fac4b4f2828490689b46039744d201dcb0 ]

The query-info buffer check returns STATUS_INFO_LENGTH_MISMATCH for
every output buffer smaller than the complete response. Variable-length
filesystem information instead requires STATUS_BUFFER_OVERFLOW when the
fixed portion fits but the complete data does not.

Pass the fixed size for each filesystem information class to the buffer
checker. Keep INFO_LENGTH_MISMATCH for buffers below that size, and
return BUFFER_OVERFLOW with a response truncated to the requested length
for larger partial buffers.

This fixes smb2.getinfo.qfs_buffercheck.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 9fa26285ae70 ("ksmbd: keep compound responses on query info errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cd7bfc73cf087..092788ac01b5d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4633,21 +4633,30 @@ int smb2_query_dir(struct ksmbd_work *work)
 /**
  * buffer_check_err() - helper function to check buffer errors
  * @reqOutputBufferLength:	max buffer length expected in command response
+ * @fixed_len:			minimum fixed response length
  * @rsp:		query info response buffer contains output buffer length
  * @rsp_org:		base response buffer pointer in case of chained response
  *
  * Return:	0 on success, otherwise error
  */
 static int buffer_check_err(int reqOutputBufferLength,
+			    unsigned int fixed_len,
 			    struct smb2_query_info_rsp *rsp,
 			    void *rsp_org)
 {
-	if (reqOutputBufferLength < le32_to_cpu(rsp->OutputBufferLength)) {
+	unsigned int output_len = le32_to_cpu(rsp->OutputBufferLength);
+
+	if (reqOutputBufferLength < fixed_len) {
 		pr_err("Invalid Buffer Size Requested\n");
 		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
 		*(__be32 *)rsp_org = cpu_to_be32(sizeof(struct smb2_hdr));
 		return -EINVAL;
 	}
+
+	if (reqOutputBufferLength < output_len) {
+		rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
+		rsp->OutputBufferLength = cpu_to_le32(reqOutputBufferLength);
+	}
 	return 0;
 }
 
@@ -4710,11 +4719,13 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 	case FILE_STANDARD_INFORMATION:
 		get_standard_info_pipe(rsp, rsp_org);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
+				      le32_to_cpu(rsp->OutputBufferLength),
 				      rsp, rsp_org);
 		break;
 	case FILE_INTERNAL_INFORMATION:
 		get_internal_info_pipe(rsp, id, rsp_org);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
+				      le32_to_cpu(rsp->OutputBufferLength),
 				      rsp, rsp_org);
 		break;
 	default:
@@ -5535,6 +5546,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	}
 	if (!rc)
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
+				      le32_to_cpu(rsp->OutputBufferLength),
 				      rsp, work->response_buf);
 	ksmbd_fd_put(work, fp);
 
@@ -5556,6 +5568,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	struct kstatfs stfs;
 	struct path path;
 	int rc = 0, len;
+	unsigned int fixed_len = 0;
 
 	if (!share->path)
 		return -EIO;
@@ -5590,6 +5603,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 			info->DeviceCharacteristics |=
 				cpu_to_le32(FILE_READ_ONLY_DEVICE);
 		rsp->OutputBufferLength = cpu_to_le32(8);
+		fixed_len = 8;
 		break;
 	}
 	case FS_ATTRIBUTE_INFORMATION:
@@ -5618,6 +5632,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->FileSystemNameLen = cpu_to_le32(len);
 		sz = sizeof(struct filesystem_attribute_info) + len;
 		rsp->OutputBufferLength = cpu_to_le32(sz);
+		fixed_len = 16;
 		break;
 	}
 	case FS_VOLUME_INFORMATION:
@@ -5644,6 +5659,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->Reserved = 0;
 		sz = sizeof(struct filesystem_vol_info) + len;
 		rsp->OutputBufferLength = cpu_to_le32(sz);
+		fixed_len = 24;
 		break;
 	}
 	case FS_SIZE_INFORMATION:
@@ -5656,6 +5672,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->SectorsPerAllocationUnit = cpu_to_le32(1);
 		info->BytesPerSector = cpu_to_le32(stfs.f_bsize);
 		rsp->OutputBufferLength = cpu_to_le32(24);
+		fixed_len = 24;
 		break;
 	}
 	case FS_FULL_SIZE_INFORMATION:
@@ -5671,6 +5688,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->SectorsPerAllocationUnit = cpu_to_le32(1);
 		info->BytesPerSector = cpu_to_le32(stfs.f_bsize);
 		rsp->OutputBufferLength = cpu_to_le32(32);
+		fixed_len = 32;
 		break;
 	}
 	case FS_OBJECT_ID_INFORMATION:
@@ -5691,6 +5709,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->extended_info.rel_date = 0;
 		memcpy(info->extended_info.version_string, "1.1.0", strlen("1.1.0"));
 		rsp->OutputBufferLength = cpu_to_le32(64);
+		fixed_len = 64;
 		break;
 	}
 	case FS_SECTOR_SIZE_INFORMATION:
@@ -5712,6 +5731,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->ByteOffsetForSectorAlignment = 0;
 		info->ByteOffsetForPartitionAlignment = 0;
 		rsp->OutputBufferLength = cpu_to_le32(28);
+		fixed_len = 28;
 		break;
 	}
 	case FS_CONTROL_INFORMATION:
@@ -5732,6 +5752,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
+		fixed_len = 48;
 		break;
 	}
 	case FS_POSIX_INFORMATION:
@@ -5752,6 +5773,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
 			rsp->OutputBufferLength = cpu_to_le32(56);
+			fixed_len = 56;
 		}
 		break;
 	}
@@ -5760,6 +5782,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		return -EOPNOTSUPP;
 	}
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
+			      fixed_len,
 			      rsp, work->response_buf);
 	path_put(&path);
 
@@ -5874,6 +5897,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 iov_pin:
 	rsp->OutputBufferLength = cpu_to_le32(secdesclen);
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
+			      le32_to_cpu(rsp->OutputBufferLength),
 			      rsp, work->response_buf);
 	if (rc)
 		goto err_out;
-- 
2.53.0



