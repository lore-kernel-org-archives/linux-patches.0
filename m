Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748DE1EE00B;
	Tue,  3 Dec 2024 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242769; cv=none; b=IOG91HGVJ/fXBIVYuS780xEFzo+vHgKDoFLtLxldytbaIHbvPhtnvi8E17GNHQNKYjwvTsDWioyg564W+3vbEZITiY9FaGhhdWuGJO3pN8aNRM0+tj+iKB+wnAlk4pQCQ6AkXbhsXQLekZiyu1mNvz27JEtAqg6s50CrF5cTso4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242769; c=relaxed/simple;
	bh=OipNKCoqfCc+qMnQYak1nFNpRvrXWRKOMY1ZWboUZSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=csoiAkJxaSHM6goaocuJt4UN883ogLlfwU+hvVNnODeEBY1OKP+hojsfbUPVr+yB0rIuPLJF1qdajuKhmBLh0riienNPIIZ/G1wJjbJ4Xf/WZEiCyVDdTxhJzx4qKpgpdBrCUQ1P3MmLQjsioMk3a6oixFzSP8ROaPqmLD0FILg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8U8e2TE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8U8e2TE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1BDC4CECF;
	Tue,  3 Dec 2024 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242769;
	bh=OipNKCoqfCc+qMnQYak1nFNpRvrXWRKOMY1ZWboUZSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8U8e2TEP+MNqNKZCtzONPCHYfYXr3tn2HP+1qg97Z/ecSVaAM8GCcNZryUEwWXMx
	 ubPKGdTc5cys5uxJgUbworclt5yzZq/bdfZQZ/CvfT4DqyZRfoduEHKCrxwy/r+gOf
	 hp3uEilkp1el+MxACGxpDsatZCek1l1HtRtlYy4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 804/826] cifs: Fix parsing reparse point with native symlink in SMB1 non-UNICODE session
Date: Tue,  3 Dec 2024 15:48:51 +0100
Message-ID: <20241203144815.118967725@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index abca214f923c2..db3695eddcf9d 100644
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



