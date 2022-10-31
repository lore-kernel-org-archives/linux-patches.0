Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416A417F3
	for <patches@lists.linux.dev>; Mon, 31 Oct 2022 07:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EE0C433D6;
	Mon, 31 Oct 2022 07:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667199813;
	bh=PVt5hY1gSSLjJUQ2tcPRxGC1hcYodD3U62WliJHhyQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z17BXq4t8/gH50FXC0uO6jmUQ9zHcmumRCmABPSGBpdJ3GeDC8AEKSMgQlCS0i7KM
	 BaooUdKOQaZ70XCPRMz/9v7Nib/Vw02JYSfWlb3UGDUZVtcWWaJsalkrh8YzoA9n7n
	 9fg6GALfZurGw02Uz0Xj2I/+GYXu8a/HA70mHFmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.14 03/34] x86/cpufeature: Fix various quality problems in the <asm/cpu_device_hd.h> header
Date: Mon, 31 Oct 2022 08:02:36 +0100
Message-Id: <20221031070140.193632481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ingo Molnar <mingo@kernel.org>

commit 266d63a7d9d48c6d5dee486378ec0e8c86c4d74a upstream

Thomas noticed that the new arch/x86/include/asm/cpu_device_id.h header is
a train-wreck that didn't incorporate review feedback like not using __u8
in kernel-only headers.

While at it also fix all the *other* problems this header has:

 - Use canonical names for the header guards. It's inexplicable why a non-standard
   guard was used.

 - Don't define the header guard to 1. Plus annotate the closing #endif as done
   absolutely every other header. Again, an inexplicable source of noise.

 - Move the kernel API calls provided by this header next to each other, there's
   absolutely no reason to have them spread apart in the header.

 - Align the INTEL_CPU_DESC() macro initializations vertically, this is easier to
   read and it's also the canonical style.

 - Actually name the macro arguments properly: instead of 'mod, step, rev',
   spell out 'model, stepping, revision' - it's not like we have a lack of
   characters in this header.

 - Actually make arguments macro-safe - again it's inexplicable why it wasn't
   done properly to begin with.

Quite amazing how many problems a 41 lines header can contain.

This kind of code quality is unacceptable, and it slipped through the
review net of 2 developers and 2 maintainers, including myself, until
Thomas noticed it. :-/

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu_device_id.h |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _CPU_DEVICE_ID
-#define _CPU_DEVICE_ID 1
+#ifndef _ASM_X86_CPU_DEVICE_ID
+#define _ASM_X86_CPU_DEVICE_ID
 
 /*
  * Declare drivers belonging to specific x86 CPUs
@@ -9,8 +9,6 @@
 
 #include <linux/mod_devicetable.h>
 
-extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
-
 /*
  * Match specific microcode revisions.
  *
@@ -22,21 +20,22 @@ extern const struct x86_cpu_id *x86_matc
  */
 
 struct x86_cpu_desc {
-	__u8	x86_family;
-	__u8	x86_vendor;
-	__u8	x86_model;
-	__u8	x86_stepping;
-	__u32	x86_microcode_rev;
+	u8	x86_family;
+	u8	x86_vendor;
+	u8	x86_model;
+	u8	x86_stepping;
+	u32	x86_microcode_rev;
 };
 
-#define INTEL_CPU_DESC(mod, step, rev) {			\
-	.x86_family = 6,					\
-	.x86_vendor = X86_VENDOR_INTEL,				\
-	.x86_model = mod,					\
-	.x86_stepping = step,					\
-	.x86_microcode_rev = rev,				\
+#define INTEL_CPU_DESC(model, stepping, revision) {		\
+	.x86_family		= 6,				\
+	.x86_vendor		= X86_VENDOR_INTEL,		\
+	.x86_model		= (model),			\
+	.x86_stepping		= (stepping),			\
+	.x86_microcode_rev	= (revision),			\
 }
 
+extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
 
-#endif
+#endif /* _ASM_X86_CPU_DEVICE_ID */


