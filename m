Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065541;
	b=eKr1z0tmjsvF8g3NAkMoKQmkBmDjXqYL4PUCu0YL/WdQkc20+2qvgH2ofPbGsZAcXmoq
	 ckNYVTiZaVoc16B3Jyfra1y6IHs0vtf+bBWRNkWYkDzWD1CKCpabuMqtS/GJALDO3M1LN
	 hQmZKqHlw8cybJm/WkVpahXRv/sZmKdiB4FGSp7tkzqki6bxUMssExVMJ0zK24bQ3I4GE
	 jg2M+OiZ92Yt83cg9GuhaPT0Cqn7CiNwOrzJdBClG6pfqFne26MhNOcuR/Kjgsiv5cY4C
	 d8bEIIy7ydF1kGDxucJR1XXGed/JOoPwWHLI8GL26mmY59t5QWC7ofcOwcVxtFkFTJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HGt0hjcFRXvTPvZRwj0eKs1hDjilSqBmVCfIQyCCOLw=;
	b=cLwI2U+3UqFWq8bddVd0ZG2IYovtp45JgShADtk+irsxBFlgixJ7dmfnmmHKa+6XE0AP
	 xqObTstD9UEliUM9ClKBiOXlUcxDqNLVvEIQE8QE3nuO1dNnnVRROGuXTcexI0sAmybnE
	 /mrBla7I/kMKU4vujUYz9xEHL5JAYO441LKFo7hbv7pcRcs//0BG3IGmNCdWai8IHnv8b
	 J1v8gLjiDfsCZ3XqdhJqzxSgDAAEs8zlvKWQYRTv4b71gK0wwnw52YReYD4iynXPG7B4U
	 Dj3FUb1vxEwQE7ASVao5GP+5Vrj5I4Bz1z9TnuPMpSiL6D4XRAuYNbWEWf1MPXGeSSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwYMNI53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F71606D823;
	Sat,  7 Nov 2026 15:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwYMNI53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6C61F0089F;
	Sat,  7 Nov 2026 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065541;
	bh=HGt0hjcFRXvTPvZRwj0eKs1hDjilSqBmVCfIQyCCOLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwYMNI53amT67/sm3NhS+fvhkjUeBmJe8tLJ2T2zM9gNk7aXVGjGwOgnxFsoWKrvn
	 0cRZPUK2YZnwz1r4qtzjPA8AU3arllJDVfVukKKN8g+XKA6FToCCZesmbrL30BalF8
	 KgNsyTYO/XDvY6QVYp+i2x15Zevlh08O8I0tIsJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1217/1257] fsverity: Explicitly require FMODE_READ to retrieve hashes
Date: Sat,  7 Nov 2026 08:58:33 -0500
Message-ID: <20261107135012.977052187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 1acb4fd2d011c4bd6cc961095ae17361c71ff61a ]

The comment in fsverity_ioctl_read_metadata(), which justifies not
checking for FMODE_READ, doesn't consider that the nonstandard access
mode 3 (ioctl-only) exists.

Opening an ioctl-only fd generally requires read (and write) permission.
However, there are gaps with certain LSMs: an ioctl-only fd requests
read (and write) permission via security_inode_permission, but not
security_file_open.  With certain LSMs relying on the latter, such as
Landlock and AppArmor, an ioctl-only fd can be opened without the LSM
granting read (and write) permission.

Since FS_IOC_READ_VERITY_METADATA returns hashes of file contents
blocks, it should require read permission.  This also applies to
FS_IOC_MEASURE_VERITY, which returns a hash for the whole file.

Meanwhile, ioctl-only fds are a rarely-used feature, not known to be
used with either ioctl.

Therefore, just disallow these ioctls on ioctl-only file descriptors,
similar to what was already done with FS_IOC_ENABLE_VERITY.

More specifically, explicitly check for FMODE_READ.  This also covers
write-only fds to non-verity files which otherwise would have failed
with ENODATA.  This change in error code for write-only fds should be
fine too, as these ioctls cannot be usefully used with write-only fds
anyway, but it's worth noting as another technicality.

Fixes: 4dd893d832cf ("fs-verity: implement FS_IOC_MEASURE_VERITY ioctl")
Fixes: e17fe6579de0 ("fs-verity: add FS_IOC_READ_VERITY_METADATA ioctl")
Cc: stable@vger.kernel.org
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Link: https://patch.msgid.link/20261022211522.1489943-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/fsverity.rst |  3 +++
 fs/verity/measure.c                    | 10 ++++++++++
 fs/verity/read_metadata.c              | 14 ++++++++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 22b49b295d1f9..e5d38439bf585 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -170,6 +170,7 @@ fatal signal), no changes are made to the file.
 FS_IOC_ENABLE_VERITY can fail with the following errors:
 
 - ``EACCES``: the process does not have write access to the file
+- ``EBADF``: the file descriptor is not open for reading
 - ``EBADMSG``: the builtin signature is malformed
 - ``EBUSY``: this ioctl is already running on the file
 - ``EEXIST``: the file already has verity enabled
@@ -232,6 +233,7 @@ regardless of the size of the file.
 
 FS_IOC_MEASURE_VERITY can fail with the following errors:
 
+- ``EBADF``: the file descriptor is not open for reading
 - ``EFAULT``: the caller provided inaccessible memory
 - ``ENODATA``: the file is not a verity file
 - ``ENOTTY``: this type of filesystem does not implement fs-verity
@@ -310,6 +312,7 @@ blocks from disk without actually verifying the path to the root node.
 
 FS_IOC_READ_VERITY_METADATA can fail with the following errors:
 
+- ``EBADF``: the file descriptor is not open for reading
 - ``EFAULT``: the caller provided inaccessible memory
 - ``EINTR``: the ioctl was interrupted before any data was read
 - ``EINVAL``: reserved fields were set, or ``offset + length``
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index 68dfccb697720..0c75616dca011 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -31,6 +31,16 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	const struct fsverity_hash_alg *hash_alg;
 	struct fsverity_digest arg;
 
+	/*
+	 * This ioctl returns a hash of the file contents, so it should require
+	 * read permission.  Disallow it on ioctl-only (i.e., nonstandard access
+	 * mode 3) fds, which can in some cases be acquired without passing all
+	 * LSM read-permission checks.  Also disallow write-only fds, which can
+	 * refer only to non-verity files which would fail with ENODATA anyway.
+	 */
+	if (!(filp->f_mode & FMODE_READ))
+		return -EBADF;
+
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
diff --git a/fs/verity/read_metadata.c b/fs/verity/read_metadata.c
index b4c0892430cde..6694149f7b467 100644
--- a/fs/verity/read_metadata.c
+++ b/fs/verity/read_metadata.c
@@ -166,13 +166,19 @@ int fsverity_ioctl_read_metadata(struct file *filp, const void __user *uarg)
 	int length;
 	void __user *buf;
 
+	/*
+	 * This ioctl returns file contents block hashes, so it should require
+	 * read permission.  Disallow it on ioctl-only (i.e., nonstandard access
+	 * mode 3) fds, which can in some cases be acquired without passing all
+	 * LSM read-permission checks.  Also disallow write-only fds, which can
+	 * refer only to non-verity files which would fail with ENODATA anyway.
+	 */
+	if (!(filp->f_mode & FMODE_READ))
+		return -EBADF;
+
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
-	/*
-	 * Note that we don't have to explicitly check that the file is open for
-	 * reading, since verity files can only be opened for reading.
-	 */
 
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
-- 
2.53.0



