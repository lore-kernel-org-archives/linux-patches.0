Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C971422C4;
	Thu, 11 Apr 2024 10:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829867; cv=none; b=ltz95NL7StLUb8LAzUfMMAvNS0cl03NyM4I7vIHbd+S3ULCfuIwoDY/toEEhdHq86GKi3MiueNOSF8Zpw184DYH/Eho53kRiH/OhktYRZMSV9wpdTSB/mxPpBzyeK7V4hF7AP8nQwD2oVwbft498VRzsiPrHrulBADfzKAL84+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829867; c=relaxed/simple;
	bh=L4Ts2+QjdSMfuUB+iqmkGweo0qc8Z+wTbbvTM1Rlxb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4kJdgbgcySvhs80AFp6ubg6Ur9cvzLT9v0VsdbiZgepW91J12mnikI4XHMWmAvEtUUZRzwzj5n/+N12OT0J9iU5eZnZ7eDZJh9FfSqF7jQg0xRo10R5/QTC65uK1q8Rfa6XYu7OTx4eUMnxHS0TMAbSfEOzJZthkj4RK2/jD24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oM94Y98g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oM94Y98g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66A0C433F1;
	Thu, 11 Apr 2024 10:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829867;
	bh=L4Ts2+QjdSMfuUB+iqmkGweo0qc8Z+wTbbvTM1Rlxb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oM94Y98gSV1GR/CYFdXU6bIBsJmcZN6YoNAiedKrls9ttH/b6W0NcLrcRMvqU1YAT
	 aAaZJ2V3zFyGmdIqwyfK53fXMdHHhdaIp9xPcG/ii26paQCp0C1eMqhLCEaE3ddjQk
	 aznmH4ehLl81O03TyEQ6QVCHHqU976OMQbDSmcIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Guan Xuetao <gxt@pku.edu.cn>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will.deacon@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4.19 133/175] initramfs: factor out a helper to populate the initrd image
Date: Thu, 11 Apr 2024 11:55:56 +0200
Message-ID: <20240411095423.568081396@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7c184ecd262fe64fe8cf4e099e0f7cefe88d88b2 ]

This will allow for cleaner code sharing in the caller.

Link: http://lkml.kernel.org/r/20190213174621.29297-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
Cc: Steven Price <steven.price@arm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 4624b346cf67 ("init: open /initrd.image with O_LARGEFILE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index dab8d63459f63..7103edf44436c 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -599,6 +599,28 @@ static void __init clean_rootfs(void)
 }
 #endif
 
+#ifdef CONFIG_BLK_DEV_RAM
+static void populate_initrd_image(char *err)
+{
+	ssize_t written;
+	int fd;
+
+	unpack_to_rootfs(__initramfs_start, __initramfs_size);
+
+	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
+			err);
+	fd = ksys_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	if (fd < 0)
+		return;
+
+	written = xwrite(fd, (char *)initrd_start, initrd_end - initrd_start);
+	if (written != initrd_end - initrd_start)
+		pr_err("/initrd.image: incomplete write (%zd != %ld)\n",
+		       written, initrd_end - initrd_start);
+	ksys_close(fd);
+}
+#endif /* CONFIG_BLK_DEV_RAM */
+
 static int __init populate_rootfs(void)
 {
 	/* Load the built in initramfs */
@@ -608,7 +630,6 @@ static int __init populate_rootfs(void)
 	/* If available load the bootloader supplied initrd */
 	if (initrd_start && !IS_ENABLED(CONFIG_INITRAMFS_FORCE)) {
 #ifdef CONFIG_BLK_DEV_RAM
-		int fd;
 		printk(KERN_INFO "Trying to unpack rootfs image as initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start);
@@ -616,22 +637,7 @@ static int __init populate_rootfs(void)
 			goto done;
 
 		clean_rootfs();
-		unpack_to_rootfs(__initramfs_start, __initramfs_size);
-
-		printk(KERN_INFO "rootfs image is not initramfs (%s)"
-				"; looks like an initrd\n", err);
-		fd = ksys_open("/initrd.image",
-			      O_WRONLY|O_CREAT, 0700);
-		if (fd >= 0) {
-			ssize_t written = xwrite(fd, (char *)initrd_start,
-						initrd_end - initrd_start);
-
-			if (written != initrd_end - initrd_start)
-				pr_err("/initrd.image: incomplete write (%zd != %ld)\n",
-				       written, initrd_end - initrd_start);
-
-			ksys_close(fd);
-		}
+		populate_initrd_image(err);
 	done:
 		/* empty statement */;
 #else
-- 
2.43.0



