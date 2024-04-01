Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6464446B6;
	Mon,  1 Apr 2024 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991030; cv=none; b=ILqzTHWbPxPWyT8a6GQzoSlJhFb4vocq6b+k6zdaXOh9p6dJD1ttYV0kWzpTDjr47zM60sKa4sKf+Z7s5Wy5nFN8gjsjpgZbz536ni0MuPoLotqqUBijeIbQTYIStWyBGE8QO/8Om3efzjrXHkMZU7D7mEJplIGWqjQzDnIYK6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991030; c=relaxed/simple;
	bh=TpMHaEso2mYRwTkYIKKUJpAkjr9byp0g7HAOGruS1hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXwaDxRbzAQhUXINYc/0z5QHj1gfYwW+tZG8gzLPfFqoyQx8Y0mYIHQ797jAHBMXd3VMAGlL8dJ1Mt8Gh1B/Bq7PDUBSJD6CWp9qJZK/XK5EOwiWinf7Y0cwyjsJGtRlQggzcvk5AuhYUS0tZYRU0r8fKERRr6oT/OxrITi5m84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaRZ6WAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaRZ6WAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97F7C433F1;
	Mon,  1 Apr 2024 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991030;
	bh=TpMHaEso2mYRwTkYIKKUJpAkjr9byp0g7HAOGruS1hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaRZ6WAalRDDTfXLnBPExScRMpuuB/P+J4xHuJiwk+zeI5sYHER09cuyS0oYKTbk1
	 ZbOpJKHmUhY6+i3/ZLLbVhnZijXsl8yKgPGYeRO/G+wu1dY4nXMreApgrXQRxykX73
	 FF4lluQa9AK2uKDGL17xFiS8o3fWH//t2ChW/1zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Altaparmakov <anton@tuxera.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/272] x86/pm: Work around false positive kmemleak report in msr_build_context()
Date: Mon,  1 Apr 2024 17:45:31 +0200
Message-ID: <20240401152535.091304346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Altaparmakov <anton@tuxera.com>

[ Upstream commit e3f269ed0accbb22aa8f25d2daffa23c3fccd407 ]

Since:

  7ee18d677989 ("x86/power: Make restore_processor_context() sane")

kmemleak reports this issue:

  unreferenced object 0xf68241e0 (size 32):
    comm "swapper/0", pid 1, jiffies 4294668610 (age 68.432s)
    hex dump (first 32 bytes):
      00 cc cc cc 29 10 01 c0 00 00 00 00 00 00 00 00  ....)...........
      00 42 82 f6 cc cc cc cc cc cc cc cc cc cc cc cc  .B..............
    backtrace:
      [<461c1d50>] __kmem_cache_alloc_node+0x106/0x260
      [<ea65e13b>] __kmalloc+0x54/0x160
      [<c3858cd2>] msr_build_context.constprop.0+0x35/0x100
      [<46635aff>] pm_check_save_msr+0x63/0x80
      [<6b6bb938>] do_one_initcall+0x41/0x1f0
      [<3f3add60>] kernel_init_freeable+0x199/0x1e8
      [<3b538fde>] kernel_init+0x1a/0x110
      [<938ae2b2>] ret_from_fork+0x1c/0x28

Which is a false positive.

Reproducer:

  - Run rsync of whole kernel tree (multiple times if needed).
  - start a kmemleak scan
  - Note this is just an example: a lot of our internal tests hit these.

The root cause is similar to the fix in:

  b0b592cf0836 x86/pm: Fix false positive kmemleak report in msr_build_context()

ie. the alignment within the packed struct saved_context
which has everything unaligned as there is only "u16 gs;" at start of
struct where in the past there were four u16 there thus aligning
everything afterwards.  The issue is with the fact that Kmemleak only
searches for pointers that are aligned (see how pointers are scanned in
kmemleak.c) so when the struct members are not aligned it doesn't see
them.

Testing:

We run a lot of tests with our CI, and after applying this fix we do not
see any kmemleak issues any more whilst without it we see hundreds of
the above report. From a single, simple test run consisting of 416 individual test
cases on kernel 5.10 x86 with kmemleak enabled we got 20 failures due to this,
which is quite a lot. With this fix applied we get zero kmemleak related failures.

Fixes: 7ee18d677989 ("x86/power: Make restore_processor_context() sane")
Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240314142656.17699-1-anton@tuxera.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/suspend_32.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index a800abb1a9925..d8416b3bf832e 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -12,11 +12,6 @@
 
 /* image of the saved processor state */
 struct saved_context {
-	/*
-	 * On x86_32, all segment registers except gs are saved at kernel
-	 * entry in pt_regs.
-	 */
-	u16 gs;
 	unsigned long cr0, cr2, cr3, cr4;
 	u64 misc_enable;
 	struct saved_msrs saved_msrs;
@@ -27,6 +22,11 @@ struct saved_context {
 	unsigned long tr;
 	unsigned long safety;
 	unsigned long return_address;
+	/*
+	 * On x86_32, all segment registers except gs are saved at kernel
+	 * entry in pt_regs.
+	 */
+	u16 gs;
 	bool misc_enable_saved;
 } __attribute__((packed));
 
-- 
2.43.0



