Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029021;
	b=ql72M/zE5HPMNo4I6KC5QatI/Dl4cUUIExBR99PJECFI5q752BqTrMzYKWoU8RKoWJO5
	 McyBMVbPhUi+tvSG2h3DSKuyz+yMVQ3yt5v6PzzHUObgImhxzsr1cX2MTZfVfqIHnu+hQ
	 KPZ81Iz3EDYwWlsYcIP7geny3Acni4Bze1g6EpmVaKQtqTm7sj905qq6PDfdB0YYe4W9z
	 3lJ2cLh0+WQ5utFxLIRAu5wR4sD9PD4U23gXlbOEqWb0SWiXVxUfuaj/umI6XSv+pt5/g
	 1IZhzTzaG9rp38STcEAl6DlwoqlEGH5a8GxmG1BHPO3u1H77URlQ4S7NpA+ASzzpn/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BRTLCUX35QIddx+5/P4OzVverNKQp81JznglTPddkO0=;
	b=SHd6uTSluv5CCLF1TEH2GZA7XkkFdYMAYHXOvTznknnp++sosNAbxEWyBF/zo9wcYQ1r
	 RMN1yOCTP6hIcFhtbHMQ2zhxOo5wHWdQa+MRrxLwcMbfP7blTMw404YeX1KDKCdmjuBE0
	 I4PVgv31D/PIQW4SeoVMBC/z6HJ6cR0x4mTxBp3rCioN8yrcCljFWPahhh+kTesWumG2+
	 cwmjJ8Qt0Jk7xhNe+3N7ky7tPELtUifveu+bDI/u9gOzly4RkmABNX7ERO8Nsoxgo6An2
	 X5/VEH2ogVfatztArmhaPj/5vCSVcG38tJITTtkLakOZvI6Lu6kzHnyr2Xt2KtEjqwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NefW5awr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01E9606A320;
	Wed, 18 Nov 2026 19:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NefW5awr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F6B1F000C4;
	Wed, 18 Nov 2026 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029021;
	bh=BRTLCUX35QIddx+5/P4OzVverNKQp81JznglTPddkO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NefW5awrNe6EsCz51is1aDzbYXKZjsM397UYVrPRkAciVK/TmE945rgoYRkRprmvo
	 PYtuoi+jSUV6kRDsc9YlEuJHMDJj3z88X41m5EQCYeITDYFkJ5lcJt57yfD0trBrwt
	 bkzstGFGmNSe4ElnRRUjMDBTCjTBM+vfPFqs6zMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0200/1756] fuse: fall back to copy_splice_read() on FOPEN_DIRECT_IO
Date: Wed, 18 Nov 2026 15:38:47 +0100
Message-ID: <20261118150016.336982043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 10bd6b32965265688fa277d166ab224de8e86eb2 ]

Yafang Shao reports:

  "After upgrading the kernel from 6.1.y to 6.18.y on production servers,
  some containers failed to read lxcfs data. The root cause is that our
  lxcfs is still at the old v3.0.4, which does not include commit 25982f5
  ("Set the file size to 4k") [0].

  Between 6.1.y and 6.18.y, the FUSE splice_read path was converted from
  generic_file_splice_read() to filemap_splice_read() by commit
  2cb1e08985e3 ("splice: Use filemap_splice_read() instead of
  generic_file_splice_read()"). Unlike generic_file_splice_read(),
  filemap_splice_read() strictly checks i_size and refuses to read from
  zero-size files, which breaks virtual FUSE filesystems like the old
  lxcfs."

Fix by using copy_splice_read() for the FOPEN_DIRECT_IO case, just like the
VFS does for DAX and O_DIRECT files.

Reported-by: Yafang Shao <laoar.shao@gmail.com>
Closes: https://lore.kernel.org/all/20260706025705.58301-1-laoar.shao@gmail.com/
Reported-by: Changyuan Lyu <changyuanl@google.com>
Closes: https://lore.kernel.org/all/20260901213412.1763253-1-changyuanl@google.com/
Fixes: 2cb1e08985e3 ("splice: Use filemap_splice_read() instead of generic_file_splice_read()")
Tested-and-acked-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index cada359fd03a2..f733a0f781146 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1795,7 +1795,10 @@ static ssize_t fuse_splice_read(struct file *in, loff_t *ppos,
 	struct fuse_file *ff = in->private_data;
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
-	if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
+
+	if (ff->open_flags & FOPEN_DIRECT_IO)
+		return copy_splice_read(in, ppos, pipe, len, flags);
+	else if (fuse_file_passthrough(ff))
 		return fuse_passthrough_splice_read(in, ppos, pipe, len, flags);
 	else
 		return filemap_splice_read(in, ppos, pipe, len, flags);
-- 
2.53.0



