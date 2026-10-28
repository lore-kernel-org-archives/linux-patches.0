Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215618;
	b=Y28Cse4ivaVfebsVpvCHr2CqcWhRKh9x1FZ0mzW3WdyKSUspxJK0QQveVXK06VNaCID6
	 OOA8lRqzNd5z7SWTyetEdZ6Zt6X7p7z0/82rT1wzcoaoLwMumRALR/GeC+Yt4Ziktk6FB
	 5MeDMlzZ3t+zQ/tDBDLX77gVX+mcGwCyG9NZerci0h8S3IQ+c6BgemB6rjTrP7wQP1N2o
	 TNfwnvK6Jdpmmw1ynT8n1bVVvB3g5gQ8i9RlCHtdOgB0BKvBFr7WL8S1F2IYuz3g1KKnv
	 R2H+GJTSqauY3Fpe90mac7b1rp3RRAFqvz7QhlFHf+OrrA4CQgnutzzwh7SgMAvfOXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VIkcR21hSP6jZ8d/OfPlMrOXEJGSPMXvPLRn1AvZCSQ=;
	b=S6aVs30gsUUp81gSLoZfXvfrEqPWcgfWNSGp42nj9eRIczs/shpY0k6+3BcmSXIJzwgb
	 riSwOu3sef60fwwLCCtvadfQHhitmoIuhAE7CoHB2YMQpmjDyZeISAIrsCnnj2hxecfcv
	 uB7lhQ0mCKdIVd+449++TeJsQPSUtpyN/f7ZHcN2rtXVC2MOeH2oagmqcuqws5Bch0h+a
	 cj0NkYlcHe71UQIVEJBLJKh9o2Hx2Xjq8hHo/wuVX9pRA9K31cQptOYAJWyPtj0FpMdtR
	 ybNgUPOZ102rJPxK22I4P5ROBvote+kamV0sG6yEZel5Pyo0Xc+WEEs/WCaEPQA2otQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3TLw42C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFE3606A31C;
	Wed, 28 Oct 2026 19:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3TLw42C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11EB1F01825;
	Wed, 28 Oct 2026 19:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215617;
	bh=VIkcR21hSP6jZ8d/OfPlMrOXEJGSPMXvPLRn1AvZCSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3TLw42CIYNhBypdOVux5l4BuHj73HN3nTEv54si7nolsxanuhJn+njNEQ6TxwbE/
	 C3PkQDactvJRGIqRjxcnAH5lftPv5TXX6M0zHfolY7lN7dXhMvkSAknEWwZlr77OwQ
	 Y7do0Bpcy5ybo//tZCiU60js7s59fundU5KRzX+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1230/1887] fs: refuse O_TMPFILE creation with an unmapped fsuid or fsgid
Date: Wed, 28 Oct 2026 17:55:26 +0100
Message-ID: <20261028170527.412654209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 539dce1144651f7976fa418e618b0b574bf15eeb ]

vfs_tmpfile() never checked that the caller's fsuid and fsgid map into
the filesystem.  On an idmapped mount whose idmapping does not cover the
caller's fs{u,g}id, the ->tmpfile() instance initializes the new inode
through inode_init_owner(), where mapped_fsuid()/mapped_fsgid() return
INVALID_UID/INVALID_GID, and the tmpfile ends up owned by (uid_t)-1.

Every other creation path already refuses this: may_o_create() (O_CREAT)
and may_create_dentry() (mkdir, mknod, symlink, link) bail out with
-EOVERFLOW via fsuidgid_has_mapping() precisely so that an object cannot
be created with an owner the filesystem cannot represent.  An O_TMPFILE
is no exception: it is created I_LINKABLE and linkat(2) can splice it
into the namespace afterwards, so the same guarantee must hold.

Add the missing fsuidgid_has_mapping() check to vfs_tmpfile().  On a
non-idmapped mount the caller's fs{u,g}id always map in the superblock's
user namespace, so this is a no-op there and only takes effect on an
idmapped mount that does not map the caller.  It applies to every
filesystem that sets FS_ALLOW_IDMAP and implements ->tmpfile() (tmpfs,
ext4, btrfs, xfs, f2fs, ...), and to overlayfs, whose upper-layer
tmpfile creation funnels through vfs_tmpfile() via backing_tmpfile_open().

Fixes: 8e5389132ab4 ("fs: introduce fsuidgid_has_mapping() helper")
Link: https://patch.msgid.link/20260615-work-idmapped-tmpfile-v1-1-754a94d81f83@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3713,6 +3713,10 @@ static int vfs_tmpfile(struct user_names
 	int error;
 	int open_flag = file->f_flags;
 
+	/* A tmpfile is I_LINKABLE, so guard its owner like may_o_create(). */
+	if (!fsuidgid_has_mapping(dir->i_sb, mnt_userns))
+		return -EOVERFLOW;
+
 	/* we want directory to be writable */
 	error = inode_permission(mnt_userns, dir, MAY_WRITE | MAY_EXEC);
 	if (error)


