Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3AF384228;
	Wed, 30 Sep 2026 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783378; cv=none; b=WRKFf7/50bqjDfQ6K/US6MgPNLFK6h3qV7SJ6JWsDDtNlYtm6bM7lLG+bwceWKdH3sDpuGBn5nh3zZOWn7Hy5kSLG0GKaHItdpSzR7BBjuwOu08b8Qugtol2T7hzens18Y4dxrW/168Ej7LxXcSMQ8W+cB2QCubofQom/Hreafw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783378; c=relaxed/simple;
	bh=oERCNvORUtc+qqIzQH1ozQFES+8UDGrq2RGjFKSdpVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ty/xXCtf+XpiGtKxxkjtAkdQxqtlkC8XwEQtqdzavv0vfhij9YalKnVXHz6/RmsIvt6v5I0fxoKH5B5p/c1PVWHxo01xzz2Br/bbDZnHZmiUN8yRA06jVXb6oMo+Ai+Y0IlZqG4kLJlFd0SKv0/03ccO5wb4P7L9V3XwxNrDiGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgMUrqiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgMUrqiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1528A1F0089A;
	Wed, 30 Sep 2026 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783370;
	bh=oYhgWkW6QpAJI/k/u7vYizwTsG7KEm2IVBBo9MTWVPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgMUrqiyChztjgruM1KKbBF7k1Hb21UXQgwYoGwgNJVrEmyVxGAp5mCbUANbpFT3a
	 /39TXu8casiHZd7qsVki8qrLTQ4pDFbRMnQsh2alR8xL/clO5mhLMvokFnEdw2PhZ9
	 oqdyIuzMd22B7Cxy3CbieMqipLNavTQ549s4661U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/595] MIPS: Octeon: apply USB FDT fixups also when USB is modular
Date: Wed, 30 Sep 2026 17:24:28 +0200
Message-ID: <20260930152355.743387191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ce05c0dd3acd7..5faea06737145 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -15,7 +15,7 @@
 #include <asm/octeon/octeon.h>
 #include <asm/octeon/cvmx-helper-board.h>
 
-#ifdef CONFIG_USB
+#if IS_ENABLED(CONFIG_USB)
 #include <linux/usb/ehci_def.h>
 #include <linux/usb/ehci_pdriver.h>
 #include <linux/usb/ohci_pdriver.h>
@@ -1079,7 +1079,7 @@ int __init octeon_prune_device_tree(void)
 		;
 	}
 
-#ifdef CONFIG_USB
+#if IS_ENABLED(CONFIG_USB)
 	/* OHCI/UHCI USB */
 	alias_prop = fdt_getprop(initial_boot_params, aliases,
 				 "uctl", NULL);
-- 
2.53.0



