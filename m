Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B408A366831;
	Tue, 12 May 2026 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609476; cv=none; b=ExtnSUsvb1J5boLpb9DKmw5WM3NM/qVyYG4y2V23NwvMjZ24FlpwgRZaMoywTS9MGS5xV7quhMklnvdPgdf3d/VLJJ0YLtREixR1T45e8o7u26G9LonMTKnWdrA9Cq4P30onzqs1D0a93+dT0A11vP3zJo2m0scZ8ILnXxC0ZZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609476; c=relaxed/simple;
	bh=usFQSHTRmciTN9PMjEAbQzNwnyJBVlGuA6JnZIuCz0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdSViHj4Rx/FJB9iTl9+1ax43HRGCURTXe4b9kVvrcF4+OBKt4ED1vIJR4FTc4Y9rtV3bVxEXiq82F9jtuJtAyOWoquutC9EGq9+Psl0jj2VugpyYyiltTU/CL8v6rlCKD9rzJpzQV+MNQ9mBYx6gP7ZQGdD6vpfeiSCIbBnlx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBJDfnpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBJDfnpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2ECC2BCB0;
	Tue, 12 May 2026 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609476;
	bh=usFQSHTRmciTN9PMjEAbQzNwnyJBVlGuA6JnZIuCz0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBJDfnpXCQmvVLwzt4cojX1qdQQjQqrQq9+rvNi6RkzEvZ7WNAQwFygQp9byUNZ9A
	 kbZfMxKzAXs4/wEjcDe0Gk4d2an90ErEfDSyAHUV+HY+0lPaDg+L5nxakf78EPZMI4
	 h5kEuiVMBKgbm1Uq5kdymraxFjIIqt+gD3zmoADw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zisen Ye <zisenye@stu.xidian.edu.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 211/307] smb/client: fix out-of-bounds read in smb2_compound_op()
Date: Tue, 12 May 2026 19:40:06 +0200
Message-ID: <20260512173944.569134817@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zisen Ye <zisenye@stu.xidian.edu.cn>

commit 8d09328dfda089675e4c049f3f256064a1d1996b upstream.

If a server sends a truncated response but a large OutputBufferLength, and
terminates the EA list early, check_wsl_eas() returns success without
validating that the entire OutputBufferLength fits within iov_len.

Then smb2_compound_op() does:
    memcpy(idata->wsl.eas, data[0], size[0]);

Where size[0] is OutputBufferLength. If iov_len is smaller than size[0],
memcpy can read beyond the end of the rsp_iov allocation and leak adjacent
kernel heap memory.

Link: https://lore.kernel.org/linux-cifs/d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com/
Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
Cc: stable@vger.kernel.org
Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -111,7 +111,7 @@ static int check_wsl_eas(struct kvec *rs
 	u32 outlen, next;
 	u16 vlen;
 	u8 nlen;
-	u8 *end;
+	u8 *ea_end, *iov_end;
 
 	outlen = le32_to_cpu(rsp->OutputBufferLength);
 	if (outlen < SMB2_WSL_MIN_QUERY_EA_RESP_SIZE ||
@@ -120,15 +120,19 @@ static int check_wsl_eas(struct kvec *rs
 
 	ea = (void *)((u8 *)rsp_iov->iov_base +
 		      le16_to_cpu(rsp->OutputBufferOffset));
-	end = (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
+	ea_end = (u8 *)ea + outlen;
+	iov_end = (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
+	if (ea_end > iov_end)
+		return -EINVAL;
+
 	for (;;) {
-		if ((u8 *)ea > end - sizeof(*ea))
+		if ((u8 *)ea > ea_end - sizeof(*ea))
 			return -EINVAL;
 
 		nlen = ea->ea_name_length;
 		vlen = le16_to_cpu(ea->ea_value_length);
 		if (nlen != SMB2_WSL_XATTR_NAME_LEN ||
-		    (u8 *)ea->ea_data + nlen + 1 + vlen > end)
+		    (u8 *)ea->ea_data + nlen + 1 + vlen > ea_end)
 			return -EINVAL;
 
 		switch (vlen) {


