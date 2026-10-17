Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA893A1A27;
	Sat, 17 Oct 2026 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259723; cv=none; b=L3II1o25MvlNBiW4nXLRV62tFChXtfSY7MmZpx5q1+gw7vVHQM2DAIjEGslfS6DUtF5M3x/nPJ9Kac6Qd/vJUcCTvAjnrkS1tzOBiiitp12xYjIKcAbrumjcb2g7+/XSjhZimr2n9GM6VClhyCcl6frD0h72i3DQfU5pSBS69Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259723; c=relaxed/simple;
	bh=MsCFIkBAj4rqlnmygVFnmdsrRYfH3d4DD+4atr7iHjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSoXes7E9dM8RYaa+qdhzL3suxSJ7V85ARSQZUxsqCYcAYhBEVqGrndLoBVThk83sj3V6ICalTVJnrkgy/gZB+2fRzKtAcC4e5yadBo4Lf90uz8mLd5ojY/p/dU35GZVvx+AmVdkAo4fxQgRKqA8IpOcOnxvSo8DKR+eXF3v/50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0cZnSQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0cZnSQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA4F1F000C4;
	Sat, 17 Oct 2026 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259721;
	bh=aiaQsHNaERQYizirpHfPoTSSD5AwZA7hIOEnQotMlkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0cZnSQ4iprau67Nf0Jhw9aqC4ngXhTSchG6Yb/2SdkXoA94JfjzTxQV36PJWDU29
	 ce6UMo14Gue1pmzNfNHuA3V3LJSb4N6eb09na5S8Y0jnMs4NS5r5zSsGaQa6fIi4LG
	 N+wpCTqfPCp0RfuIoJB5BQ6EO01rHeTRYF858rMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1307/1674] smb: client: fix use-before-check of ReparseDataLength in reparse_buf_ptr()
Date: Sat, 17 Oct 2026 17:59:39 +0200
Message-ID: <20261017160504.693082904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 05f78e6cf34ea3a285053bd5999e08e8ac298bd5 ]

reparse_buf_ptr() reads buf->ReparseDataLength before checking that
count covers the full fixed header:

    buf = (struct reparse_data_buffer *)((u8 *)io + off);
    len = sizeof(*buf);                          /* 8 bytes */
    rdlen = le16_to_cpu(buf->ReparseDataLength); /* offset 4, 2 bytes */

    if (count < len || count < rdlen + len)      /* check comes after */

struct reparse_data_buffer has ReparseDataLength at offset 4.  If a
server returns OutputCount < 6, the read at offset 4-5 reaches past
the end of the received data.  The off+count bounds against iov_len
were already validated, but that does not protect against count being
smaller than sizeof(*buf).

Split the check: verify count >= sizeof(*buf) before reading
ReparseDataLength, then verify count covers the data region.

Fixes: a158bb66b137 ("smb: client: optimise reparse point querying")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index db5475fe00713..2c7640939be38 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -42,7 +42,7 @@ static struct reparse_data_buffer *reparse_buf_ptr(struct kvec *iov)
 {
 	struct reparse_data_buffer *buf;
 	struct smb2_ioctl_rsp *io = iov->iov_base;
-	u32 off, count, len;
+	u32 off, count, len, rdlen;
 
 	count = le32_to_cpu(io->OutputCount);
 	off = le32_to_cpu(io->OutputOffset);
@@ -51,7 +51,11 @@ static struct reparse_data_buffer *reparse_buf_ptr(struct kvec *iov)
 
 	buf = (struct reparse_data_buffer *)((u8 *)io + off);
 	len = sizeof(*buf);
-	if (count < len || count < le16_to_cpu(buf->ReparseDataLength) + len)
+	if (count < len)
+		return ERR_PTR(-EIO);
+
+	rdlen = le16_to_cpu(buf->ReparseDataLength);
+	if (count < rdlen + len)
 		return ERR_PTR(-EIO);
 	return buf;
 }
-- 
2.53.0



