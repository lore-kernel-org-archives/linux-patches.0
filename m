Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62804153BE8;
	Fri,  6 Dec 2024 15:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498416; cv=none; b=qwGTi3QhDVwMSzdqwBvwN2wh9nsswlqroB31C400+73C+slA4s8khgzQfsTtfnSbntGA+UY2qgjQxYHusvcayfVLzPN8olzEeyGqcSRJRJn07yVoP0vE5bg4OvYNn0ivshrOyfRkvzM79o7FU7VeqtDWxsopfTiAKvzXh4N9W+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498416; c=relaxed/simple;
	bh=/IsoKhTOaTBo/wYh2Diqg2mNZqlN5Gg8W4+RyyWm7G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oa2Ft9/EwhGXIs7Vyy+K46/976IyPWxFuMPAZTE+q4LXXWyobG+RQAuPVKPE3Iqqh9UpdGe2lX1Jd5UYrSMoivNyPvDqs61S58+J0pjmsONgY731NSpwfyR3VQ4nrw9W/gjR6i3cwawAfDj0R3Ocp1a5pWy2bbRBGEXXzQlnMyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5sj3HNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5sj3HNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C503BC4CED1;
	Fri,  6 Dec 2024 15:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498416;
	bh=/IsoKhTOaTBo/wYh2Diqg2mNZqlN5Gg8W4+RyyWm7G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5sj3HNTgOEU5fympa9quzMU1fj+PTRt2Lcyg8i66H9xPv6Rp13lwazW7BV+RYqvE
	 JmWhlWmWFdFFNrYN2V3Lwx0vaKdUKC3Klt0ykb942+KW9X4Q73pCvf6rQDe7AoimyO
	 YJ2YSUwFhKQQZ0jSWqXVrbeDrId8LEpWCY58+N28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 578/676] cifs: Fix parsing reparse point with native symlink in SMB1 non-UNICODE session
Date: Fri,  6 Dec 2024 15:36:37 +0100
Message-ID: <20241206143715.935483507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5c8fb75b61457..b0c0572f9d1fb 100644
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



