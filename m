Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8393AFB06;
	Sat, 12 Sep 2026 08:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201407; cv=none; b=PUWi8TKpMRFqeRIp0UFzuVWi9bm2csogcbGFwY0p1o8z4c613GNPEttNPEZ/xSoSnswTgrkLAC7rGvismSYArsBjyz2lyutY0WxoLp1uSiu65g1y5A5BB/ofAnq8ZuXdrYVaXDw8VifWz5Tx7lbIbUAFPrS+wDTZc1m7Vbaw8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201407; c=relaxed/simple;
	bh=oCnXibcvD64WC8yerPlUhJGkt3XeUqB351udTnuNnMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lByrW59nsPGfxIGsN7WtECYPXAF9NgRbqkO5iA9iQ69IlU0B6C6HysRXdqjPUUV9RimLunwMVlpal0Q3BASkAjKj1JSePJJdXz098nIRTosubq7e1yFtNDIZWPI/hHm02DyHJ7AnWOtooljgKTNcTQwM+Rxw9V9swozoXm95dOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFH69x4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFH69x4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBE51F000FF;
	Sat, 12 Sep 2026 08:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201402;
	bh=5gtcyYB6zVpNuLJ6CcDGRqaxWwEkkx/K6RPw6Jr9A1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFH69x4BJ9k4CVb1KdMk9UDuSIQRv1lLKSo7TiwAEWd+4nsKphnbn4PxT8Ow08GpS
	 kzXQ+v2AmLKbFbnaHzV8mabq6gkK549ulWO0JtkcNAMgWY7Bh4jlbewrNu2eia4yhe
	 LF2Ao4bCw+t/w8N6OTd+ih88yXOdBgj+4rOa4SOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0988/1815] powerpc64/bpf: Fix build break for arch_bpf_timed_may_goto
Date: Sat, 12 Sep 2026 08:45:38 +0200
Message-ID: <20260912065712.188218756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit e1e5e682511eda648aa91372542cc8f665ad0bff ]

With CONFIG_PPC_KERNEL_PCREL enabled, calling bpf_check_timed_may_goto()
using a bl instruction results in a link-time failure:

arch/powerpc/net/bpf_timed_may_goto.o: in function `arch_bpf_timed_may_goto':
(.text+0x28): call to `bpf_check_timed_may_goto' lacks nop, can't restore toc

Use CFUNC() macro instead of direct 'bl' to properly annotate the call
to bpf_check_timed_may_goto(). On PCREL builds, CFUNC() expands to
'bl name@notoc', informing the linker that TOC restoration is not
needed, avoiding the "lacks nop, can't restore toc" linker error.

Fixes: b55b6b9ad76c ("powerpc64/bpf: Add powerpc64 JIT support for timed may_goto")
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/f75e5aa911afb984a94c0e85d58b1be5fb428548.1785387718.git.skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_timed_may_goto.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_timed_may_goto.S b/arch/powerpc/net/bpf_timed_may_goto.S
index 6fd8b1c9f4ac8..84ecf6fa7f5dc 100644
--- a/arch/powerpc/net/bpf_timed_may_goto.S
+++ b/arch/powerpc/net/bpf_timed_may_goto.S
@@ -36,7 +36,7 @@ SYM_FUNC_START(arch_bpf_timed_may_goto)
 	 * BPF_REG_FP is r31; BPF_REG_AX is r12 (stack offset in bytes).
 	 */
 	add     r3, r31, r12
-	bl      bpf_check_timed_may_goto
+	bl      CFUNC(bpf_check_timed_may_goto)
 
 	/* Put return value back into AX */
 	mr      r12, r3
-- 
2.53.0



