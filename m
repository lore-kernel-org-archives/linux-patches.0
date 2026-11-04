Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828863;
	b=H2MAdYDXNHkM192UERElV/vpaopk6Ya7P24cUAdSuO12tL91x5XFmsknCxvGKtVpJZBo
	 SyNTI8dRzUGjI+QBTB3TB297FQC+tpFZcVblZ3HilguKpxVvYZMdchnUMc9Uoe2xrwllm
	 6UjnQQ/nFro34CQCv8Q+iX6Da0RHjqMh2pu5fJCXqNejyjIIguUW9xppmqdvf0jCYm9tv
	 iAmg73GcCSCtiOem+yhSsMzLOccdWpnjpwl/SsZwOaHDLX7/tPzQQ1CqlkZ598jraTfTq
	 Qr0uL1wmcg53lg/gaWFGGDbRF4f/mvwBVne4X5fZ+TKPzIqLUxeBa5IcOKZZRMaLy4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0RxU0/PXUyB96mJ2w3zTnZK+3jQ4qAQA8L5A5WGy910=;
	b=Hfp0j0x44cnUj5hm0Oqc0jFizJs+wf+6r0ZfwrqMuDlkg4bNrw5BLMX96+tqHhJyxmfW
	 msDmIGQkKOFwSua0HMznmwagZpsSQ0PYG0fDuUUTndFq/EpdoVnQuOUJZ7sRx60tvCqt6
	 oz5bquzOV+rFEZHvMjobJBEpxdQKOiaPobw2uN05+DsWOnYBnBl7I2AhhKKSYz41mKM2U
	 5r9Xe5cbGX3kpsGVuj73t8YOi1iYSDg+i7Huu6HEujpB44kVCVnr5krO3CZEnNWfdeLTJ
	 TOnB8J6s4mDQgEVAKih2TVnNnimwl3jit3kJTIapSRX5hHKicCY5gA6REPtvvmhPhcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0wumbglq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D176070300;
	Wed,  4 Nov 2026 21:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0wumbglq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFFC1F00A15;
	Wed,  4 Nov 2026 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828863;
	bh=0RxU0/PXUyB96mJ2w3zTnZK+3jQ4qAQA8L5A5WGy910=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wumbglqeMnaoT3UXa1OkqRVmSTbqZrIrpXK13S3kTcHjYTpaou8Ggal8KqGsE3T9
	 jI+M9venPqglewqReCrtxCU8TorzhVZfoMb1Clg3DovxNpbJKkkVzE7A8XQ1DoDj/c
	 CbULovlkE8o+o4PbFVh5mV8ty73h4a+hElmtnVQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 288/547] ovl: check the casefold flag of directories only
Date: Wed,  4 Nov 2026 16:07:52 -0500
Message-ID: <20261104211046.387661653@linuxfoundation.org>
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

commit 1d27da7de3f74405b1de85ad26c5ea90f826114b upstream.

On an overlay over casefolded (case-insensitive) directories, every
lookup of a file that is not a directory fails with EREMOTE, and the
first file create triggers a kernel warning. No privilege is needed: an
unprivileged user can cause both in a user namespace, with the layers on
a tmpfs that they have mounted with the casefold option.

Some filesystems support casefolding, which is case-insensitive name
lookup. It is enabled per directory, and the inode of a casefolded
directory has the S_CASEFOLD flag.

overlayfs accepts layers on a filesystem that supports casefolding as
long as casefolding is enabled on every directory of the layers, or on
none. The mount records which of the two applies in ofs->casefold.
ovl_lookup_single() compares the S_CASEFOLD flag of each file that it
finds against ofs->casefold and returns -EREMOTE on a mismatch.

Filesystems only set S_CASEFOLD on directories, so with casefolded
layers a regular file, a symlink or a special file never matches and its
lookup fails.

ovl_get_inode() does the same comparison in a WARN_ON_ONCE() for each
new overlay inode. A failed lookup never gets that far, so it is the
first file create that trips the warning.

Reproduced on an overlay over casefolded tmpfs or ext4 directories, with
stat() of a regular file, a symlink and a FIFO, and with a file create:
each stat() failed with EREMOTE. For an unprivileged user in a user
namespace, on tmpfs, stat() of a regular file failed in the same way,
and the file create triggered the warning.

Fix this by limiting both checks to directories.

Fixes: 16754d61dc69 ("ovl: Support mounting case-insensitive enabled layers")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/inode.c |    2 +-
 fs/overlayfs/namei.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1279,7 +1279,7 @@ struct inode *ovl_get_inode(struct super
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 	ovl_inode_init(inode, oip, ino, fsid);
-	WARN_ON_ONCE(!!IS_CASEFOLDED(inode) != ofs->casefold);
+	WARN_ON_ONCE(is_dir && !!IS_CASEFOLDED(inode) != ofs->casefold);
 
 	if (upperdentry && ovl_is_impuredir(sb, upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -266,7 +266,8 @@ static int ovl_lookup_single(struct dent
 		goto out_err;
 	}
 
-	if (ofs->casefold != ovl_dentry_casefolded(this)) {
+	/* Filesystems set the casefold flag only on directories */
+	if (d_is_dir(this) && ofs->casefold != ovl_dentry_casefolded(this)) {
 		warn = "child wrong casefold";
 		err = -EREMOTE;
 		goto out_warn;


