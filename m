Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9010E47208D;
	Sat, 12 Sep 2026 11:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211537; cv=none; b=TprhD1hUsz//eY5XbvJ+a40RRs/oOlpic7oUbRhcgZEthwdFb2lsTmnfemjTZIie8tkdjSlPpR4wYCcqBibN0RATnb7xN4Y4XPy+kjTDiRcYrnl49bz843o7D8TpQwgBBUBD4ImnX62md0a4U0sM5H20+TGGI8WoihLC8P3hAkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211537; c=relaxed/simple;
	bh=Bodamcb8rM69w1TU0RyWfUWvNBjVA+tZVr9cUZWgoPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hajVn/Unepa/N1lUxx8kImT4JCV/uq/WkzPezDjmt8fr3h2/RKAUhSOAmJDSEqZP1F33ssrmF4YEo4HtJ4ll7CIjDhnO6zkVSVTUA3r9XvFGvMmV+019yH9p1688dVNmQ+njPmaIiPTVyfVbrH6zwxwDus83YXjHzuYomJPHu7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi4btKmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi4btKmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7CC1F000FF;
	Sat, 12 Sep 2026 11:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211536;
	bh=rrvR24wTPQTnz9qEp+5GM3OQcDrlr3Ky4GsoH56acDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gi4btKmvE6seuUCiOaRKURKkniCsysfhD4PQIjsRFg9JQMIdGgNaPKO/HHMPDWVH7
	 iB/gXwL/4/WoQXZIaLfcR1tahq6yIGGKRtXLkK+CntHNZKMwIOvcE10KgwsATfZyi7
	 ctiGbgPGpIFtloFUjjRPjwzpozM/PXcq0eYJUEc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Nemanov <michael.nemanov@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1252/1518] nfs: fix ENXIO on O_CREAT open of existing symlink over NFSv3
Date: Sat, 12 Sep 2026 08:57:01 +0200
Message-ID: <20260912065651.831443880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 31ca8bbfb9702..38b0834e3ebf1 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2275,6 +2275,13 @@ int nfs_atomic_open_v23(struct inode *dir, struct dentry *dentry,
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



