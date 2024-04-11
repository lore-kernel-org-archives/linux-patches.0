Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CED31442F7;
	Thu, 11 Apr 2024 10:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829992; cv=none; b=F62cgJcCjFnOVYkBf+qDFMXXLi9D+jDhWpOZkY0y5dlZWa6yhZByEs3hG0t4aLd6M5pYGb5MB26sIRNsQyg/+JeGRbRuNRl68Dzw79g7yleTmg4b5ddS4dOygy4zWJnZif7vK1uaOsNWQ+QwfTtknU7L1SLye+qePn2frscIbMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829992; c=relaxed/simple;
	bh=4D+UE3Qj7lU1Aj00SE9qyyEQ7dM1Aro2zxGrkiVPhFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0o5FWS/0lSy5JI3g4eeaTNNpQWssHkYlFMkwAnFbOQah//XPIrncMdSU1Odof2k9LBzm35k0RB1k3dcHgamdLKyHvD6FN2leioVw0G/VTw+BkiytY++mOY3eh2y0bwqOY/KUcumkaAIt7JapJ59HBLDsbvlaWldKdlCH569+y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n79MrkPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n79MrkPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156E5C433C7;
	Thu, 11 Apr 2024 10:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829992;
	bh=4D+UE3Qj7lU1Aj00SE9qyyEQ7dM1Aro2zxGrkiVPhFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n79MrkPB6oMm6tvysmzOIjAcFQsPNoZ/JdR/yt9nBmPJl+F0Dr8/vY9ZrxEnssTe5
	 saTMcwcGVllci7pyJ41iBnUWlK2taStheFfGVAIPdEhId/fcyi7DRLBlcJpgYZWXLp
	 YeoKmyrMNCIE1KgIHF6y6w5LF9Hzy+X7p9K2U9LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 175/175] initramfs: fix populate_initrd_image() section mismatch
Date: Thu, 11 Apr 2024 11:56:38 +0200
Message-ID: <20240411095424.831633827@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 4ada1e810038e9dbc20e40b524e05ee1a9d31f98 upstream.

With gcc-4.6.3:

    WARNING: vmlinux.o(.text.unlikely+0x140): Section mismatch in reference from the function populate_initrd_image() to the variable .init.ramfs.info:__initramfs_size
    The function populate_initrd_image() references
    the variable __init __initramfs_size.
    This is often because populate_initrd_image lacks a __init
    annotation or the annotation of __initramfs_size is wrong.

    WARNING: vmlinux.o(.text.unlikely+0x14c): Section mismatch in reference from the function populate_initrd_image() to the function .init.text:unpack_to_rootfs()
    The function populate_initrd_image() references
    the function __init unpack_to_rootfs().
    This is often because populate_initrd_image lacks a __init
    annotation or the annotation of unpack_to_rootfs is wrong.

    WARNING: vmlinux.o(.text.unlikely+0x198): Section mismatch in reference from the function populate_initrd_image() to the function .init.text:xwrite()
    The function populate_initrd_image() references
    the function __init xwrite().
    This is often because populate_initrd_image lacks a __init
    annotation or the annotation of xwrite is wrong.

Indeed, if the compiler decides not to inline populate_initrd_image(), a
warning is generated.

Fix this by adding the missing __init annotations.

Link: http://lkml.kernel.org/r/20190617074340.12779-1-geert@linux-m68k.org
Fixes: 7c184ecd262fe64f ("initramfs: factor out a helper to populate the initrd image")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -603,7 +603,7 @@ static void __init clean_rootfs(void)
 #endif
 
 #ifdef CONFIG_BLK_DEV_RAM
-static void populate_initrd_image(char *err)
+static void __init populate_initrd_image(char *err)
 {
 	ssize_t written;
 	struct file *file;


