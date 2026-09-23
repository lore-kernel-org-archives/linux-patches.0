Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD863A1681;
	Wed, 23 Sep 2026 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172774; cv=none; b=NSOuSlq9lJKGWrIQFMCB23TC4kS8+lrvmq0PcZFP6KqwNloR3wlimJdwgn3fISNOsecHRP4cZBzf0QecekYFbDapKuVXeYG29u+FeViqG6PwQfWqUBI8IKLcxLBFvO8VrHRUmAUBgtx8mHm4vFfTOCozXoP8f2B5FtQlRyWTRTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172774; c=relaxed/simple;
	bh=GB9DgswRc/td9fMbPbmcCJwPceuflhaPR18O3BCE3RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9umoVeKF5V+CiYDxcl0npAcM48Uog9r3zX06Hv3v5D6WnYIkseOYlehmF/i+uzZzXeWPI+UZUQhS8gyjJcxZNbYqUmanWmr4vJ1jnkXa6KTfqHvmooWUvSncfHOXOx+GycceXi4/bNxbk2UXdyEPVegu4I6ligQvC6oQlt5UkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXhIHekS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXhIHekS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CA71F000FF;
	Wed, 23 Sep 2026 14:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172772;
	bh=3bgGgoxwJL+CtqQZHFuqs4reR1qE7zasmG3h6GJsXB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXhIHekSTAVk38aj/tTbTSmWOHM3SjxlW1xgOFNuG+ooRs4E1EyR6lQLZS1FTSYxE
	 H/0/HzxXMerUVJiN93614k8CmqDEhHY9L03JzWeMBVnxC25fFW6RbHDCEHoJeY+7As
	 9EkaVbEh4mGRWJK5WLNEe8snJzSf0DDZsIE9uhvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 058/438] MIPS: Octeon: apply USB FDT fixups also when USB is modular
Date: Wed, 23 Sep 2026 16:01:19 +0200
Message-ID: <20260923140646.290173897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 47677b5d7ed00..f53c98372e0be 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -18,7 +18,7 @@
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



