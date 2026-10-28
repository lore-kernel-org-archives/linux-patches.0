Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215393;
	b=m9QmayQQ4WoJCMGjRiF9rgHE5sU1nTKHlGohSJNCyhmRvu71Zl9JCCu5PFnL7BIHD4Oe
	 fIRimTb7WVIEbUz19SS73gzK7WO3Ws/IUz2s39D7xK3GvMaApjXBoYdDTUdo8b58Tj9hx
	 NOM1p6wvDbqJyISrmbOfWqDcjDCoosuVVofhycLRFm+UYSdF06XS5THZmUpzi5rSG33Wk
	 PXLl6fLOD9afaL5BEt8olu4gwoIDA/2m6vcQZ8j+T7bUyenRbcN3tuvo72mmJE+5wdlvY
	 fun6f+fd9WFQx0xDDVoyF0HW99F2qorvyXeXL0n6Npuf4zkhbmj7S9EOZGL5NXk+DMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QIcJ7JMOucwlmisZIp1k0mSnuqnaMFDYH+OxchgLOVQ=;
	b=TsVQriKwsz85JBDPJi+76JdvTvo/JUFs7Ip6qZkeI9K6Kuh74OT5ZCA1UxWpQwihVTpD
	 7ohRgIZf2E+Q357j4sqeL5iw3oImJ128W+kBOV5iGOWrDpBXZyDgRLeDPXjtjmCVDsTmG
	 +aqxjc1GRDs4aJPE2TtTrDCnwJAqhd6saQMWDEp7AS5+oPR41I3u4B3eEiBXEqgiShiNr
	 N2CkaiQ4ISkMmUcjDX8gH3PvwUMjjnbKpEmq0H7qgKqRI+gwuOOclKOXrQjJPbXnrroM6
	 e9mdni315ahaO5O3aGJ9JWM2TiLGW8RW6kbSNgdfudjVl+dw5B6nSP2xHjJCGqA1cWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNiZ43iQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181CD606A31A;
	Wed, 28 Oct 2026 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNiZ43iQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620E11F01828;
	Wed, 28 Oct 2026 19:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215392;
	bh=QIcJ7JMOucwlmisZIp1k0mSnuqnaMFDYH+OxchgLOVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNiZ43iQ5RfcQo5YdrCxrLEjhhzb+3bifVTOKl30Y8Ehpw+sIgLnyqo7KCW12Rd/z
	 Rlc+Q5yLO2FQ6ttx6jg2eVhJfB6sThoqMFyPsj8amlu51lqyt59hvXLcADMHSAimAE
	 AN1d6WDdUnxZCq5Q+wiJquxJCg7TRwZHqrFlJlHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1196/1887] ovl: check access to copy_file_range source with src mounter creds
Date: Wed, 28 Oct 2026 17:54:52 +0100
Message-ID: <20261028170526.622617885@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit a1e0eb8f55cfe09bb31a202a388babc411292656 ]

Commit 5dae222a5ff0c ("vfs: allow copy_file_range to copy across devices")
allowed filesystems that implement the copy_file_range() f_op to decide
if they want to access cross-sb copy from/to the same fs type.

The same commit added checks to verify same sb copy for filesystems that
implement ->copy_file_range() and do not support cross-sb copy at the
time, namely, to ceph, fuse and nfs.

The two remaining fs which implement ->copy_file_range(), cifs and
overlayfs started to support cross-sb copy from this time.

While overlayfs does support cross-sb copy when the two underlying files
are on the same base fs, the copy operation on the two real files from
two different overalyfs filesystems is performed with the mounter
creds of the destination overlayfs and the read permission access hook
for the source file was called with the wrong creds.

This could cause either deny of access to copy which would otherwise be
allowed (e.g. with splice) or allow read access to file which would
otherwise be denied.

Fix the latter case by explicitly verifying read access to source file
with the source overlayfs mounter creds.

The former case remains a quirk of cross-sb overlayfs copy, but
userspace could fall back to regular copy so no harm done.

Fixes: 5dae222a5ff0c ("vfs: allow copy_file_range to copy across devices")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260712122421.203113-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index cc0c077165bde..3eec30bb6406e 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -570,6 +570,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    loff_t len, unsigned int flags, enum ovl_copyop op)
 {
+	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct fd real_in, real_out;
 	const struct cred *old_cred;
@@ -594,7 +595,23 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 		goto out_unlock;
 	}
 
-	old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
+	/*
+	 * For cross-sb copy, vfs_copy_file_range() will verify read access with
+	 * the mounter creds of the dest fs mounter, so we need to explicitly
+	 * verify read access with the source mounter creds.
+	 */
+	if (unlikely(inode_in->i_sb != inode_out->i_sb)) {
+		old_cred = ovl_override_creds(inode_in->i_sb);
+		ret = rw_verify_area(READ, real_in.file, &pos_in, len);
+		revert_creds(old_cred);
+		if (unlikely(ret)) {
+			fdput(real_in);
+			fdput(real_out);
+			goto out_unlock;
+		}
+	}
+
+	old_cred = ovl_override_creds(inode_out->i_sb);
 	switch (op) {
 	case OVL_COPY:
 		ret = vfs_copy_file_range(real_in.file, pos_in,
-- 
2.53.0



