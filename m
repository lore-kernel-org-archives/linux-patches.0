Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15E53A9879;
	Sat, 17 Oct 2026 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257071; cv=none; b=lvHZPoUoEvmTM+lMTcLLbil+ESGxq9a1G/OpLpKFoPSSiX4uGPuOf+cqK5ZcBLO1PbmwHmdSU7VGZX7PQNDd7DHKXqWarxuQ86pIx5GIbECAk3DCtoz7vbPmjo9LT8EfHUP4uDLBrQ3+nhWmd7G/am+++s4aSZQlWEk5SLeSX5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257071; c=relaxed/simple;
	bh=JHcP7QKLmvCPQwwQyRRRdB8g4bsNxhfbxwNdGEhD0mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzRIFkex/sgR3f5ZlR4cl+VvO9CMTQpdSaSGBrVuHdFBEPVPCDO9k6IXoLiiBPrBHsggDYy8UY5CDO+D0NHZzkT9sHnv1eHPkO3FkxjLz85GqqYy/34lqrafgh1wBAFHegwnJXnJ+vwOUuu8HrdERZPuSM32r9aajQNWsdWSntk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYE/JaCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYE/JaCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0501F000C4;
	Sat, 17 Oct 2026 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257069;
	bh=0eRqk1HkHfJPBcY/97Ebl60BUuA+ywWzRV9UqvqKFAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYE/JaCuVA5lMxdGiYWa9rPsFW+RynqfgJR+dFPGNhVGyKyMytE5vXiMXf4+BEDn4
	 J/QP9xAu6/y2lBfq9AcihqCg5Bg8/fjkvWMWe4i0XS3JaLYroZhMeu+l6vd1xKCJ1l
	 jFNrC/sJt1iK0tMZGeA3n7ReqYv+hCK2ZGz58Gwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0443/1674] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Sat, 17 Oct 2026 17:45:15 +0200
Message-ID: <20261017160442.493613918@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit da4fe97fb6c730d9c94a115c7bfa6f98e0d578d0 ]

smb3_zero_range() removed the pagecache only for the range being zeroed,
so when it extends the file the folio straddling the old EOF - which may
hold data dirtied past EOF through an mmap - was never dropped and became
visible as file content once the file was extended.

Lower the discard boundary to the smaller of the zero-range offset and the
old EOF.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Adjusted context due to the missing netfs_wait_for_outstanding_io() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 887ffa77aa183..a82abe2e8ce14 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3283,8 +3283,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
+	 *
+	 * Start at the old EOF when extending so the folio straddling it, which
+	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	truncate_pagecache_range(inode, offset, offset + len - 1);
+	truncate_pagecache_range(inode, min(offset, i_size), offset + len - 1);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
 	rc = -EOPNOTSUPP;
-- 
2.53.0



