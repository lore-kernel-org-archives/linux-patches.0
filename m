Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60201170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F49C433C9;
	Mon, 11 Sep 2023 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442161;
	bh=k5Crcnreq/RtUezUFJZ8rtzCkgY1eThhlZdZdHYEB2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgzh7aMQyusZIhDt4NBupCxjgfDPd3L+8LkZU7AwnfU02/levUi6rQak6DNGvAsBS
	 WpQ0y7CLdq4AqM3oQqGsPjv4MYKIvdatigQpYDJLzJwrbjStiIT5th/DjGDzNJeQK1
	 JylRhy/ArVCnCMorDWEkmYW+DiAx8Omw8EJHBmHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH 6.5 640/739] parisc: ccio-dma: Create private runway procfs root entry
Date: Mon, 11 Sep 2023 15:47:19 +0200
Message-ID: <20230911134708.971748108@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 77e0ddf097d6d4ceaf898e088b133b99e0a97fa0 upstream.

Create an own procfs "runway" root entry for the CCIO driver.
No need to share it with the sba_iommu driver, as only one
of those busses can be active in one machine anyway.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 547259580dfa ("parisc: Move proc_mckinley_root and proc_runway_root to sba_iommu")
Cc: <stable@vger.kernel.org> # v6.5
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/runway.h |    3 ---
 drivers/parisc/ccio-dma.c        |   11 +++++++----
 drivers/parisc/sba_iommu.c       |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/parisc/include/asm/runway.h
+++ b/arch/parisc/include/asm/runway.h
@@ -2,9 +2,6 @@
 #ifndef ASM_PARISC_RUNWAY_H
 #define ASM_PARISC_RUNWAY_H
 
-/* declared in arch/parisc/kernel/setup.c */
-extern struct proc_dir_entry * proc_runway_root;
-
 #define RUNWAY_STATUS	0x10
 #define RUNWAY_DEBUG	0x40
 
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -71,8 +71,6 @@
 #undef CCIO_COLLECT_STATS
 #endif
 
-#include <asm/runway.h>		/* for proc_runway_root */
-
 #ifdef DEBUG_CCIO_INIT
 #define DBG_INIT(x...)  printk(x)
 #else
@@ -1567,10 +1565,15 @@ static int __init ccio_probe(struct pari
 
 #ifdef CONFIG_PROC_FS
 	if (ioc_count == 0) {
-		proc_create_single(MODULE_NAME, 0, proc_runway_root,
+		struct proc_dir_entry *runway;
+
+		runway = proc_mkdir("bus/runway", NULL);
+		if (runway) {
+			proc_create_single(MODULE_NAME, 0, runway,
 				ccio_proc_info);
-		proc_create_single(MODULE_NAME"-bitmap", 0, proc_runway_root,
+			proc_create_single(MODULE_NAME"-bitmap", 0, runway,
 				ccio_proc_bitmap_info);
+		}
 	}
 #endif
 	ioc_count++;
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -121,7 +121,7 @@ module_param(sba_reserve_agpgart, int, 0
 MODULE_PARM_DESC(sba_reserve_agpgart, "Reserve half of IO pdir as AGPGART");
 #endif
 
-struct proc_dir_entry *proc_runway_root __ro_after_init;
+static struct proc_dir_entry *proc_runway_root __ro_after_init;
 struct proc_dir_entry *proc_mckinley_root __ro_after_init;
 
 /************************************


