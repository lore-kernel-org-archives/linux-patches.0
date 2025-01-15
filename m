Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE80248BA6;
	Wed, 15 Jan 2025 10:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938119; cv=none; b=IWZeaWps02XoVQ1t78WZYz630omQfvJSTi+KD1GUiLxHhVpmGjWMM8ahx5chFu+GuMX7EMrTlDCOHuPWitCzR3+BMVGCRhQE2wgWi3znxui66nQ6pQB9DjqDqDJyz7I5SsaezlXdg59a0kb61eGyaKnceosJ+3YH/mYHv3LOIUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938119; c=relaxed/simple;
	bh=UZWYhR68eNkDlr2F74N36C9fFgvkdFJmae8i1Ob1OmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bn2kKDvuz3dFqDds2VaxBFP5ttXeX95kZ6O6hQqgcbMU20w2pO7cZtoDXLQiOt+zgF6HSjY6bdlGpAT18o6Gox/k/3ZvpsyZ0mMYd1cA/bpbm3zinsHBeV9GBgFM8U0bMpPw0iq6opmk/FLX0Oiy1LBqTcSfPG91GC0mvR6qwZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwAng47P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwAng47P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F5BC4CEDF;
	Wed, 15 Jan 2025 10:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938119;
	bh=UZWYhR68eNkDlr2F74N36C9fFgvkdFJmae8i1Ob1OmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwAng47PclhpP/QDTPym87EKg2eNDpjYuUIrX/yOE21Hjkpg45yRkuycNzV4tAdiJ
	 m+qwnrcy7/nEP/gavToeUR1n6qQLkopzdRkCduE0pwaF1/Yj7Xe2/ioegNZEQNCCTL
	 +WD90rhIEJ/lRuoM7odbRdp06AD9U4CvQ0Dq3ss0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com,
	Dmitry Safonov <dima@arista.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 088/189] fs: relax assertions on failure to encode file handles
Date: Wed, 15 Jan 2025 11:36:24 +0100
Message-ID: <20250115103609.848473873@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 974e3fe0ac61de85015bbe5a4990cf4127b304b2 upstream.

Encoding file handles is usually performed by a filesystem >encode_fh()
method that may fail for various reasons.

The legacy users of exportfs_encode_fh(), namely, nfsd and
name_to_handle_at(2) syscall are ready to cope with the possibility
of failure to encode a file handle.

There are a few other users of exportfs_encode_{fh,fid}() that
currently have a WARN_ON() assertion when ->encode_fh() fails.
Relax those assertions because they are wrong.

The second linked bug report states commit 16aac5ad1fa9 ("ovl: support
encoding non-decodable file handles") in v6.6 as the regressing commit,
but this is not accurate.

The aforementioned commit only increases the chances of the assertion
and allows triggering the assertion with the reproducer using overlayfs,
inotify and drop_caches.

Triggering this assertion was always possible with other filesystems and
other reasons of ->encode_fh() failures and more particularly, it was
also possible with the exact same reproducer using overlayfs that is
mounted with options index=on,nfs_export=on also on kernels < v6.6.
Therefore, I am not listing the aforementioned commit as a Fixes commit.

Backport hint: this patch will have a trivial conflict applying to
v6.6.y, and other trivial conflicts applying to stable kernels < v6.6.

Reported-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Tested-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-unionfs/671fd40c.050a0220.4735a.024f.GAE@google.com/
Reported-by: Dmitry Safonov <dima@arista.com>
Closes: https://lore.kernel.org/linux-fsdevel/CAGrbwDTLt6drB9eaUagnQVgdPBmhLfqqxAf3F+Juqy_o6oP8uw@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20241219115301.465396-1-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fdinfo.c     |    4 +---
 fs/overlayfs/copy_up.c |    5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -47,10 +47,8 @@ static void show_mark_fhandle(struct seq
 	size = f->handle_bytes >> 2;
 
 	ret = exportfs_encode_fid(inode, (struct fid *)f->f_handle, &size);
-	if ((ret == FILEID_INVALID) || (ret < 0)) {
-		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
+	if ((ret == FILEID_INVALID) || (ret < 0))
 		return;
-	}
 
 	f->handle_type = ret;
 	f->handle_bytes = size * sizeof(u32);
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -444,9 +444,8 @@ struct ovl_fh *ovl_encode_real_fh(struct
 	buflen = (dwords << 2);
 
 	err = -EIO;
-	if (WARN_ON(fh_type < 0) ||
-	    WARN_ON(buflen > MAX_HANDLE_SZ) ||
-	    WARN_ON(fh_type == FILEID_INVALID))
+	if (fh_type < 0 || fh_type == FILEID_INVALID ||
+	    WARN_ON(buflen > MAX_HANDLE_SZ))
 		goto out_err;
 
 	fh->fb.version = OVL_FH_VERSION;


