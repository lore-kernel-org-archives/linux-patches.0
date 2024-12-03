Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7543C1F4276;
	Tue,  3 Dec 2024 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239963; cv=none; b=j9eQrf1fZfEMPX1AJ7fvgn++4pvAqG8aF4QTHe9f5KKDdJcOx7YCkrrnAFqY0Y2ENUSwIKQ2mFe6v4tFnf46oxyMgJ43mbBhXPwEWCMt+WB/83Jfn+FAzM3bw6t1XuIp0gxoRIN2fOnsDa5SWIYdmZdLyNRwKZLDh4zZxtF6bdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239963; c=relaxed/simple;
	bh=ropRXjPiDr2y5ufmCLZbnQGwtjuSukPhR4D06txVxeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TgRRhYCmhbEiKDEbhUViRrdbLiRgQrLKyft6jnKwvDSQuyzT90gZ2mO6+2KcBGf98P370bFAxVu6YRtcSfUad6bN7SQsTkFMMQbSUY1yrPUnW9hk1s+WWIRnS111Z3lJXsFq5IWsA0vax0DZe6g2iO9XMghvV1OlAkboiD+Wnsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNbbDt4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNbbDt4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26DFC4CED8;
	Tue,  3 Dec 2024 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239963;
	bh=ropRXjPiDr2y5ufmCLZbnQGwtjuSukPhR4D06txVxeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNbbDt4MPqyy5RFP815e2U+hQJPMGR7SQhiK6RYaxqj5iZpr4eB2YWrdi2C6oWgfX
	 i68cgn7FjH4Gv+5sSZOkapxWeVrrqrj8Ki9beDBJlYtQUMJNtIvD4y9aszibZwg7ks
	 ocTmSHrxh8Mg3300qsqVCb8ax9mwH/oOTCfsrgRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 795/817] cifs: Fix parsing reparse point with native symlink in SMB1 non-UNICODE session
Date: Tue,  3 Dec 2024 15:46:07 +0100
Message-ID: <20241203144027.044081897@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit f4ca4f5a36eac9b4da378a0f28cbbe38534a0901 ]

SMB1 NT_TRANSACT_IOCTL/FSCTL_GET_REPARSE_POINT even in non-UNICODE mode
returns reparse buffer in UNICODE/UTF-16 format.

This is because FSCTL_GET_REPARSE_POINT is NT-based IOCTL which does not
distinguish between 8-bit non-UNICODE and 16-bit UNICODE modes and its path
buffers are always encoded in UTF-16.

This change fixes reading of native symlinks in SMB1 when UNICODE session
is not active.

Fixes: ed3e0a149b58 ("smb: client: implement ->query_reparse_point() for SMB1")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb1ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 3c7f3c4b94c8d..c252447918d67 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1000,12 +1000,11 @@ static int cifs_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 {
 	struct reparse_data_buffer *buf;
 	TRANSACT_IOCTL_RSP *io = rsp_iov->iov_base;
-	bool unicode = !!(io->hdr.Flags2 & SMBFLG2_UNICODE);
 	u32 plen = le16_to_cpu(io->ByteCount);
 
 	buf = (struct reparse_data_buffer *)((__u8 *)&io->hdr.Protocol +
 					     le32_to_cpu(io->DataOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, full_path, unicode, data);
+	return parse_reparse_point(buf, plen, cifs_sb, full_path, true, data);
 }
 
 static bool
-- 
2.43.0



