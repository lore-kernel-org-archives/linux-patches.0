Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B99078F49;
	Mon,  6 Jan 2025 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177335; cv=none; b=PLBVvHeLPVSwyFn2bGrJVCa8c9lT4C4Gmkm/gdTLlhrlJSJDWPuZvKIjk3kiH4vEF5Pf0KIRuCUP/sRschyk91zccUqVbVblvtJBCXvIVkvnOR3ylrQcbSMboOnem8bryXbZ2LkMWW/RL9hcXBvlCOlxEFyqrxmzbSgZkZAM3HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177335; c=relaxed/simple;
	bh=oaJqkThNypgSzAQGpT8EdChSlFJeC8Sz40filrnGVbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flot8DZB4V0OjDGZmjIJaS/2Bk7e8NVt2swA4P3ys4Q7cWX5CU8rDbppRKU7aHJrScO/AY+aZJ4sb1etfXHx5ybQZzToG/ybQNSKEeO2eRVLQFcBDmQnaOdW3cWLLowGRJFuxNg/5DfFKAdNe590kWYT4oKSjkqS4X+d4M0RdJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dx25wd0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dx25wd0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1105C4CED2;
	Mon,  6 Jan 2025 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177335;
	bh=oaJqkThNypgSzAQGpT8EdChSlFJeC8Sz40filrnGVbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dx25wd0JMiwN2BJvoUNy6q8+ybzwymTWTsjLS/wCpQYD9FOrGEjihzFk8rl7H3/Ix
	 rh5Dh9kmlNBNK+d0osF9SPJYzZ9vF9mUrZkWu8ogEHzka3CM4ztEN+IoN5TzQ0vGC5
	 xlqC+1YCWEwKDiaN2GXDxWS7qF4VAR+auTPDu4bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Xin Li <xin3.li@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shan Kang <shan.kang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>
Subject: [PATCH 6.6 098/222] x86/ptrace: Add FRED additional information to the pt_regs structure
Date: Mon,  6 Jan 2025 16:15:02 +0100
Message-ID: <20250106151154.305482563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xin Li <xin3.li@intel.com>

[ Upstream commit 3c77bf02d0c03beb3efdf7a5b427fb2e1a76c265 ]

FRED defines additional information in the upper 48 bits of cs/ss
fields. Therefore add the information definitions into the pt_regs
structure.

Specifically introduce a new structure fred_ss to denote the FRED flags
above SS selector, which avoids FRED_SSX_ macros and makes the code
simpler and easier to read.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Originally-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Shan Kang <shan.kang@intel.com>
Link: https://lore.kernel.org/r/20231205105030.8698-15-xin3.li@intel.com
Stable-dep-of: dc81e556f2a0 ("x86/fred: Clear WFE in missing-ENDBRANCH #CPs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/ptrace.h | 66 ++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index b268cd2a2d01..5a83fbd9bc0b 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -56,6 +56,50 @@ struct pt_regs {
 
 #else /* __i386__ */
 
+struct fred_cs {
+		/* CS selector */
+	u64	cs	: 16,
+		/* Stack level at event time */
+		sl	:  2,
+		/* IBT in WAIT_FOR_ENDBRANCH state */
+		wfe	:  1,
+			: 45;
+};
+
+struct fred_ss {
+		/* SS selector */
+	u64	ss	: 16,
+		/* STI state */
+		sti	:  1,
+		/* Set if syscall, sysenter or INT n */
+		swevent	:  1,
+		/* Event is NMI type */
+		nmi	:  1,
+			: 13,
+		/* Event vector */
+		vector	:  8,
+			:  8,
+		/* Event type */
+		type	:  4,
+			:  4,
+		/* Event was incident to enclave execution */
+		enclave	:  1,
+		/* CPU was in long mode */
+		lm	:  1,
+		/*
+		 * Nested exception during FRED delivery, not set
+		 * for #DF.
+		 */
+		nested	:  1,
+			:  1,
+		/*
+		 * The length of the instruction causing the event.
+		 * Only set for INTO, INT1, INT3, INT n, SYSCALL
+		 * and SYSENTER.  0 otherwise.
+		 */
+		insnlen	:  4;
+};
+
 struct pt_regs {
 	/*
 	 * C ABI says these regs are callee-preserved. They aren't saved on
@@ -85,6 +129,12 @@ struct pt_regs {
 	 * - the syscall number (syscall, sysenter, int80)
 	 * - error_code stored by the CPU on traps and exceptions
 	 * - the interrupt number for device interrupts
+	 *
+	 * A FRED stack frame starts here:
+	 *   1) It _always_ includes an error code;
+	 *
+	 *   2) The return frame for ERET[US] starts here, but
+	 *      the content of orig_ax is ignored.
 	 */
 	unsigned long orig_ax;
 
@@ -92,24 +142,30 @@ struct pt_regs {
 	unsigned long ip;
 
 	union {
-		/* The full 64-bit data slot containing CS */
-		u64		csx;
 		/* CS selector */
 		u16		cs;
+		/* The extended 64-bit data slot containing CS */
+		u64		csx;
+		/* The FRED CS extension */
+		struct fred_cs	fred_cs;
 	};
 
 	unsigned long flags;
 	unsigned long sp;
 
 	union {
-		/* The full 64-bit data slot containing SS */
-		u64		ssx;
 		/* SS selector */
 		u16		ss;
+		/* The extended 64-bit data slot containing SS */
+		u64		ssx;
+		/* The FRED SS extension */
+		struct fred_ss	fred_ss;
 	};
 
 	/*
-	 * Top of stack on IDT systems.
+	 * Top of stack on IDT systems, while FRED systems have extra fields
+	 * defined above for storing exception related information, e.g. CR2 or
+	 * DR6.
 	 */
 };
 
-- 
2.39.5



