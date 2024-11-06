Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036731DF976;
	Wed,  6 Nov 2024 13:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898912; cv=none; b=ZI4yDZhccl8Ixs1t5uLPG4JN8LdSwhGTvINiHyQgwy/DonENdpPPdX9fvYD2uORq08LCwPbU9/sJAWMQ9vAIpR3rLT8zc3oktFrhvxBw6XsW8rkEzKxwCZIS/QvntEi8577gbBZkGPJf7Af0qLxKcpP2LF/3jLA7OdofmwPtt78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898912; c=relaxed/simple;
	bh=CV94y0FRGqZJkt2u8E5vzGv+pQYjX14ZdzDSVf3CawY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MP6nBlqVN+AhpTRYyWvzVSwR/jvxysmgvDFn3FHJB3btb7E605h7APqcLVYdeUtFDaPf2Fpsph6M55irj1syGaO8rUc53Yv+Ypzq6CaMpU69U6DugTxMdGrO6AwvD12Y2fYgjfqK/AGY6uNtvewvP4esYSG2U3613dwNVvfKoc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIGm0nfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIGm0nfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C46C4CECD;
	Wed,  6 Nov 2024 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898911;
	bh=CV94y0FRGqZJkt2u8E5vzGv+pQYjX14ZdzDSVf3CawY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIGm0nfo+xOHEHGuwKqkMQewplAp3uIyKvEEZKKK0oi330aa0201Tdj76bBXqK3qX
	 28XIV+PlJauiiKzPxNBiRj4XhGVgf7UmpgTdFEF2PkCOwASYl3gVwKL0Xbc8wSn2E2
	 xxXsKRxCrp2vE8KTDs6i20rBn9agc9pltgFiYql8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	junhua huang <huang.junhua@zte.com.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 398/462] arm64:uprobe fix the uprobe SWBP_INSN in big-endian
Date: Wed,  6 Nov 2024 13:04:51 +0100
Message-ID: <20241106120341.353914298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: junhua huang <huang.junhua@zte.com.cn>

[ Upstream commit 60f07e22a73d318cddaafa5ef41a10476807cc07 ]

We use uprobe in aarch64_be, which we found the tracee task would exit
due to SIGILL when we enable the uprobe trace.
We can see the replace inst from uprobe is not correct in aarch big-endian.
As in Armv8-A, instruction fetches are always treated as little-endian,
we should treat the UPROBE_SWBP_INSN as little-endian。

The test case is as following。
bash-4.4# ./mqueue_test_aarchbe 1 1 2 1 10 > /dev/null &
bash-4.4# cd /sys/kernel/debug/tracing/
bash-4.4# echo 'p:test /mqueue_test_aarchbe:0xc30 %x0 %x1' > uprobe_events
bash-4.4# echo 1 > events/uprobes/enable
bash-4.4#
bash-4.4# ps
  PID TTY          TIME CMD
  140 ?        00:00:01 bash
  237 ?        00:00:00 ps
[1]+  Illegal instruction     ./mqueue_test_aarchbe 1 1 2 1 100 > /dev/null

which we debug use gdb as following:

bash-4.4# gdb attach 155
(gdb) disassemble send
Dump of assembler code for function send:
   0x0000000000400c30 <+0>:     .inst   0xa00020d4 ; undefined
   0x0000000000400c34 <+4>:     mov     x29, sp
   0x0000000000400c38 <+8>:     str     w0, [sp, #28]
   0x0000000000400c3c <+12>:    strb    w1, [sp, #27]
   0x0000000000400c40 <+16>:    str     xzr, [sp, #40]
   0x0000000000400c44 <+20>:    str     xzr, [sp, #48]
   0x0000000000400c48 <+24>:    add     x0, sp, #0x1b
   0x0000000000400c4c <+28>:    mov     w3, #0x0                 // #0
   0x0000000000400c50 <+32>:    mov     x2, #0x1                 // #1
   0x0000000000400c54 <+36>:    mov     x1, x0
   0x0000000000400c58 <+40>:    ldr     w0, [sp, #28]
   0x0000000000400c5c <+44>:    bl      0x405e10 <mq_send>
   0x0000000000400c60 <+48>:    str     w0, [sp, #60]
   0x0000000000400c64 <+52>:    ldr     w0, [sp, #60]
   0x0000000000400c68 <+56>:    ldp     x29, x30, [sp], #64
   0x0000000000400c6c <+60>:    ret
End of assembler dump.
(gdb) info b
No breakpoints or watchpoints.
(gdb) c
Continuing.

Program received signal SIGILL, Illegal instruction.
0x0000000000400c30 in send ()
(gdb) x/10x 0x400c30
0x400c30 <send>:    0xd42000a0   0xfd030091      0xe01f00b9      0xe16f0039
0x400c40 <send+16>: 0xff1700f9   0xff1b00f9      0xe06f0091      0x03008052
0x400c50 <send+32>: 0x220080d2   0xe10300aa
(gdb) disassemble 0x400c30
Dump of assembler code for function send:
=> 0x0000000000400c30 <+0>:     .inst   0xa00020d4 ; undefined
   0x0000000000400c34 <+4>:     mov     x29, sp
   0x0000000000400c38 <+8>:     str     w0, [sp, #28]
   0x0000000000400c3c <+12>:    strb    w1, [sp, #27]
   0x0000000000400c40 <+16>:    str     xzr, [sp, #40]

Signed-off-by: junhua huang <huang.junhua@zte.com.cn>
Link: https://lore.kernel.org/r/202212021511106844809@zte.com.cn
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: 13f8f1e05f1d ("arm64: probes: Fix uprobes for big-endian kernels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/uprobes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/uprobes.h b/arch/arm64/include/asm/uprobes.h
index 315eef654e39a..ba4bff5ca6749 100644
--- a/arch/arm64/include/asm/uprobes.h
+++ b/arch/arm64/include/asm/uprobes.h
@@ -12,7 +12,7 @@
 
 #define MAX_UINSN_BYTES		AARCH64_INSN_SIZE
 
-#define UPROBE_SWBP_INSN	BRK64_OPCODE_UPROBES
+#define UPROBE_SWBP_INSN	cpu_to_le32(BRK64_OPCODE_UPROBES)
 #define UPROBE_SWBP_INSN_SIZE	AARCH64_INSN_SIZE
 #define UPROBE_XOL_SLOT_BYTES	MAX_UINSN_BYTES
 
-- 
2.43.0



