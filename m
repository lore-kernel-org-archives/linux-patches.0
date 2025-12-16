Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763D4357730;
	Tue, 16 Dec 2025 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886583; cv=none; b=l36j4NvHu2kmi5bz2WTp5RBBXDUMGgXNb3SKj/l+gC4VqLZdGQ+1uiFKAU+8fyqlzX8RS19feV1ou9YxGtMRZsgIaU3ykg8lU0EqNzZfd3v/oST4XdBecm/mRkxtwU2+TPLvoo0rx6Enk4ki+YR6zS4oVdsJL5WoVUSpgQ/AVIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886583; c=relaxed/simple;
	bh=8m/Lp7WMArd8SqoUNpBiw/dX7Wnq4E9gWam1GlGk+u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yo93RcqywTiE2d6qk6aY47uv1NleDftFGmGPYZ6TRmVihM3QZdKhhzk4zIaTos0m0FP/7AS/wxzl5O1NukE4ppg5stROPUl1hZG+sWcNzmYgcVpRP1bGtLq7c5edOlXR1cxllHumhbJGu1NSYR0QwT8h56twQ+3i9w+gESNs/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpCa3qOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpCa3qOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF34C19422;
	Tue, 16 Dec 2025 12:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886583;
	bh=8m/Lp7WMArd8SqoUNpBiw/dX7Wnq4E9gWam1GlGk+u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpCa3qOm4m9Yp5xOI9voCilcyydFRtly/+Gy2wzygZBSBMXQxDQfcHRukmww8zE9B
	 i905oBtto8pYAtvXUb9+P4PQx8yNEdcRRTGxOabcz+Ghcm+FWTidu7Fj9Rl51V1jlj
	 7in2advQKu+d0QR6e3e6DKoDrKUT9GrbKo4n80WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Liyuan Pang <pangliyuan1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 479/507] ARM: 9464/1: fix input-only operand modification in load_unaligned_zeropad()
Date: Tue, 16 Dec 2025 12:15:20 +0100
Message-ID: <20251216111402.796220420@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liyuan Pang <pangliyuan1@huawei.com>

[ Upstream commit edb924a7211c9aa7a4a415e03caee4d875e46b8e ]

In the inline assembly inside load_unaligned_zeropad(), the "addr" is
constrained as input-only operand. The compiler assumes that on exit
from the asm statement these operands contain the same values as they
had before executing the statement, but when kernel page fault happened, the assembly fixup code "bic %2 %2, #0x3" modify the value of "addr", which may lead to an unexpected behavior.

Use a temporary variable "tmp" to handle it, instead of modifying the
input-only operand, just like what arm64's load_unaligned_zeropad()
does.

Fixes: b9a50f74905a ("ARM: 7450/1: dcache: select DCACHE_WORD_ACCESS for little-endian ARMv6+ CPUs")
Co-developed-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Liyuan Pang <pangliyuan1@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/word-at-a-time.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/word-at-a-time.h b/arch/arm/include/asm/word-at-a-time.h
index f9a3897b06e7f..5023f98d8293d 100644
--- a/arch/arm/include/asm/word-at-a-time.h
+++ b/arch/arm/include/asm/word-at-a-time.h
@@ -67,7 +67,7 @@ static inline unsigned long find_zero(unsigned long mask)
  */
 static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
-	unsigned long ret, offset;
+	unsigned long ret, tmp;
 
 	/* Load word from unaligned pointer addr */
 	asm(
@@ -75,9 +75,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"2:\n"
 	"	.pushsection .text.fixup,\"ax\"\n"
 	"	.align 2\n"
-	"3:	and	%1, %2, #0x3\n"
-	"	bic	%2, %2, #0x3\n"
-	"	ldr	%0, [%2]\n"
+	"3:	bic	%1, %2, #0x3\n"
+	"	ldr	%0, [%1]\n"
+	"	and	%1, %2, #0x3\n"
 	"	lsl	%1, %1, #0x3\n"
 #ifndef __ARMEB__
 	"	lsr	%0, %0, %1\n"
@@ -90,7 +90,7 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"	.align	3\n"
 	"	.long	1b, 3b\n"
 	"	.popsection"
-	: "=&r" (ret), "=&r" (offset)
+	: "=&r" (ret), "=&r" (tmp)
 	: "r" (addr), "Qo" (*(unsigned long *)addr));
 
 	return ret;
-- 
2.51.0



