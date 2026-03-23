Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848C83C07A;
	Mon, 23 Mar 2026 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275631; cv=none; b=ICIbLkK9pBhpyvZlu79lekRT59nYCcyG65ZKD/vuIzba8K+4B4RLo0f1nOliOpkQyYI8JdNlxv2uYk6eQ4NN97uuwrgJIazN+7jJmR14zFrXP/aKAcdpy/3kO3s7p8XwpH78z9HGcWrpfPBaj+H0+ZimuoX7c2LlZS/qSAOT664=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275631; c=relaxed/simple;
	bh=KVuz//zdj8Wac6LZ0uZ9Boqp8L1y2S7pQKrzAQCWkjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuxGoCvHniiVZ361HgbpdbhpP5eHM0BDgKxsCZxlsMwC6JuvpneRJNWTl7BLqvts6/+fmC2tCjYP8jESORzcuNdmRi7kWO7L4NyILtBBeMwu132ovTCSo0dqSiNbTOi4TiqYn3VsFfSGilJsn7gSeCy+zmewL+TBmEPY7+gXFiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbHvAEc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbHvAEc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E41AC2BC9E;
	Mon, 23 Mar 2026 14:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275631;
	bh=KVuz//zdj8Wac6LZ0uZ9Boqp8L1y2S7pQKrzAQCWkjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbHvAEc8HyX46DvBJpOvGUdwjGAwVQAn+d27Y3lwbdvweDe301qHLN4vskdttBHoL
	 /fwRH/BQM82FGqJl5BK8o/lPcIDZHct/SaupkQJL792ur1dPWEOzDfzpF61go6uwe0
	 Ln2q6fS4bmeVfM5oqb6DD+zACbMve10rHNkPNdkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 166/460] parisc: Check kernel mapping earlier at bootup
Date: Mon, 23 Mar 2026 14:42:42 +0100
Message-ID: <20260323134530.630298066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
 


