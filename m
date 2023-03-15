Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9F94431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E31C433EF;
	Wed, 15 Mar 2023 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884041;
	bh=q5ZOKpxiyQ4ociMUOi0GN0rLZknI2D2yj73EJ1+ckZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUDM3ik2T7Sk/tjTUSPKh5mWMl9XG0hk/4RyH37KpkDLBbcXXwL5lflzWZzC8bzEi
	 /YCkkwY2xHrSljFFcMyrSES/ps/l6CAKYVeBSLAyP7FFLrmhgYTCVvqCP5YIodViRC
	 zJ/4IJk0XmsSjV3PXNKlubZenQILjSRxTNxtuYI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Walsh <vk3heg@vk3heg.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 084/141] m68k: mm: Move initrd phys_to_virt handling after paging_init()
Date: Wed, 15 Mar 2023 13:13:07 +0100
Message-Id: <20230315115742.534772042@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit d4b97925e87eb133e400fe4a482d750c74ce392f ]

When booting with an initial ramdisk on platforms where physical memory
does not start at address zero (e.g. on Amiga):

    initrd: 0ef0602c - 0f800000
    Zone ranges:
      DMA      [mem 0x0000000008000000-0x000000f7ffffffff]
      Normal   empty
    Movable zone start for each node
    Early memory node ranges
      node   0: [mem 0x0000000008000000-0x000000000f7fffff]
    Initmem setup node 0 [mem 0x0000000008000000-0x000000000f7fffff]
    Unable to handle kernel access at virtual address (ptrval)
    Oops: 00000000
    Modules linked in:
    PC: [<00201d3c>] memcmp+0x28/0x56

As phys_to_virt() relies on m68k_memoffset and module_fixup(), it must
not be called before paging_init().  Hence postpone the phys_to_virt
handling for the initial ramdisk until after calling paging_init().

While at it, reduce #ifdef clutter by using IS_ENABLED() instead.

Fixes: 376e3fdecb0dcae2 ("m68k: Enable memtest functionality")
Reported-by: Stephen Walsh <vk3heg@vk3heg.net>
Link: https://lists.debian.org/debian-68k/2022/09/msg00007.html
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/4f45f05f377bf3f5baf88dbd5c3c8aeac59d94f0.camel@physik.fu-berlin.de
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/dff216da09ab7a60217c3fc2147e671ae07d636f.1677528627.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/setup_mm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 3a2bb2e8fdad4..fbff1cea62caa 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -326,16 +326,16 @@ void __init setup_arch(char **cmdline_p)
 		panic("No configuration setup");
 	}
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	if (m68k_ramdisk.size) {
+	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && m68k_ramdisk.size)
 		memblock_reserve(m68k_ramdisk.addr, m68k_ramdisk.size);
+
+	paging_init();
+
+	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && m68k_ramdisk.size) {
 		initrd_start = (unsigned long)phys_to_virt(m68k_ramdisk.addr);
 		initrd_end = initrd_start + m68k_ramdisk.size;
 		pr_info("initrd: %08lx - %08lx\n", initrd_start, initrd_end);
 	}
-#endif
-
-	paging_init();
 
 #ifdef CONFIG_NATFEAT
 	nf_init();
-- 
2.39.2



