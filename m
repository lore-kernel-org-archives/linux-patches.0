Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1659C338593;
	Tue,  6 Jan 2026 17:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720976; cv=none; b=vB+FfyK7xGHhzR4bPLfxp6WWMSJ/byFa4diSgV3aACXs9zPsqOIoidLBnrYRL9BUJtvfTmO0gDIignObIVPO8lvVHcw1urYu8HErCmrJ+5QpGxdbDqxIRJr4VKTcXhutHmGCeXv8nHmViLqnVBZqdSryDIkJXL2/vOf+bZg8/cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720976; c=relaxed/simple;
	bh=MXV9GbzeUSzHlftvFqXtnQM3et9ve1wGNu/sQ4KTz6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aUR69IwkrVqPFZntBj/kT1UrfWgpU6zI7xE36GdIUoDWf93PxVuIuyMKd4qSgL434B9Hu/tlcWwEFZBZedDT9AoH3keOWwnHrrWc2gWavOZkrNdticr4170Rn5elPMCCKD6HU3Ob6HFtuQE90raU965Oy8bjqU3WTERzC0ljjyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZCKNVwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZCKNVwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2204EC116C6;
	Tue,  6 Jan 2026 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720975;
	bh=MXV9GbzeUSzHlftvFqXtnQM3et9ve1wGNu/sQ4KTz6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZCKNVwao8ez/Dnj7D1uYoj0mj0hIN6BMRK5cc9olzBfa0i3Uz/UQTR0tmvH+vm1H
	 zjcHv1JW6aePFs6l8OJYeIrpgrmEyWSuwrVcFSSyX6MPC7WAmiMQLL2qMwmpPwrseH
	 3XisVwI9Q4r7Sv6CJfL+NLwuLs+pQ35PII3lGRoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 399/567] fbdev: gbefb: fix to use physical address instead of dma address
Date: Tue,  6 Jan 2026 18:03:01 +0100
Message-ID: <20260106170506.101349362@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Rene Rebe <rene@exactco.de>

commit e3f44742bbb10537fe53d83d20dea2a7c167674d upstream.

While debuggigng why X would not start on mips64 Sgi/O2 I found the
phys adress being off. Turns out the gbefb passed the internal
dma_addr as phys. May be broken pre git history. Fix by converting
dma_to_phys.

Signed-off-by: René Rebe <rene@exactco.de>
Cc: <stable@vger.kernel.org> # v4.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/gbefb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/gbefb.c
+++ b/drivers/video/fbdev/gbefb.c
@@ -12,6 +12,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma-direct.h>
 #include <linux/errno.h>
 #include <linux/gfp.h>
 #include <linux/fb.h>
@@ -65,7 +66,7 @@ struct gbefb_par {
 static unsigned int gbe_mem_size = CONFIG_FB_GBE_MEM * 1024*1024;
 static void *gbe_mem;
 static dma_addr_t gbe_dma_addr;
-static unsigned long gbe_mem_phys;
+static phys_addr_t gbe_mem_phys;
 
 static struct {
 	uint16_t *cpu;
@@ -1183,7 +1184,7 @@ static int gbefb_probe(struct platform_d
 			goto out_release_mem_region;
 		}
 
-		gbe_mem_phys = (unsigned long) gbe_dma_addr;
+		gbe_mem_phys = dma_to_phys(&p_dev->dev, gbe_dma_addr);
 	}
 
 	par = info->par;


