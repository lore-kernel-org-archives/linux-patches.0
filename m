Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047472;
	b=J8CHTHlL41jfemRxuCBcw7C847HcAt06Qrs/FSL9ymv20DqhMbHyjBRIIx5PetH/xWuK
	 j+AQ3yBzxHzyJEAoCbFDHnV9OxY080FI7nB88A9NgdGH2WyT2T9S2euoGnMKXkpK06iCS
	 wDjdFfp3lRwFV6N1ZdwC53vApSmOGKoCE1aPkLxoBd4cggalX7j/GAgI1IcoScLpojUpv
	 KoEY/siziyykIcmqAlD25P8k+h9EtdqSPytGpykDK5mXyn+k5e6zS745Slq+ugq8JY/Bv
	 n2qqrzm95IaKt7lsc8PXwpR96QZ2IOcrYP9CrpeyUfUe3LA7b+vHT+ZKTlFUM0fKl9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c0uR/egapLuWlk9/50Hn7oCcWYG+AefqQY+TrHhd49A=;
	b=3XitDLVlA6pLOK1xnq5QrcLU3xbqwm018c5bDU3g66xBizY/a7g6s+hPIt7nSlkLwMlv
	 hTi67rzEN4VSHYHshJHCrrdP1WE5sgvrWTwVOmGeMhWOqb23BPjfoxJKzknuAf7tC3+xo
	 uEvV1H5BEQ8zYGqTaYx9ri8wbzFe1e3gHat3g++ht1g5SVBOtJu8fIehSWrePBixVjCRM
	 NiMEGk2PvYdDbZAhNu3GGOxT8DSLXOr7SrccUUAUjj4aqTj24SnD3yoJiSdMfSixf2zI/
	 bm7WEcW0R655wMwifbuLnjFiSbqaFpYoFUC5GriCu2l1POXw8O8q/TTPAAipFdJYGdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAn1nr8a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30A4606A330;
	Thu, 19 Nov 2026 00:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAn1nr8a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EC51F000C4;
	Thu, 19 Nov 2026 00:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047472;
	bh=c0uR/egapLuWlk9/50Hn7oCcWYG+AefqQY+TrHhd49A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAn1nr8a/KD89dtOT8u3EZGfKJDhiNbcQvW+0XcjEK6ammv3uJDMPl95pBSMsB2BM
	 fppYnloCCWIvAJfhLzxjr8EFacl9bhq2xfqIDUo/Avld/vU4RMc5t1XC4yn7S+t9iB
	 Fcz75JeXj4zU7WIBtK65siy+DyyzJEL/F6IEv3kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1652/2857] ovl: look up the index by the decoded origin
Date: Wed, 18 Nov 2026 15:44:46 +0100
Message-ID: <20261118150300.816604382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 520ef67f47f69255695859b0008281a384d0bc20 ]

A file opened by file handle on an overlay with nfs_export=on can show
the stale lower data of a file that was copied up to the upper layer.
While the file opened this way stays in the inode cache, a lookup of the
copied up file by path fails with ESTALE for all users. The open can
also succeed for a file that was removed, where it has to fail with
ESTALE. This happens with a handle that has one byte changed. The handle
comes from an NFS client, or from a process that calls
open_by_handle_at() with CAP_DAC_READ_SEARCH in the initial user
namespace.

When a file in a lower layer is about to be modified, overlayfs first
copies it to the upper layer (copy up). With nfs_export=on, each copy up
also creates an entry in the index directory, a directory that overlayfs
keeps for itself on the upper filesystem.

The handle of an overlay file that comes from a lower layer wraps the
handle of its lower inode. Overlayfs calls this lower inode the origin.
The overlay handle stays valid after a copy up.

To decode such a handle, ovl_lower_fh_to_d() first decodes the wrapped
handle to the origin. If no overlay inode is cached for the origin, it
looks in the index directory:

- An index entry there leads to the upper file.
- A whiteout, the marker that overlayfs uses for a removed file, means
  that the overlay file was removed.

The name of an index entry is the handle that copy up encoded for the
origin, as a hex string.

ovl_lower_fh_to_d() builds the name for this lookup from the bytes that
the caller passed in. But handles with different bytes can decode to the
same inode:

- Overlayfs ignores some flag bits of the handle.
- A lower filesystem can accept a different fid type, extra bytes, or
  generation 0 for any generation.

Such a handle decodes to the origin but misses the index entry or the
whiteout. So the decode returns an overlay inode that has only the lower
file.

While that inode is cached, a path lookup of a copied up file fails with
ESTALE, since the upper file that the lookup finds does not match the
cached inode, which has none.

Reproduced on tmpfs and on ext4 with open_by_handle_at(), after a copy
up and a mount cycle. A handle in which one flag bit, the fid type, the
length or the generation was changed read the old lower data, and path
lookups returned ESTALE.

Fix this by re-encoding the decoded origin and building the index name
from that handle.

Fixes: f71bd9cfb692 ("ovl: decode indexed non-dir file handles")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: adjusted context for direct ofs->indexdir access instead of ovl_indexdir(sb) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/overlayfs.rst |  3 ++-
 fs/overlayfs/export.c                   |  4 ++--
 fs/overlayfs/namei.c                    | 13 ++++++++++---
 fs/overlayfs/overlayfs.h                |  2 +-
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 4c76fda076454..e5d38f0211e54 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -534,7 +534,8 @@ When decoding an overlay file handle, the following steps are followed:
 
 1. Find underlying layer by UUID and path type information.
 2. Decode the underlying filesystem file handle to underlying dentry.
-3. For a lower file handle, lookup the handle in index directory by name.
+3. For a lower file handle, encode the decoded underlying inode again and
+   lookup that handle in index directory by name.
 4. If a whiteout is found in index, return ESTALE. This represents an
    overlay object that was deleted after its file handle was encoded.
 5. For a non-directory, instantiate a disconnected overlay dentry from the
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index e55363d343dc6..d43af7c820cff 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -726,9 +726,9 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 		}
 	}
 
-	/* Then lookup indexed upper/whiteout by origin fh */
+	/* Then lookup indexed upper/whiteout by origin */
 	if (ofs->indexdir) {
-		index = ovl_get_index_fh(ofs, fh);
+		index = ovl_get_index_origin(ofs, origin.dentry);
 		err = PTR_ERR(index);
 		if (IS_ERR(index)) {
 			index = NULL;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index cf805c99cfb9f..124c437e65e6a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -667,14 +667,21 @@ int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 	return err;
 }
 
-/* Lookup index by file handle for NFS export */
-struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh)
+/*
+ * Lookup index by decoded origin for NFS export.
+ *
+ * The name of an index is the hex of the file handle that copy up encoded.
+ * The bytes of the handle to decode cannot be used as the name, because a
+ * lower fs may decode many handles to the same inode.  For example, it may
+ * ignore the fid type, extra fid bytes or a zero generation.
+ */
+struct dentry *ovl_get_index_origin(struct ovl_fs *ofs, struct dentry *origin)
 {
 	struct dentry *index;
 	struct qstr name;
 	int err;
 
-	err = ovl_get_index_name_fh(fh, &name);
+	err = ovl_get_index_name(ofs, origin, &name);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 18d8cd614ef20..8d15096a3f994 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -537,7 +537,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
 int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 		       struct qstr *name);
-struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
+struct dentry *ovl_get_index_origin(struct ovl_fs *ofs, struct dentry *origin);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
-- 
2.53.0



