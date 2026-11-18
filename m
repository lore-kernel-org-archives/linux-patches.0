Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060039;
	b=1ShSwYeC46QCV+02Mt7F4Q0TdHNqZJgDgQt0vPWmP0DD+3fPRjUxV2ONddeLOfqkBBch
	 0K0Vu9eMi+dtZ0h6maiioJPIXWN4qD2AL897JjyCcwgkNxA9TNOoovtFMHMWjVd658Icf
	 qg2FSt1bRgQjZ1kDhy9GoRRXeVv/AsTtS/VtUoB3EwaCC+9UVWPIVHkyVcFT8l/kznPdW
	 hDq1CuLDMC35u0RLr353HnFknKhsy1jdkynTF0uNV5MLnOyM0poKOnUn6xVBU9z2RD1R4
	 RgBeS8qnvLl7CexZ1XIcAWEb6p+YmRtGiArkWNtNhzPIl6XWbBVPHZDkcieCTtwaoSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cvydf1Yo6lLQgG1jpV0sc419tpy3sLkPmLdpp7hfffs=;
	b=HnMK+NRxGH1rQFs5LvY6QAlBbDNBnLyXXSyJBlaAjQAclC1kU+6p2QCrOKf7mlGNPaBn
	 2cFzsmC+E6pBlN4sx5aOsATk/Ui/RRgFx7ufhZxqloQZKj/sIFKTnpS2mTrODls3/jT14
	 0BW1de9jnhXP3BJgiuNYAIUiEKi0IT+sTfZxtHrCNAkZ1Q7ywB0V49aH2PpYzJcBeSjNX
	 TUhD9WsuPgYuUomXTy0qVEjxL6toxl8rr4Wsc1SFYGs4oqrPr2vkNXNaiit+2Fc+ncRB5
	 L4EboV98bjKf+cgtfM0tjWRf2hd9/QWN64shrPC4lyQEe159OxLzRHRimU37kwQep+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7JbOxMw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AED606A325;
	Thu, 19 Nov 2026 03:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7JbOxMw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133271F000C4;
	Thu, 19 Nov 2026 03:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060038;
	bh=Cvydf1Yo6lLQgG1jpV0sc419tpy3sLkPmLdpp7hfffs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7JbOxMwNKYP0jn25rbGW6534UyHyC3amoWbrF9H8SEtALbVMQ+fbpcgWW9Gp0Oup
	 3DRK+S8aQ2H/aAt1WDLkB1E5KhbaYBxKjnnN4aUrDrLCZs/9Kp4owvBy/yjHTNxwq+
	 QdMmrh9htbDV+hJSKs1IO3bzkrPlXrHP+2XAa+CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1055/1848] ovl: look up the index by the decoded origin
Date: Wed, 18 Nov 2026 15:51:33 +0100
Message-ID: <20261118150001.553607506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Removed the ofs argument from ovl_get_index_name() to match the existing two-argument helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/overlayfs.rst |  3 ++-
 fs/overlayfs/export.c                   |  4 ++--
 fs/overlayfs/namei.c                    | 13 ++++++++++---
 fs/overlayfs/overlayfs.h                |  2 +-
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 137afeb3f581c..435aff7c52f65 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -527,7 +527,8 @@ When decoding an overlay file handle, the following steps are followed:
 
 1. Find underlying layer by UUID and path type information.
 2. Decode the underlying filesystem file handle to underlying dentry.
-3. For a lower file handle, lookup the handle in index directory by name.
+3. For a lower file handle, encode the decoded underlying inode again and
+   lookup that handle in index directory by name.
 4. If a whiteout is found in index, return ESTALE. This represents an
    overlay object that was deleted after its file handle was encoded.
 5. For a non-directory, instantiate a disconnected overlay dentry from the
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index dd3e1969e6c87..d85456e3607b4 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -719,9 +719,9 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
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
index 11be07632d188..9b09697754f75 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -655,14 +655,21 @@ int ovl_get_index_name(struct dentry *origin, struct qstr *name)
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
+	err = ovl_get_index_name(origin, &name);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c149329d71e78..3d2e45d885df7 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -415,7 +415,7 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
 struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
-struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
+struct dentry *ovl_get_index_origin(struct ovl_fs *ofs, struct dentry *origin);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
-- 
2.53.0



