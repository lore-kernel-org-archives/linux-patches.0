Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A415E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6u7YBJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFC3C433C8;
	Mon, 23 Oct 2023 11:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061058;
	bh=p3ep+pYMxWToEnrEmCLLwHNhiU91jlMq00M8kGxTzdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6u7YBJKnG4hkia66SwUccmJJT7z/yf+OgElxHC5113DcLxcrY50Ni5ZrEMNtwFXO
	 mhngYU0sZa/YfQrT+rKdV4hKMeVu3TNLyrNNGAIfHtagvpDC9C2tyuNTvfnzYuZz/h
	 nHkZG2ba6AEUUiuNN0rCkSqJesjMeB/6O6tHDROo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/137] perf/x86/lbr: Filter vsyscall addresses
Date: Mon, 23 Oct 2023 12:56:56 +0200
Message-ID: <20231023104822.971018350@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JP Kobryn <inwardvessel@gmail.com>

[ Upstream commit e53899771a02f798d436655efbd9d4b46c0f9265 ]

We found that a panic can occur when a vsyscall is made while LBR sampling
is active. If the vsyscall is interrupted (NMI) for perf sampling, this
call sequence can occur (most recent at top):

    __insn_get_emulate_prefix()
    insn_get_emulate_prefix()
    insn_get_prefixes()
    insn_get_opcode()
    decode_branch_type()
    get_branch_type()
    intel_pmu_lbr_filter()
    intel_pmu_handle_irq()
    perf_event_nmi_handler()

Within __insn_get_emulate_prefix() at frame 0, a macro is called:

    peek_nbyte_next(insn_byte_t, insn, i)

Within this macro, this dereference occurs:

    (insn)->next_byte

Inspecting registers at this point, the value of the next_byte field is the
address of the vsyscall made, for example the location of the vsyscall
version of gettimeofday() at 0xffffffffff600000. The access to an address
in the vsyscall region will trigger an oops due to an unhandled page fault.

To fix the bug, filtering for vsyscalls can be done when
determining the branch type. This patch will return
a "none" branch if a kernel address if found to lie in the
vsyscall region.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/utils.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/utils.c b/arch/x86/events/utils.c
index a32368945462f..b30508b88bf22 100644
--- a/arch/x86/events/utils.c
+++ b/arch/x86/events/utils.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <asm/insn.h>
+#include <linux/mm.h>
 
 #include "perf_event.h"
 
@@ -58,9 +59,9 @@ int branch_type(unsigned long from, unsigned long to, int abort)
 		 * The LBR logs any address in the IP, even if the IP just
 		 * faulted. This means userspace can control the from address.
 		 * Ensure we don't blindly read any address by validating it is
-		 * a known text address.
+		 * a known text address and not a vsyscall address.
 		 */
-		if (kernel_text_address(from)) {
+		if (kernel_text_address(from) && !in_gate_area_no_mm(from)) {
 			addr = (void *)from;
 			/*
 			 * Assume we can get the maximum possible size
-- 
2.40.1



