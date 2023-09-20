Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E7030FA4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544C1C433C7;
	Wed, 20 Sep 2023 12:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212440;
	bh=e76mENKpOIq4ob44XBuOoOzQuKr91yRmvTIC1m5YWsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYkzFfWJHqXoJcfrwBybCGxh39+MNS4IAD+wJitbXw0ywJjjOCVW7DJknIgptE0Pl
	 QfZtsCYFQ8RsSzwiuTUsMYew/8w/GnCJzA6eHP1R7R53eckovXjwdpOB7VaApP/VbD
	 TNphMl63hO8zriZEO0LE0/ajmveJZjtnQnavCMEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christoph Hellwig <hch@lst.de>,
	Florian Weimer <fweimer@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 4.19 268/273] attr: block mode changes of symlinks
Date: Wed, 20 Sep 2023 13:31:48 +0200
Message-ID: <20230920112854.506119440@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 5d1f903f75a80daa4dfb3d84e114ec8ecbf29956 upstream.

Changing the mode of symlinks is meaningless as the vfs doesn't take the
mode of a symlink into account during path lookup permission checking.

However, the vfs doesn't block mode changes on symlinks. This however,
has lead to an untenable mess roughly classifiable into the following
two categories:

(1) Filesystems that don't implement a i_op->setattr() for symlinks.

    Such filesystems may or may not know that without i_op->setattr()
    defined, notify_change() falls back to simple_setattr() causing the
    inode's mode in the inode cache to be changed.

    That's a generic issue as this will affect all non-size changing
    inode attributes including ownership changes.

    Example: afs

(2) Filesystems that fail with EOPNOTSUPP but change the mode of the
    symlink nonetheless.

    Some filesystems will happily update the mode of a symlink but still
    return EOPNOTSUPP. This is the biggest source of confusion for
    userspace.

    The EOPNOTSUPP in this case comes from POSIX ACLs. Specifically it
    comes from filesystems that call posix_acl_chmod(), e.g., btrfs via

        if (!err && attr->ia_valid & ATTR_MODE)
                err = posix_acl_chmod(idmap, dentry, inode->i_mode);

    Filesystems including btrfs don't implement i_op->set_acl() so
    posix_acl_chmod() will report EOPNOTSUPP.

    When posix_acl_chmod() is called, most filesystems will have
    finished updating the inode.

    Perversely, this has the consequences that this behavior may depend
    on two kconfig options and mount options:

    * CONFIG_POSIX_ACL={y,n}
    * CONFIG_${FSTYPE}_POSIX_ACL={y,n}
    * Opt_acl, Opt_noacl

    Example: btrfs, ext4, xfs

The only way to change the mode on a symlink currently involves abusing
an O_PATH file descriptor in the following manner:

        fd = openat(-1, "/path/to/link", O_CLOEXEC | O_PATH | O_NOFOLLOW);

        char path[PATH_MAX];
        snprintf(path, sizeof(path), "/proc/self/fd/%d", fd);
        chmod(path, 0000);

But for most major filesystems with POSIX ACL support such as btrfs,
ext4, ceph, tmpfs, xfs and others this will fail with EOPNOTSUPP with
the mode still updated due to the aforementioned posix_acl_chmod()
nonsense.

So, given that for all major filesystems this would fail with EOPNOTSUPP
and that both glibc (cf. [1]) and musl (cf. [2]) outright block mode
changes on symlinks we should just try and block mode changes on
symlinks directly in the vfs and have a clean break with this nonsense.

If this causes any regressions, we do the next best thing and fix up all
filesystems that do return EOPNOTSUPP with the mode updated to not call
posix_acl_chmod() on symlinks.

But as usual, let's try the clean cut solution first. It's a simple
patch that can be easily reverted. Not marking this for backport as I'll
do that manually if we're reasonably sure that this works and there are
no strong objections.

We could block this in chmod_common() but it's more appropriate to do it
notify_change() as it will also mean that we catch filesystems that
change symlink permissions explicitly or accidently.

Similar proposals were floated in the past as in [3] and [4] and again
recently in [5]. There's also a couple of bugs about this inconsistency
as in [6] and [7].

Link: https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/fchmodat.c;h=99527a3727e44cb8661ee1f743068f108ec93979;hb=HEAD [1]
Link: https://git.musl-libc.org/cgit/musl/tree/src/stat/fchmodat.c [2]
Link: https://lore.kernel.org/all/20200911065733.GA31579@infradead.org [3]
Link: https://sourceware.org/legacy-ml/libc-alpha/2020-02/msg00518.html [4]
Link: https://lore.kernel.org/lkml/87lefmbppo.fsf@oldenburg.str.redhat.com [5]
Link: https://sourceware.org/legacy-ml/libc-alpha/2020-02/msg00467.html [6]
Link: https://sourceware.org/bugzilla/show_bug.cgi?id=14578#c17 [7]
Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org # please backport to all LTSes but not before v6.6-rc2 is tagged
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Florian Weimer <fweimer@redhat.com>
Message-Id: <20230712-vfs-chmod-symlinks-v2-1-08cfb92b61dd@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -256,9 +256,25 @@ int notify_change(struct dentry * dentry
 	}
 
 	if ((ia_valid & ATTR_MODE)) {
-		umode_t amode = attr->ia_mode;
+		/*
+		 * Don't allow changing the mode of symlinks:
+		 *
+		 * (1) The vfs doesn't take the mode of symlinks into account
+		 *     during permission checking.
+		 * (2) This has never worked correctly. Most major filesystems
+		 *     did return EOPNOTSUPP due to interactions with POSIX ACLs
+		 *     but did still updated the mode of the symlink.
+		 *     This inconsistency led system call wrapper providers such
+		 *     as libc to block changing the mode of symlinks with
+		 *     EOPNOTSUPP already.
+		 * (3) To even do this in the first place one would have to use
+		 *     specific file descriptors and quite some effort.
+		 */
+		if (S_ISLNK(inode->i_mode))
+			return -EOPNOTSUPP;
+
 		/* Flag setting protected by i_mutex */
-		if (is_sxid(amode))
+		if (is_sxid(attr->ia_mode))
 			inode->i_flags &= ~S_NOSEC;
 	}
 


