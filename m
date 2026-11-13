Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590430;
	b=bXxAlCnZyOZ7gOYK7ShmQWDHc288f53lh+QQId6YrMi09QQIXkiWVsSyqm/Jp9qhEZlr
	 ASVOizSsKslJbYEVLx4pdZAjo6rNczmkVt/c69z/h75dbi/+F/xjRmNJ00N5uYUYb7Uyd
	 5/eWY4dMon/4nrcdeoKi5ug5GrQW6MawQNsH0bNXyRRMAGq0Os8KbhfmahgP0ppQrHQFX
	 STRMXPmFtKM9vlREveFY6w95OL0IK3aIUE7qdYfqRMx5neDpNpqxf96rLQbxn4XfzMYr5
	 PO+82xUsh8fikfrYvwEa7eiq8H5nn6c9KkGgETzA+jwTNkzuY+dAcz9LHk2eZoC9MWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xVAh4OsEC72VP2XGmxOgtOWJqd/3v7knyzzNbssZrLo=;
	b=gKjzg1cPqo75Xf/BKzNXb6sZpV4Y19xLT6JUcV5k7RQACL1yuWZH28WkAgj1yzmN/Euq
	 D8qwRL64WKrFPkyGhODPccLIqgqu1r9jhd26FtjOGtpq6N+zQ9uaoyabT/fyiBAeScX+J
	 N+18fD0m1ICAO9JqWDKBtBW2CqymTzN5MLD2gXDJB/EQ5DewVjMczxnVHg80x4oqIAwYu
	 12daaIIkhU7xBkRkGOWhbrsv8dBKx/3IjEDrvYy1Km260GDIyKiz5COHkELawjAs13+IY
	 SbrgrjVGKYrGZPbMOhl9/lTP9Btcqmw2poClGzC/ekqFTDvx4Fqvnt7DY2IiIca17tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gelC3Cjy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB0C606E65E;
	Fri, 13 Nov 2026 17:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gelC3Cjy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168CF1F000C7;
	Fri, 13 Nov 2026 17:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590430;
	bh=xVAh4OsEC72VP2XGmxOgtOWJqd/3v7knyzzNbssZrLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gelC3CjyUfquumdMQRrVRCobXEJ7J21mX83XCZyNeSisn9R7rFFKG0mGHmvc6bQlu
	 Traf0/VaIHoVw4YNJhV1jFC+T6VWoKc3gHDgG8CV8+2cSdo7B39f0JFGkME4EzW7xx
	 bw3tMtw5a8wYLrHIPMgQYbD35Y8+6RALBgsqQYgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 392/686] ovl: do not let chattr change the casefold flag
Date: Fri, 13 Nov 2026 10:48:45 -0500
Message-ID: <20261113153834.288989564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 83b351c3ade542bbfa1073e8c2d919826628252a ]

chattr +F or -F on an overlay directory can make the directory, or the
whole mount, unusable. Lookups of the directory, and lookups in it, then
fail. From code inspection, the caller only needs to own the directory.
The upper filesystem must support casefolding: ext4 or f2fs with the
casefold feature, or tmpfs with the casefold option.

chattr +F and -F set and clear FS_CASEFOLD_FL, the casefold flag of a
directory. The flag enables casefolding (case-insensitive name lookup)
for the directory. All directories of an overlay must match the casefold
state that was recorded at mount time, and ovl_lookup_single() enforces
this:

- A lookup in a directory that does not match fails with -ESTALE.
- A lookup of the directory itself fails with -EREMOTE.

ovl_fileattr_set() copies the directory up, which creates it in the
upper layer if it only existed in a lower layer. It then passes
FS_CASEFOLD_FL on to the upper filesystem. The upper filesystem accepts
the change if the upper directory is empty, regardless of what the
merged directory contains. The merged directory is the one that the user
sees, with the names from the upper and the lower directories.

After the change the upper directory no longer matches the mount. If the
directory is the root of the overlay, the whole mount is affected.

The flag can also change without chattr +F or -F. chattr reads all flags
of a directory, changes one and writes all of them back. For a directory
that only exists in a lower layer, overlayfs reads the flags from the
lower filesystem. xfs with the ascii-ci feature reports FS_CASEFOLD_FL
on every inode, but never sets S_CASEFOLD, the inode flag that overlayfs
compares with the mount. So its directories count as not casefolded.
With a lower layer on such an xfs and an upper layer on ext4 with the
casefold feature, chattr +A on a lower-only directory therefore sets
FS_CASEFOLD_FL on the new, empty upper directory.

Reproduced as root on tmpfs and on ext4 with chattr +F or -F on an
overlay directory whose upper directory was empty. Afterwards lookups
below it failed with ESTALE, and lookups of the directory itself failed
with EREMOTE. The chattr +A case was seen once, on a kernel with an
earlier form of this patch that still passed the caller's flag on:
lookups of the directory failed with EREMOTE.

Fix this by returning -EOPNOTSUPP if FS_IOC_SETFLAGS, the only call that
can change the flag, asks for a casefold flag on a directory that does
not agree with the casefold state of the mount. This also refuses the
chattr +A case above.

Fixes: 083957f9614a ("ovl: support layers on case-folding capable filesystems")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[amir: check the flag against the casefold state of the mount instead of
 reading back the flags]
Tested-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 78803e40c9619..79ad351298feb 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -657,6 +657,14 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
 	unsigned int flags;
 	int err;
 
+	/*
+	 * Lookup refuses a directory that does not agree with the casefold
+	 * state of the mount. Only FS_IOC_SETFLAGS can ask for a change.
+	 */
+	if (S_ISDIR(inode->i_mode) && fa->flags_valid &&
+	    !!(fa->flags & FS_CASEFOLD_FL) != OVL_FS(inode->i_sb)->casefold)
+		return -EOPNOTSUPP;
+
 	err = ovl_copy_up(dentry);
 	if (!err) {
 		ovl_path_real(dentry, &upperpath);
-- 
2.53.0



