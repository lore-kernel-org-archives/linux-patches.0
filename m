Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1D138655A;
	Sat, 12 Sep 2026 13:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218642; cv=none; b=dwTgtk1vv0hXAV+gPT3EiNKX8HvbXjVyoeLcyMsVKFIA/hIkc1mXWZdUdGvazayRalwjCiCpR4e/F8HXesjCBuVp+mpRnfYNTq1BS0uu1EunJEjv55kwBT7i4iIK6FUmR/fiPhZ88z6MKV2fCbqWr+j3zDweuTBI4HEzXVImioU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218642; c=relaxed/simple;
	bh=y0Ng4FefhOKesN+b0hmB7+Mr8IdlrcKkiwcpI/O6dwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rl7F1ApUsJZEc0zvWD+tHhXSG8Tq9XyGWbGwSsXu7D7DFPbyW7f0kapCx8QAo0x1zsS2FeTpcJecDBxYe0FFH9U02EnKX/L7N5zVhlhni83kW6mq0paqtlAI4zAem9vRZH76CMF+ohcrdUZMEuZTZAaiczH9nR32nIdXqmrQP1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9Tpar8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9Tpar8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01D41F000FF;
	Sat, 12 Sep 2026 13:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218640;
	bh=GRh7lLpeodT4RATQEOL55kHKpCrTp9YCi2x2wajgnUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9Tpar8ZOvOqE5VhthPzh3x/E0AeiqeSSnCTa2rwlYDgDZqUa9qKrztjzzYpTeuoM
	 Su3HF2evfD+x0EpQi1suhPef6dGqmqsrPtJSD3CW+/Ej3/45u3JUYeXjWGkvl+eljL
	 2NqetWyTSB528DQ+GFBUPlQGvbHdqEvrwQ/UmOmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Nemanov <michael.nemanov@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1185/1376] nfs: fix ENXIO on O_CREAT open of existing symlink over NFSv3
Date: Sat, 12 Sep 2026 09:00:11 +0200
Message-ID: <20260912065633.962235690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Nemanov <michael.nemanov@vastdata.com>

[ Upstream commit 10f307e525a1783570a39eb9ac146d45f4f16b3e ]

When open(2) is called with O_CREAT on a path that already exists as a
symlink, over an NFSv3 mount with a cold dcache, the kernel returns
ENXIO instead of following the symlink to its target.

Reproducer script (MNT is an NFSv3 mount, kernel is 7.1-rc6):

MNT=/mnt/export
ln -sf /tmp/target $MNT/mylink
echo 3 | sudo tee /proc/sys/vm/drop_caches   # cold dcache

python3 - <<'EOF'
import os
fd = os.open('/mnt/export/mylink', os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o666)
os.close(fd)
EOF

Expected: success (follow symlink, open target)
Actual:   OSError: [Errno 6] No such device or address

The bug does not trigger when the dcache is warm (e.g. after a prior
stat(2)), because lookup_open() then finds a positive dentry and skips
atomic_open entirely, leaving symlink resolution to the VFS.

Root cause:
nfs_atomic_open_v23(), registered as inode->i_op->atomic_open for
NFSv3, handles O_CREAT by sending a CREATE UNCHECKED RPC. As
implemented in nfsd3_create_file() (fs/nfsd/nfs3proc.c) and as required
by RFC 1813 (3.3.8), when the name already exists as a non-regular file
the server returns NFS3_OK with the existing object's file handle rather
than NFS3ERR_EXIST causing nfs_do_create() to return 0 with the
dentry now pointing to a symlink.
The code then unconditionally calls finish_open(), which dispatches
through inode->i_fop->open(). Symlink inodes never have i_fop set — the
VFS initialises it to &no_open_fops because POSIX requires open(2) to
follow symlinks, never open them directly. no_open() returns -ENXIO.

Fix:
After nfs_do_create() succeeds, verify the returned inode is a regular
file before calling finish_open(). If the object is not regular, return
finish_no_open(file, NULL) so the VFS follows the symlink through the
normal open path. NULL is passed because nfs_do_create() instantiates
the inode on the dentry already owned by the caller; passing dentry back
would cause atomic_open() to dput() it a second time.
!S_ISREG() is used rather than S_ISLNK() to cover any other non-regular
types a server might return.

Changes in v2:
- Pass NULL to finish_no_open() per Trond's feedback.

Fixes: 7c6c5249f061 ("NFS: add atomic_open for NFSv3 to handle O_TRUNC correctly.")
Link: https://lore.kernel.org/linux-nfs/20260614122911.3485467-1-michael.nemanov@vastdata.com/ (v1)
Signed-off-by: Michael Nemanov <michael.nemanov@vastdata.com>
Tested-by: Michael Nemanov <michael.nemanov@vastdata.com>
[trond.myklebust@hammerspace.com: use d_is_reg() to catch negative dentries]
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index d409239fb00f7..5c9c156838678 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2287,6 +2287,13 @@ int nfs_atomic_open_v23(struct inode *dir, struct dentry *dentry,
 	if (open_flags & O_CREAT) {
 		error = nfs_do_create(dir, dentry, mode, open_flags);
 		if (!error) {
+			/* With UNCHECKED mode, a server may return NFS3_OK for
+			 * a pre-existing non-regular file (e.g. a symlink).
+			 * Let the VFS handle it; calling finish_open() would
+			 * hit no_open() and return -ENXIO.
+			 */
+			if (!d_is_reg(dentry))
+				return finish_no_open(file, NULL);
 			file->f_mode |= FMODE_CREATED;
 			return finish_open(file, dentry, NULL);
 		} else if (error != -EEXIST || open_flags & O_EXCL)
-- 
2.53.0



