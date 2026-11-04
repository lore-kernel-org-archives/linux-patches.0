Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828859;
	b=3pVGkEiob2fPpwbgCHEy8J/3he1mxxz7BxxKqaiFttpw7HI1zTUMS9E9gZbhcZIY+D55
	 rdQZXrPCHrX0OOTjjl6NW2SS1hEgrGjgMGHl0ql03rNLdqWUtkdN1gPlMKxAIKuY//sDr
	 C5kHwsBjo3ETw25Skma6+jDk7vPTDMpDsWn8PD0tUncTcmdKlf66d6Xf3ORXhUxpiTdHN
	 RWGlKonG/c+eiozBHaB8bCWoKs2BLI7BvxlCB8ZqOM8p34DZfUDhhCICFGJxbbizLi62b
	 6geZWwHDI+ZNsR0/p5/Xo+oiTb+CPK8B9NTDU3A+RBCViJANqF8hm+yGigIvT2j99Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/liF4Ryb2PKVlqaqqxdV6s7A7/dtvNuhnTk6ntSzBcc=;
	b=OU69eVk8VYzlpZzrL+CtFBXpyVsnHbAthP6Q9/RFLX2RQSwgons8dJ7LQkvqgxCMYzt3
	 rGFAO/wwJHPr2YgPtYNmBwxyPl4CsAFN6GW3Ik6FEB5M4f9iijiT/t8cqp8I8nRu1E1fC
	 ntkxwryGwwFGzurtO1ViBhgHFKlAdVbwmQ//QWx/vq0fRqweFsiHPfAUfhEYoVsNa1+Hf
	 ULbMOsTx/XnHJcu4MAsDxy9ff+csi4f3KXA9PvroigsmNghCVD4oOkPl6khgcZeOefiSf
	 /AzqX7C/uYmaS+PGEjkGCfWxHb+HXcOLI/9Ne3feUunDv0vBaf0prqkhaFEr0Dt5hsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+1hnIAx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEDE6070F18;
	Wed,  4 Nov 2026 21:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+1hnIAx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9EB1F000C1;
	Wed,  4 Nov 2026 21:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828858;
	bh=/liF4Ryb2PKVlqaqqxdV6s7A7/dtvNuhnTk6ntSzBcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+1hnIAxwVfh+9QnKUcXTsfzNDBZhHmXh8Xi5Eu2WwwmQRLavGBXMXoKfPe/MA7Uz
	 StqS8uM8A+ntrjRqpRpWTJiWobduBiP5Dli5XZSsTOe5isugYKRKb6Q+uBNlGOlPt7
	 /PePxgj+axLQf9IO2k1OMrz545YM4EvybWuDnZew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 285/547] ovl: use the pinned upper dir in ovl_fix_origin()
Date: Wed,  4 Nov 2026 16:07:49 -0500
Message-ID: <20261104211046.297992946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 4f61ff2ebfb3d2967b83b6a4d456242244d5a61f upstream.

Renames made directly on the upper filesystem during a lookup crash the
kernel.

A dentry that is passed to vfs_setxattr() must be pinned.
ovl_fix_origin() passes upper->d_parent to ovl_set_impure() without a
reference, and the lookup holds no lock of the upper directory. A
rename on the upper filesystem changes d_parent, and only the child
pins the new parent, so a second rename and an rmdir free it.

With delays in ovl_fix_origin() and ovl_set_impure(), renaming the upper
directory twice and removing the intermediate parent during the lookup
of a merge directory without an origin xattr gave a KASAN
use-after-free in vfs_setxattr().

Fix this by passing the upper dentry that the overlay parent holds.

Fixes: 9678e6303057 ("ovl: fix inconsistent d_ino for legacy merge dir")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: add helper ovl_set_impure_dir()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c     |    6 ++++--
 fs/overlayfs/overlayfs.h |    6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -942,8 +942,10 @@ static int ovl_fix_origin(struct ovl_fs
 		goto out;
 
 	err = ovl_set_origin_fh(ofs, fh, upper);
-	if (!err)
-		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
+	if (!err) {
+		/* upper->d_parent is not stable, use the overlay parent */
+		err = ovl_set_impure_dir(dentry->d_parent);
+	}
 
 	ovl_drop_write(dentry);
 out:
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -572,6 +572,12 @@ int ovl_check_setxattr(struct ovl_fs *of
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr);
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
+
+static inline int ovl_set_impure_dir(struct dentry *dentry)
+{
+	return ovl_set_impure(dentry, ovl_dentry_upper(dentry));
+}
+
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_is_inuse(struct dentry *dentry);


