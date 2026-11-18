Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055213;
	b=QIl+xUR5buMet6yV5Whtsdp5CglviQdg1ht9uXSUetb84iS5g37zYZud49QK0JgRqPGa
	 nnsMD1jqqV3+wvjSq0uYkfCdIXG1bUUm46z/Ca5WEyYtXtYK21lFnIE70Y4bibzkrKBB8
	 F7SuB/JWqpth1X1cK0IPV9EWcvfa84Gph/P3yavHT6iqXy9bspndBud1yaDgrj0bk1Iyu
	 MmCq1LZ1K9fBACdj6Gq9fKzu+2vTzKUZrbOzMsBh55x++3ojqu/4PM5M2zJNFrq/jJtx1
	 Flnw8M44e7lmqYYWkLKrfwqIZo1P8gIT0uMViIyey/DoCNkvuX59SOjw610w5UjXf5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QF4RXrIgYkTbVVvpqiVNgROjiGROOxsxflIqFmzWCVw=;
	b=yHyeacymHeT1glFpCwrQURSG6kcUbvWJkcEj3pq4l3aJoLHs7I1rcXobkZA2F6j1nwve
	 853DeDiG9vqDxZUIDgSNh0WnEaC0LTLetUtEbZP/4DFsAmHyCKzC5PnuZ5hnrwBFJkHND
	 Vn1FHxeIeYvm1RvhI+KfrNR6+IN4yed2MRhy9yn7QSdbQlPUDgGhex+MR5NExJq7SISm0
	 XjT30llt3Ej3dTPZLRDJhKmuy1jILQcNaWnrqWMlMm7HYY0BMDgJneDPGMd6cvKY3M6gv
	 Jg9WFHeF2iczrkrPRCCZwYZ0IFVH+P5ekMEzS6JqXB05sx7Jm9ur/V7DFeHITY/TxYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VkGcgQJS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA3A606A31C;
	Thu, 19 Nov 2026 02:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VkGcgQJS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08331F000C4;
	Thu, 19 Nov 2026 02:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055213;
	bh=QF4RXrIgYkTbVVvpqiVNgROjiGROOxsxflIqFmzWCVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkGcgQJSVKCfY3XI1YOvlA+ZwY0OjZhRHlzTKGO+8DNcX5bw9TGa/ewGCUMy+Df1G
	 N9mPHz+adHMoUJExn/+I63BXTqLzKzOp4ndYSBGhV46mfDd+oZGgLFCsJdfVd/ozaj
	 8kA+ST4XIy972PJuqmS6Jk2f+Ep3BeYymy8Zc+vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1510/2214] ntfs3: fix out-of-bounds read in ntfs_read_mft()
Date: Wed, 18 Nov 2026 15:53:06 +0100
Message-ID: <20261118150112.426290684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 7a374d9be8267834dc534e55f01e5e01765cab4c ]

ntfs_read_mft() walks the attributes of an MFT record and, for each
FILE_NAME attribute, compares the resident on-disk name with the name
being looked up.  The only size check before the compare is
rsize >= SIZEOF_ATTRIBUTE_FILENAME, which covers the fixed header up to
and including name_len, but not the variable-length name that follows it.

name_len comes straight from disk and is not validated against the
resident data_size.  A crafted image can set name_len large while keeping
data_size at the header size, so ntfs_cmp_names_cpu() reads name_len
le16 characters past the end of the MFT record buffer:

  BUG: KASAN: slab-out-of-bounds in ntfs_cmp_names_cpu (fs/ntfs3/upcase.c:84)
  Read of size 2 at addr ffff888031879c00 by task a.out
   ntfs_cmp_names_cpu (fs/ntfs3/upcase.c:84)
   ntfs_iget5 (fs/ntfs3/inode.c:209)
   dir_search_u (fs/ntfs3/dir.c:265)
   ntfs_lookup (fs/ntfs3/namei.c:85)
   __lookup_slow (fs/namei.c:1915)
   lookup_slow (fs/namei.c:1932)
   path_lookupat (fs/namei.c:2278)
   vfs_statx (fs/stat.c)
   vfs_fstatat (fs/stat.c)
   __do_sys_newfstatat (fs/stat.c)

  Allocated by task:
   mi_init (fs/ntfs3/record.c)
   ntfs_iget5 (fs/ntfs3/inode.c)
   dir_search_u (fs/ntfs3/dir.c)
   ntfs_lookup (fs/ntfs3/namei.c)

Check that the name fits in the resident data before using it.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index bccfd60db7de7..eb89fb3a7f4f1 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -198,6 +198,11 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 		names += 1;
 		fname = Add2Ptr(attr, roff);
+
+		/* Make sure the full name fits in the resident data. */
+		if (rsize < fname_full_size(fname))
+			goto out;
+
 		if (fname->type == FILE_NAME_DOS)
 			goto next_attr;
 
-- 
2.53.0



