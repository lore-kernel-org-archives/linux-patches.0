Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F231C9B99;
	Tue,  8 Oct 2024 13:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392667; cv=none; b=rhldkHIaXQeA9qbrJx3z3mcnWSz0rxrT2sx2TsbNI0lXQNNugcb+F+P9vfGNTbNTfKE5QJ8T9YG0uO0vsrbnMDShqTMjv3A4N8hUfeHxhyG9Xq0XpAc88ro5cifBkOzzXE89ngpky8Ps9YyIDFEaldNvFl3X+cRjXLx4WjGMtu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392667; c=relaxed/simple;
	bh=B/z36iSRDr2iiWOAEC5bjtlQ67068V6KAdpJ+h+9xcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIS4aWIY6vDCjNTKPZuoXSbUIr5frzDemIrDHg0jgNgyoggHLWdCSUrDoe7i0xrSR8i31ojBwzLTih1HN/Xi04KIMXhH3FPq0om4T+cRLZ5xDVe6Y8bfxV8AIaom+EJWEOymE2iXoGiSOoXD6+esEGqcCEETv6RMfcMBBWAkvEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6+9kaoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6+9kaoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3E6C4CEC7;
	Tue,  8 Oct 2024 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392667;
	bh=B/z36iSRDr2iiWOAEC5bjtlQ67068V6KAdpJ+h+9xcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6+9kaoiEALZ75Yf7GPTzZJyyBQR0h2+Ukn7KoNjdIUTCjSoqvM76afTK252wZT3A
	 JB/rc0fbHYFJjIiBVB7wXUaOwbCBhxQYWrGp85PPBI00HiO33ijDzbDLUvocwTQrSk
	 AxHLAivJQnDmGnhwSmXoln+oc55BI9RvbJUiUmnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ba9eac24453387a9d502@syzkaller.appspotmail.com,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.11 442/558] riscv: Fix kernel stack size when KASAN is enabled
Date: Tue,  8 Oct 2024 14:07:52 +0200
Message-ID: <20241008115719.659134230@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit cfb10de18538e383dbc4f3ce7f477ce49287ff3d upstream.

We use Kconfig to select the kernel stack size, doubling the default
size if KASAN is enabled.

But that actually only works if KASAN is selected from the beginning,
meaning that if KASAN config is added later (for example using
menuconfig), CONFIG_THREAD_SIZE_ORDER won't be updated, keeping the
default size, which is not enough for KASAN as reported in [1].

So fix this by moving the logic to compute the right kernel stack into a
header.

Fixes: a7555f6b62e7 ("riscv: stack: Add config of thread stack size")
Reported-by: syzbot+ba9eac24453387a9d502@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000eb301906222aadc2@google.com/ [1]
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240917150328.59831-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig                   |    3 +--
 arch/riscv/include/asm/thread_info.h |    7 ++++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -763,8 +763,7 @@ config IRQ_STACKS
 config THREAD_SIZE_ORDER
 	int "Kernel stack size (in power-of-two numbers of page size)" if VMAP_STACK && EXPERT
 	range 0 4
-	default 1 if 32BIT && !KASAN
-	default 3 if 64BIT && KASAN
+	default 1 if 32BIT
 	default 2
 	help
 	  Specify the Pages of thread stack size (from 4KB to 64KB), which also
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -13,7 +13,12 @@
 #include <linux/sizes.h>
 
 /* thread information allocation */
-#define THREAD_SIZE_ORDER	CONFIG_THREAD_SIZE_ORDER
+#ifdef CONFIG_KASAN
+#define KASAN_STACK_ORDER	1
+#else
+#define KASAN_STACK_ORDER	0
+#endif
+#define THREAD_SIZE_ORDER	(CONFIG_THREAD_SIZE_ORDER + KASAN_STACK_ORDER)
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
 /*


