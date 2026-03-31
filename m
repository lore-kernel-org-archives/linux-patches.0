Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D96A3E92A5;
	Tue, 31 Mar 2026 16:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974480; cv=none; b=Xi+VPc87bUnVkG4Dlzej7jH64E5uKEGpzDd1Lwi5kiUpB5Yqk2n4syBWE2vjUtCTxOscaJFzpyodwSxFnxfVGmq5Me+eaObGaOp26UTH0k34icuoHB5R21+HfiLugDA+h3cHf79W+efMPWccYYLY3v2zS4OefC0L3JB+vLMfsFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974480; c=relaxed/simple;
	bh=/MVYEUOSgcIuh5xpNGVqMP2OS6h00JrfSmWDDosIRps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixR3pNsejGdgDc1Y52k0ygLlDdxPmXN4H/cIsfHNHCadUZQwJoG1ERsaBX7PvIDMbDfe2T1cJAl1mi0xyi/yxYz9LhFNt2H1iau1Y2BtkxAsODX25ZB3L+qAGjOcWeMPohDtE9uOhDWSgo6gxQw/i3ITFwORPqDhh2vSj2Oxd/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYAvxgDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYAvxgDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C967AC19423;
	Tue, 31 Mar 2026 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974480;
	bh=/MVYEUOSgcIuh5xpNGVqMP2OS6h00JrfSmWDDosIRps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYAvxgDo+eDX6qfXm5SHKxKorw2XNOwMkmqqdxxQ8pvzEFgfNZQt2TxFRk2U6QLRs
	 qWp3wH6ZhgG0L2VdrZ1AuCl4Mhm5kL9GiJWqo0Ap+nmycTlkTwlL628n3m+yF7rPh/
	 ERaWOhcBI5ScDSORvgW49fH7BA4HUXUgVma9Es6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 101/175] ksmbd: fix potencial OOB in get_file_all_info() for compound requests
Date: Tue, 31 Mar 2026 18:21:25 +0200
Message-ID: <20260331161733.489926303@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit beef2634f81f1c086208191f7228bce1d366493d upstream.

When a compound request consists of QUERY_DIRECTORY + QUERY_INFO
(FILE_ALL_INFORMATION) and the first command consumes nearly the entire
max_trans_size, get_file_all_info() would blindly call smbConvertToUTF16()
with PATH_MAX, causing out-of-bounds write beyond the response buffer.
In get_file_all_info(), there was a missing validation check for
the client-provided OutputBufferLength before copying the filename into
FileName field of the smb2_file_all_info structure.
If the filename length exceeds the available buffer space, it could lead to
potential buffer overflows or memory corruption during smbConvertToUTF16
conversion. This calculating the actual free buffer size using
smb2_calc_max_out_buf_len() and returning -EINVAL if the buffer is
insufficient and updating smbConvertToUTF16 to use the actual filename
length (clamped by PATH_MAX) to ensure a safe copy operation.

Cc: stable@vger.kernel.org
Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4919,7 +4919,8 @@ static int get_file_all_info(struct ksmb
 	int conv_len;
 	char *filename;
 	u64 time;
-	int ret;
+	int ret, buf_free_len, filename_len;
+	struct smb2_query_info_req *req = ksmbd_req_buf_next(work);
 
 	if (!(fp->daccess & FILE_READ_ATTRIBUTES_LE)) {
 		ksmbd_debug(SMB, "no right to read the attributes : 0x%x\n",
@@ -4931,6 +4932,16 @@ static int get_file_all_info(struct ksmb
 	if (IS_ERR(filename))
 		return PTR_ERR(filename);
 
+	filename_len = strlen(filename);
+	buf_free_len = smb2_calc_max_out_buf_len(work,
+			offsetof(struct smb2_query_info_rsp, Buffer) +
+			offsetof(struct smb2_file_all_info, FileName),
+			le32_to_cpu(req->OutputBufferLength));
+	if (buf_free_len < (filename_len + 1) * 2) {
+		kfree(filename);
+		return -EINVAL;
+	}
+
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
 			  AT_STATX_SYNC_AS_STAT);
 	if (ret) {
@@ -4966,7 +4977,8 @@ static int get_file_all_info(struct ksmb
 	file_info->Mode = fp->coption;
 	file_info->AlignmentRequirement = 0;
 	conv_len = smbConvertToUTF16((__le16 *)file_info->FileName, filename,
-				     PATH_MAX, conn->local_nls, 0);
+				     min(filename_len, PATH_MAX),
+				     conn->local_nls, 0);
 	conv_len *= 2;
 	file_info->FileNameLength = cpu_to_le32(conv_len);
 	rsp->OutputBufferLength =


