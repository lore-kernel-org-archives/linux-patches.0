Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039873;
	b=a+XXrFd3O2ENHvbGrvCO+Qhh2Ka+Jm4tAHFUrzktvI6AucS9Wzm91vjrjTJTtqcnl/2Q
	 0Z9Risa21e8IJWVZpuFS8KVqTQygMz1/UFNeLxPmEVy55JJ8MJCt7p+M0cYCD0LxYZD8b
	 QVgDvA/3MqMDYEaOXz83TgXN2aRF4JXL+XahrrqZcbo3dgi1UCnNWhTItb5IvQlZLt8I3
	 /NTgY8Bslri/6OGRnbhJ75IzwLGPBxplcklZLxNZyhORQJCu08j26H6k8/7LTz5FrwrEd
	 9SGfrfsqF/aBhOcjvyyEdmO0vUYtGBdKH93MTGPcJuFz5vIDLkQkznI3OtxQP42e3nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uydeEVRb3TOUJPAJa2OaGvY0OPl+ibWRvSotakGlq4A=;
	b=Qm+FIKzXLl/Ra5RBFPtXDaegPUU2I8GP4u6OGIDvHg61Fl8IOLYLwFarcl9ItVxe/5i5
	 9pLzj7pid/rBRO1DibuhkprZ4dTTY1usyyAGtbCmJs156nAt+eSfZ4HJFqtrOmk0/L79k
	 vFbIkg1ACnjcn5MvhyLm6nIUdJ7IgGsGtTrPBsSd1J7Q7nlDBwkEEO0+n7FRe2LmZimdQ
	 JwfDOXWWK934n1Wyc3IDMzgDyOQqCvuR+eYNBHM9d2sw7cNARFUBwWCotLh3uwH+7fyoa
	 SuvO+oNHTQ8UhomA2GXC1APW4AjvbfbQSF2SDxQDfLf2PqBoodRRgj85Hmi6zA/uK4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zz7NXF/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDC9606A334;
	Wed, 18 Nov 2026 22:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zz7NXF/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5DE1F000C4;
	Wed, 18 Nov 2026 22:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039873;
	bh=uydeEVRb3TOUJPAJa2OaGvY0OPl+ibWRvSotakGlq4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz7NXF/ZKt36x3uHNQfye+CiCzc2oe/zPHGGwSPfoQLg2hcJUmMrKVwr3p2ifyx4G
	 MuONEpA3cImucxvCo5j7DW2WLXIkg16yevFf37808uA063vXeYxoGMVQ8nHVJ44fm9
	 ltqmE/eys+VJX6okx6DAs26GOSyN0t6I5reBrlmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2229/3318] ntfs3: fix out-of-bounds read in ntfs_read_mft()
Date: Wed, 18 Nov 2026 15:47:31 +0100
Message-ID: <20261118150428.747968461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2deb98b484660..dedc5937cd86a 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -206,6 +206,11 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
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



