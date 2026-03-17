Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6BA3BFE59;
	Tue, 17 Mar 2026 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766580; cv=none; b=XBP2N1ndnK8vpixHLbbPpOFjrWEHdcGFdB8UNTtkDa5zb+S1uNwlHl4Gw1OdvwXzeuVUPAFv5sZzc8dNdyXjjcExUfruNvgXGs9Ygfoz7htpPVeHeOV7NJO0ElwDh0LEiWkZdjMqQtnBCFSRCiRcmi0ZmhL4PIo4VNUbaqhC4/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766580; c=relaxed/simple;
	bh=y42JvOx51yrTt0bX7zVQDyNZiYPrmV3KFe26VtAyc3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv783tCuALLEe76zstcgDtbkgEOZWGoRM4OOgg8jCwNUni69P+hgj4W7YgyZ7xNza78ub6wlmUvaUOppFc0tF4Odo6SVKHMlvLvBN39luAKYERMjI0YfBjHdz1HDPPifd8W5E86TaTMHF0IRGBedI/+IGmBTlSZBgARW98TKu4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j75opD5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j75opD5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B28C4CEF7;
	Tue, 17 Mar 2026 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766580;
	bh=y42JvOx51yrTt0bX7zVQDyNZiYPrmV3KFe26VtAyc3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j75opD5TA5Ly0NIXBZUEArwadipGaILxMNiuM+35VSduwsMq4vdu7kahJ4NbVI3pX
	 5M5fLl2pem2ABK7qN1Tnces3DRYIRkshJm+w9awQJ5v7xMhPj1mdD2Eih9uQyBPjTI
	 AfJD9Aq5JORf2CV6ryxp+y6kJIf+DwB+2rSfSaG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.19 277/378] parisc: Check kernel mapping earlier at bootup
Date: Tue, 17 Mar 2026 17:33:54 +0100
Message-ID: <20260317163017.197484487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 17c144f1104bfc29a3ce3f7d0931a1bfb7a3558c upstream.

The check if the initial mapping is sufficient needs to happen much
earlier during bootup. Move this test directly to the start_parisc()
function and use native PDC iodc functions to print the warning, because
panic() and printk() are not functional yet.

This fixes boot when enabling various KALLSYSMS options which need
much more space.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/setup.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -120,14 +120,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	printk(KERN_CONT ".\n");
 
-	/*
-	 * Check if initial kernel page mappings are sufficient.
-	 * panic early if not, else we may access kernel functions
-	 * and variables which can't be reached.
-	 */
-	if (__pa((unsigned long) &_end) >= KERNEL_INITIAL_SIZE)
-		panic("KERNEL_INITIAL_ORDER too small!");
-
 #ifdef CONFIG_64BIT
 	if(parisc_narrow_firmware) {
 		printk(KERN_INFO "Kernel is using PDC in 32-bit mode.\n");
@@ -279,6 +271,18 @@ void __init start_parisc(void)
 	int ret, cpunum;
 	struct pdc_coproc_cfg coproc_cfg;
 
+	/*
+	 * Check if initial kernel page mapping is sufficient.
+	 * Print warning if not, because we may access kernel functions and
+	 * variables which can't be reached yet through the initial mappings.
+	 * Note that the panic() and printk() functions are not functional
+	 * yet, so we need to use direct iodc() firmware calls instead.
+	 */
+	const char warn1[] = "CRITICAL: Kernel may crash because "
+			     "KERNEL_INITIAL_ORDER is too small.\n";
+	if (__pa((unsigned long) &_end) >= KERNEL_INITIAL_SIZE)
+		pdc_iodc_print(warn1, sizeof(warn1) - 1);
+
 	/* check QEMU/SeaBIOS marker in PAGE0 */
 	running_on_qemu = (memcmp(&PAGE0->pad0, "SeaBIOS", 8) == 0);
 


