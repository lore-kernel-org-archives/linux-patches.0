Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771D0185935;
	Tue, 21 Jan 2025 17:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482199; cv=none; b=Z7ZbZg9YPHzPQ5cH7d1ZexbrHlkuhqRAYI1iiWSBzy/L21N7ozJxlO1ev44kxYhFV0iIe0vsyV/L7Rx7kwIj7F3J8aGtwNcn71cc1kCWg+heQt6gCTKM7yZbBPkkNgA3/D835xAlF5+CEv0hzKGcdo2oKRQTBZ79HVKQ7FYWAng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482199; c=relaxed/simple;
	bh=6rgMOGVtDOzLGQvVRVIKqTJMLqwimlpqmnxtL9pOPO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rtpbp+/R+3X+7HslXVXylM7Dyr2VVGrvn80dSXw+k66+3/wzAV7msRG7R7yrXrUUBG2QTMWuQjps8rXoP3XWKwMS5D05w4b9zY6Mq00KFXrLTKRp5YYOZThT8eltz3JQsMIllq3kyP0UD4ymbax8guejhwrNW29UR5WaZhdNmQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uc7TcT3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uc7TcT3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C16C4CEDF;
	Tue, 21 Jan 2025 17:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482198;
	bh=6rgMOGVtDOzLGQvVRVIKqTJMLqwimlpqmnxtL9pOPO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uc7TcT3IVjEhIX/rJaVmKmDMCez/01udBQpWkjfMSxxpHWutbFJbboqPnJkavZ7t8
	 eRUhp2TjOb7O+KwdPiBN/z7kErFJSjRAdSXUgoa1r5YDoOmFGK27Rauwpn/Sorb5kK
	 33s6gx4l/NQg4nWmA6cxJpOwobXBOxWpxwEFiMkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com,
	Dmitry Safonov <dima@arista.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 68/72] fs: relax assertions on failure to encode file handles
Date: Tue, 21 Jan 2025 18:52:34 +0100
Message-ID: <20250121174526.052498309@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fdinfo.c     |    4 +---
 fs/overlayfs/copy_up.c |    5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -51,10 +51,8 @@ static void show_mark_fhandle(struct seq
 	size = f.handle.handle_bytes >> 2;
 
 	ret = exportfs_encode_fid(inode, (struct fid *)f.handle.f_handle, &size);
-	if ((ret == FILEID_INVALID) || (ret < 0)) {
-		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
+	if ((ret == FILEID_INVALID) || (ret < 0))
 		return;
-	}
 
 	f.handle.handle_type = ret;
 	f.handle.handle_bytes = size * sizeof(u32);
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -399,9 +399,8 @@ struct ovl_fh *ovl_encode_real_fh(struct
 	buflen = (dwords << 2);
 
 	err = -EIO;
-	if (WARN_ON(fh_type < 0) ||
-	    WARN_ON(buflen > MAX_HANDLE_SZ) ||
-	    WARN_ON(fh_type == FILEID_INVALID))
+	if (fh_type < 0 || fh_type == FILEID_INVALID ||
+	    WARN_ON(buflen > MAX_HANDLE_SZ))
 		goto out_err;
 
 	fh->fb.version = OVL_FH_VERSION;


