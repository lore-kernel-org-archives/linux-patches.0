Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B55819FA9F;
	Thu,  6 Jun 2024 14:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683416; cv=none; b=n0mRUJaz/S6kh1KZeOrMjB3ZoYow+M3LWGMPW3P00pv7em+FeAi5hDlmSr1Y3UbUa6CNu+8xCRuCxWaw7pLHDm3lNA5uKgJZwS/KsgpG7KJ3mo9ojjNo9fTm86HY4rZDIV/P/dWZEo4r+by6zWLvskgvAPpbqPJ3hslblXh8sck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683416; c=relaxed/simple;
	bh=8veSNe0CVLTdt9rThlzWDljWShHURCkaq3vpUonjbn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0xaUSRvHtLLPdezrVH3t5O0/fpSikuwcOJ7h+zSW2YMe1c+6WBGCZofP+nnv9JaY/EXypl8X9qfdwYy9WHimB8IbqwPM+V78XsavfjyGrIKSg5Pf1zLhpB6I0RNzPBa1Ewdsfjq/nIhZ5ohi6N94ur0Qw5L7nN9YzmQG1HW3e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVg01Agc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVg01Agc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EE7C2BD10;
	Thu,  6 Jun 2024 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683416;
	bh=8veSNe0CVLTdt9rThlzWDljWShHURCkaq3vpUonjbn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVg01Agcr7kuFudSDE6VBkB3SpR69xqV5V7K8wrO2Vl0mQmm8G3ypp797sLVe9PtF
	 vAszSZ69VOYl0ML/xy6mMPY/RGG6Tq53YkIZSauV4S9nHfJ34Tq3lVTomtIyKoB3ZC
	 up+l2K5OWDVGBF17k+MO1DmCNJ/BP3zLFo6LjjAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 359/744] x86/insn: Fix PUSH instruction in x86 instruction decoder opcode map
Date: Thu,  6 Jun 2024 16:00:31 +0200
Message-ID: <20240606131743.993327934@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 59162e0c11d7257cde15f907d19fefe26da66692 ]

The x86 instruction decoder is used not only for decoding kernel
instructions. It is also used by perf uprobes (user space probes) and by
perf tools Intel Processor Trace decoding. Consequently, it needs to
support instructions executed by user space also.

Opcode 0x68 PUSH instruction is currently defined as 64-bit operand size
only i.e. (d64). That was based on Intel SDM Opcode Map. However that is
contradicted by the Instruction Set Reference section for PUSH in the
same manual.

Remove 64-bit operand size only annotation from opcode 0x68 PUSH
instruction.

Example:

  $ cat pushw.s
  .global  _start
  .text
  _start:
          pushw   $0x1234
          mov     $0x1,%eax   # system call number (sys_exit)
          int     $0x80
  $ as -o pushw.o pushw.s
  $ ld -s -o pushw pushw.o
  $ objdump -d pushw | tail -4
  0000000000401000 <.text>:
    401000:       66 68 34 12             pushw  $0x1234
    401004:       b8 01 00 00 00          mov    $0x1,%eax
    401009:       cd 80                   int    $0x80
  $ perf record -e intel_pt//u ./pushw
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.014 MB perf.data ]

 Before:

  $ perf script --insn-trace=disasm
  Warning:
  1 instruction trace errors
           pushw   10349 [000] 10586.869237014:            401000 [unknown] (/home/ahunter/git/misc/rtit-tests/pushw)           pushw $0x1234
           pushw   10349 [000] 10586.869237014:            401006 [unknown] (/home/ahunter/git/misc/rtit-tests/pushw)           addb %al, (%rax)
           pushw   10349 [000] 10586.869237014:            401008 [unknown] (/home/ahunter/git/misc/rtit-tests/pushw)           addb %cl, %ch
           pushw   10349 [000] 10586.869237014:            40100a [unknown] (/home/ahunter/git/misc/rtit-tests/pushw)           addb $0x2e, (%rax)
   instruction trace error type 1 time 10586.869237224 cpu 0 pid 10349 tid 10349 ip 0x40100d code 6: Trace doesn't match instruction

 After:

  $ perf script --insn-trace=disasm
             pushw   10349 [000] 10586.869237014:            401000 [unknown] (./pushw)           pushw $0x1234
             pushw   10349 [000] 10586.869237014:            401004 [unknown] (./pushw)           movl $1, %eax

Fixes: eb13296cfaf6 ("x86: Instruction decoder API")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240502105853.5338-3-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/x86-opcode-map.txt       | 2 +-
 tools/arch/x86/lib/x86-opcode-map.txt | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 5168ee0360b24..940913550ed83 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -148,7 +148,7 @@ AVXcode:
 65: SEG=GS (Prefix)
 66: Operand-Size (Prefix)
 67: Address-Size (Prefix)
-68: PUSH Iz (d64)
+68: PUSH Iz
 69: IMUL Gv,Ev,Iz
 6a: PUSH Ib (d64)
 6b: IMUL Gv,Ev,Ib
diff --git a/tools/arch/x86/lib/x86-opcode-map.txt b/tools/arch/x86/lib/x86-opcode-map.txt
index 5168ee0360b24..940913550ed83 100644
--- a/tools/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/arch/x86/lib/x86-opcode-map.txt
@@ -148,7 +148,7 @@ AVXcode:
 65: SEG=GS (Prefix)
 66: Operand-Size (Prefix)
 67: Address-Size (Prefix)
-68: PUSH Iz (d64)
+68: PUSH Iz
 69: IMUL Gv,Ev,Iz
 6a: PUSH Ib (d64)
 6b: IMUL Gv,Ev,Ib
-- 
2.43.0



