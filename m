Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6885D509EF9;
	Wed, 30 Sep 2026 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784958; cv=none; b=pl4NuAeT8tb18D6xcK9gpWJWteraojElMHq524j0KRAyLnG1bY8UbZocm1PdGMmoWFWJNm0Hc2AEcOKhZH4Ymiiv6FMEmAzRRaOIEDUTjxgRd0fFzc8U0zkZVFZcI/4ibGO1hITSjsS61w0QDdQCDynpdduEKzFiGiBkf1ATgts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784958; c=relaxed/simple;
	bh=TF+hXOGLh48iyuJwszI4F4i0BY7L3U72CfWXWxbEqTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyOMPBFOz0lgAaqeK85uFr0epcmvl201kiqxJJjOC0QX11KPYkZTlU79hldzgk81DP7LvF08IZZEp+m3c1PlPleXV7sl88l1P1oB6LB9uGt96e/hAX2kTkKwp+2bVbP+Htkgc/5ekxgk2EpM5v2PKmKLqrzQYM2pg5KfCLXZ9/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXtNhsjy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXtNhsjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522D21F00893;
	Wed, 30 Sep 2026 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784954;
	bh=yEK0wOLx+klMXLPLNcaTWbUX8e526+Plh71XvAmAx7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXtNhsjy2iCBdueyKaIGGikDion9GSWkKU1fCcpyworCVvXE4UuQ5SXhRsfiLpm2F
	 EpfqrvHx2hIGW2MHA8ztGJy6MerSahs2riDqv9DJ1U+uVJPjfBasbDTXzpb8m+SMSx
	 lqSo5HlprZlPuirH3Hm4KXBkqxPov2m9+XrJJZh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 337/982] smb/client: mark file sparse before emulating insert range
Date: Wed, 30 Sep 2026 17:17:53 +0200
Message-ID: <20260930152424.057916415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit cd03ce4950d80147ac8f20bc03c42b75b0352407 ]

The SMB client emulates FALLOC_FL_INSERT_RANGE with SET_EOF, COPYCHUNK
and SET_ZERO_DATA.

SET_ZERO_DATA creates a hole only when the file is sparse. On a
non-sparse file, it clears the inserted range but leaves its blocks
allocated, causing the extent count check in xfstests generic/064 to
fail.

Fix this by marking the file sparse before modifying it.

This patch produces the expected sparse extents in xfstests generic/064
only when the server-reported block size is compatible with the server's
deallocation granularity.

For ksmbd, the reported block size follows the backing filesystem,
and the test passes. For Samba, the test passes with a block size
matching the backend granularity, for example, 4 KiB on Btrfs, but not
with the default 1 KiB value. For Windows Server 2022, 4 KiB inserts do
not generate holes, while aligned inserts of 64 KiB or larger do.

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2b38e8e7efd4e..644c19c05237b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3945,6 +3945,11 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	count = old_eof - off;
 	eof = cpu_to_le64(old_eof + len);
 
+	/* SET_ZERO_DATA creates a hole only in a sparse file. */
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, true);
+	if (rc)
+		goto out;
+
 	filemap_invalidate_lock(inode->i_mapping);
 	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof + len - 1);
 	if (rc < 0)
-- 
2.53.0



