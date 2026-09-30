Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6CF5187EE;
	Wed, 30 Sep 2026 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788227; cv=none; b=GSXpW3zN0J4Cx83iOLgChGbyiisz/1Ko5WdbXVejiqOPWqDmJnfd9x1hfFZOyeZASlNSPiAvx7wcuLmMmRmpeeeg/gYpagqcP5Oy3jMoGD1Ax6ns0C3e0rMopWKh4n/YoGdwPrSMT7BZSeWT5TZvBzKOPUP6zyswjp4nhhoXAOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788227; c=relaxed/simple;
	bh=zEUvkW/eXhrfl/xblG8Z9pEv+MbLWog6YFre9qw4Mlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stXuEVpjlTMDIGoGpdPFjoYdi+EKi1bSY465QfWLgu9y+PUUqQSVMJL+jCGNHJjLBfcgWE7DA/7TRWt4oYQ4GMt/J5S/Bh7mdF7JQybXYuSmuVoyFTxmAt1UCRsm128EuvSron5tcEywF0jf70WOpstFbZE4BqiqWeRYPeUkV2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnFBN+2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnFBN+2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64281F000FF;
	Wed, 30 Sep 2026 17:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788226;
	bh=pKShE7Fr8zlzhhLWyMFKDtJlKWuAJFJDZ9KmiO80pLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnFBN+2F5IRjL5q8L4mR4sIYlPoqBkQUKIocMvd2Saypeq4kEnLt4zCIRJ4LRhriK
	 r0wNU8/rVdY2Yd61fE15YEktBbYqptcHGKEn5PjTRnrfOz803l11xHmjVNxEJW2Z3r
	 CpuPKIOCodWteb+wBU4AMrzjsvrvpne2FlE1lYuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/877] MIPS: Octeon: apply USB FDT fixups also when USB is modular
Date: Wed, 30 Sep 2026 17:16:00 +0200
Message-ID: <20260930152415.806287235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit 126f16e0a1b353c2ba5c7e2c8626cfa865934f9f ]

The uctl/usbn device-tree fixups in octeon_prune_device_tree() - which
set the board's USB reference-clock frequency and type from
__cvmx_helper_board_usb_get_clock_type() - are guarded by
"#ifdef CONFIG_USB", which is false when USB is built as a module. The
fixups then silently disappear and octeon-hcd sees whatever default the
DTS carries (12MHz crystal in octeon_3xxx.dts), leaving the PHY dead or
the bus erroring on boards with a different reference clock.

Use IS_ENABLED() so USB=m gets the same fixups as USB=y.

Fixes: 7fd57ab9d9cf ("MIPS: Octeon: Fix compile error when USB is not enabled.")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/octeon-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 5e1dd4e6e82fb..4b5c99e6f5bcc 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -17,7 +17,7 @@
 #include <asm/octeon/octeon.h>
 #include <asm/octeon/cvmx-helper-board.h>
 
-#ifdef CONFIG_USB
+#if IS_ENABLED(CONFIG_USB)
 #include <linux/usb/ehci_def.h>
 #include <linux/usb/ehci_pdriver.h>
 #include <linux/usb/ohci_pdriver.h>
@@ -1080,7 +1080,7 @@ int __init octeon_prune_device_tree(void)
 		;
 	}
 
-#ifdef CONFIG_USB
+#if IS_ENABLED(CONFIG_USB)
 	/* OHCI/UHCI USB */
 	alias_prop = fdt_getprop(initial_boot_params, aliases,
 				 "uctl", NULL);
-- 
2.53.0



