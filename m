Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BB0330B0F;
	Fri, 17 Oct 2025 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716646; cv=none; b=op/KkBcA9sjPBRtsYn0OaeEasthd6ECNZNxC8COqu4rrJTOlPLuyfOCP4OIr09BgecdPuSVCr9kDf2oo7MGcvbHUVo4ImL0kz+6KwJ+hSmyZv60uc6A2I4K5ycnkaUDnHEvbrrSgvygxwwHP2xTA8+i29TTq3/fce+BdjGuMuqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716646; c=relaxed/simple;
	bh=lGCwBUP4QitpyZNjkLHvqkRBWa4CkgYAXTVQdaD6G7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m2aeUsjdg1kdzEgGhkCNhH/L59WpEf/zjFCeCJREY9pcTqqKm8TPAN6V8xX62mbjRKo8SKUCjRDGwPme2XdbtZpPlVVd1/yzBRVwTphUxOyE5hgF3Z83WAdRr9mCVz95reBdNwbKGWCTWg+SuMfmE+a4aNr94hrTUFzRVdxIgIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vqd/dMc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqd/dMc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7E7C4CEE7;
	Fri, 17 Oct 2025 15:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716646;
	bh=lGCwBUP4QitpyZNjkLHvqkRBWa4CkgYAXTVQdaD6G7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vqd/dMc3CTtlZv54W7fxzKIbWBZa+0pi9Nq97dF+E/f12q1dzNLcYIWCLQPYT+mBg
	 xP7JBQ+ECxEf9eHwdk/E+wIvUly/UeU3X7br6Nf715iFYdhWRDx4byvMDBr3uFfCuT
	 l3JecorXxYG72RqURYDpQvMKXtLvkJ4rF7bIwz3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lichen Liu <lichliu@redhat.com>,
	Rob Landley <rob@landley.net>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/276] fs: Add initramfs_options to set initramfs mount options
Date: Fri, 17 Oct 2025 16:55:56 +0200
Message-ID: <20251017145152.087143433@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lichen Liu <lichliu@redhat.com>

[ Upstream commit 278033a225e13ec21900f0a92b8351658f5377f2 ]

When CONFIG_TMPFS is enabled, the initial root filesystem is a tmpfs.
By default, a tmpfs mount is limited to using 50% of the available RAM
for its content. This can be problematic in memory-constrained
environments, particularly during a kdump capture.

In a kdump scenario, the capture kernel boots with a limited amount of
memory specified by the 'crashkernel' parameter. If the initramfs is
large, it may fail to unpack into the tmpfs rootfs due to insufficient
space. This is because to get X MB of usable space in tmpfs, 2*X MB of
memory must be available for the mount. This leads to an OOM failure
during the early boot process, preventing a successful crash dump.

This patch introduces a new kernel command-line parameter,
initramfs_options, which allows passing specific mount options directly
to the rootfs when it is first mounted. This gives users control over
the rootfs behavior.

For example, a user can now specify initramfs_options=size=75% to allow
the tmpfs to use up to 75% of the available memory. This can
significantly reduce the memory pressure for kdump.

Consider a practical example:

To unpack a 48MB initramfs, the tmpfs needs 48MB of usable space. With
the default 50% limit, this requires a memory pool of 96MB to be
available for the tmpfs mount. The total memory requirement is therefore
approximately: 16MB (vmlinuz) + 48MB (loaded initramfs) + 48MB (unpacked
kernel) + 96MB (for tmpfs) + 12MB (runtime overhead) ≈ 220MB.

By using initramfs_options=size=75%, the memory pool required for the
48MB tmpfs is reduced to 48MB / 0.75 = 64MB. This reduces the total
memory requirement by 32MB (96MB - 64MB), allowing the kdump to succeed
with a smaller crashkernel size, such as 192MB.

An alternative approach of reusing the existing rootflags parameter was
considered. However, a new, dedicated initramfs_options parameter was
chosen to avoid altering the current behavior of rootflags (which
applies to the final root filesystem) and to prevent any potential
regressions.

Also add documentation for the new kernel parameter "initramfs_options"

This approach is inspired by prior discussions and patches on the topic.
Ref: https://www.lightofdawn.org/blog/?viewDetailed=00128
Ref: https://landley.net/notes-2015.html#01-01-2015
Ref: https://lkml.org/lkml/2021/6/29/783
Ref: https://www.kernel.org/doc/html/latest/filesystems/ramfs-rootfs-initramfs.html#what-is-rootfs

Signed-off-by: Lichen Liu <lichliu@redhat.com>
Link: https://lore.kernel.org/20250815121459.3391223-1-lichliu@redhat.com
Tested-by: Rob Landley <rob@landley.net>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 fs/namespace.c                                  | 11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 25e07ac5c1caf..ae09a6c701f02 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5148,6 +5148,9 @@
 
 	rootflags=	[KNL] Set root filesystem mount option string
 
+	initramfs_options= [KNL]
+                        Specify mount options for for the initramfs mount.
+
 	rootfstype=	[KNL] Set root filesystem type
 
 	rootwait	[KNL] Wait (indefinitely) for root device to show up.
diff --git a/fs/namespace.c b/fs/namespace.c
index 35d63bb3b22dc..ae1b8530eb939 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -64,6 +64,15 @@ static int __init set_mphash_entries(char *str)
 }
 __setup("mphash_entries=", set_mphash_entries);
 
+static char * __initdata initramfs_options;
+static int __init initramfs_options_setup(char *str)
+{
+	initramfs_options = str;
+	return 1;
+}
+
+__setup("initramfs_options=", initramfs_options_setup);
+
 static u64 event;
 static DEFINE_IDA(mnt_id_ida);
 static DEFINE_IDA(mnt_group_ida);
@@ -4352,7 +4361,7 @@ static void __init init_mount_tree(void)
 	struct mnt_namespace *ns;
 	struct path root;
 
-	mnt = vfs_kern_mount(&rootfs_fs_type, 0, "rootfs", NULL);
+	mnt = vfs_kern_mount(&rootfs_fs_type, 0, "rootfs", initramfs_options);
 	if (IS_ERR(mnt))
 		panic("Can't create rootfs");
 
-- 
2.51.0



