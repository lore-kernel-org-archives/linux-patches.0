Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF707337110;
	Fri, 17 Oct 2025 15:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714797; cv=none; b=UN/quEfRto6ZXg9pqKrkIuwmUVCsA2/5SXoz0MfqsrsndZ9P57qs96xfLNJSsG4nEM4PII3Riwmi08Mhst/75L9Axke1CFLdwT2s2f5Qk5pWmoSd+MWwLl0bxILvHPxiktLNBa3sf2s6CzFloJ6V5VhvDaieHjF2QZcQLuUKJCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714797; c=relaxed/simple;
	bh=ddqsJBPH6g5pPMmTgk2CxoRuBKb+X9mQxnEIbjBR0dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FLMR5HeFAzXB6rrCCNDSrheE63XYK5HyehQMu/aZTEh27hy5wxK96/sbsslAfl6QAXRbfnatV6tKEcISyPrJvMLikaCnaENz77M00Wu0XiCIcUoPU3x4uLvSgPxE1goci8Sl307oSkAt2TNUsJe3uyAIrygNFSsuxSKo7q9U0zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLBGSHd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLBGSHd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CE3C4CEE7;
	Fri, 17 Oct 2025 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714796;
	bh=ddqsJBPH6g5pPMmTgk2CxoRuBKb+X9mQxnEIbjBR0dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLBGSHd6+WV/mFYNPCAI7ymEN8x+8nfnlO7CcEWM6TQXEhWnhNgJ9LWZUiXhCDxW2
	 jy2cEi3m+27MJLJGEmMkdCbcHYWK/KGrhvlrzXS4lCcNHmBJxrYsxWxPxJ3oSU9U87
	 pusTH7dhhDFxGFM+C0qUrNrY2vk7hk+P6CLiLs9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lichen Liu <lichliu@redhat.com>,
	Rob Landley <rob@landley.net>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/277] fs: Add initramfs_options to set initramfs mount options
Date: Fri, 17 Oct 2025 16:54:36 +0200
Message-ID: <20251017145156.982626860@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
index 8724c2c580b88..e88505e945d52 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5923,6 +5923,9 @@
 
 	rootflags=	[KNL] Set root filesystem mount option string
 
+	initramfs_options= [KNL]
+                        Specify mount options for for the initramfs mount.
+
 	rootfstype=	[KNL] Set root filesystem type
 
 	rootwait	[KNL] Wait (indefinitely) for root device to show up.
diff --git a/fs/namespace.c b/fs/namespace.c
index 7606969412493..f5e46c2595b11 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -65,6 +65,15 @@ static int __init set_mphash_entries(char *str)
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
@@ -5566,7 +5575,7 @@ static void __init init_mount_tree(void)
 	struct mnt_namespace *ns;
 	struct path root;
 
-	mnt = vfs_kern_mount(&rootfs_fs_type, 0, "rootfs", NULL);
+	mnt = vfs_kern_mount(&rootfs_fs_type, 0, "rootfs", initramfs_options);
 	if (IS_ERR(mnt))
 		panic("Can't create rootfs");
 
-- 
2.51.0



