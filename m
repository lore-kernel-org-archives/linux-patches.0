Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4163150C2A7;
	Wed, 30 Sep 2026 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785754; cv=none; b=UY8kI/3sY8zEWyYW12/GZbt2n26tYn/L50felVJR+XQuDwLxDDAYt/htUfUejg0NAcL11vEM3aarKGCuIsKBQgCV/RoVCnPkSYynGQoCw7VJnp2q/inPxAz1t1KAOnPHZnAaNIc2sEBN6e/mBgml4meggkH4a2KxRkq4hr4NFtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785754; c=relaxed/simple;
	bh=mYyUeQTHnXUtVIAktl5CE2O0uZTlw+sx5mIZHxBCG+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEyE1cMSgWdEqDJRskiCKzKxr6QF5W5AIZygQgOjZoq9JxMk9UBxwR3EAenDh4tveDgahggCRUCdywiExCYJWZoNNMCZDTItSmK/4S/g4I5taKikM4jpggjc9M451T41VDerhWshC8k4Iuu41Mn2/2oLIN26E113XzDHth+NP3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz/XRiTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz/XRiTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C94A1F000FF;
	Wed, 30 Sep 2026 16:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785753;
	bh=Uew8Gc8Hl9DUtLTM2JY5M22VKRWneb4Px0bZ6ZTwhbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qz/XRiTgqm3CRV769GqpkYtJUf949VBhWwmCYQsku6qnsnaCR6WF/hCxYua1utB4R
	 PWs3EsDWfLnxIiklGHbb5SUf2j3+lm+JzY5WbUyHDDpcfn1soUvABNFSOU2Pgo+TKA
	 /p6vX2FTdl4ivY5lL8aoweLDw5RSTlTnAeSLLCRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 619/982] MIPS: Octeon: apply USB FDT fixups also when USB is modular
Date: Wed, 30 Sep 2026 17:22:35 +0200
Message-ID: <20260930152430.071497845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



