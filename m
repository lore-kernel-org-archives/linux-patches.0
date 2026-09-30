Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FCC3DB625;
	Wed, 30 Sep 2026 19:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795977; cv=none; b=t6KvuvMlaYaNkq1rAlfmdzSyJW03k7/oIwCgq+rI3ocrRtJ6l7NGVH2oOq3lqqiJ3j9LOXVMI3ZlmKCPL5NhfrnRGqfb5pFfoAt7kL/gD6zAOA0ZV60o5+WZgCI3A/1TWvNBYSYsBTWAwojfp6ZlFVaJTDxBb3ahM/1nnAadQtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795977; c=relaxed/simple;
	bh=55FgEGhu7mL+by7/z5l7ynknHKUjCftmJGfgxPiP4ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUKPsmBbWFcEQK2LAHbNoG2c8Fp/9xb+ajwhy0c3NCZRJxBv1w3YFf26sI2vWrd3q2UJvgjWgIQ3jO2VoQ0KK89jKr7B8J4PL9/SpMZ3KSx4GWtbogzcjCML7M7CBnr2c6ll619avqn/cahxJdm1xTdOmlwbvskJujYYrpAvofE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYkqagLa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYkqagLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DAB1F000FF;
	Wed, 30 Sep 2026 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795975;
	bh=J3loEOEwjKyR67ebzhAmkqAthrAUKlFVnvA4G0t9nRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYkqagLaGy5Bfk0J+V5FiUtw0xJ84fe98ePGEf+01WfUcygREfdWIN2ybW3DvSO1d
	 Bhm0oWnIim70u5f5cfg+tCSekZqVD2pReTJF2qhCqorrQg5xuzhan7RzVAeIrCUVUn
	 pIGrLIl6VmrxUFo3FVg+4L1tDDDJSyrgCKZmWl2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0748/1193] MIPS: Octeon: apply USB FDT fixups also when USB is modular
Date: Wed, 30 Sep 2026 17:23:52 +0200
Message-ID: <20260930152450.868120442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f76783c24338b..43621c73fceb7 100644
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



