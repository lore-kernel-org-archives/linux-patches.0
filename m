Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BC716086C;
	Mon, 27 May 2024 19:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838578; cv=none; b=jh1OLA6gnd6J6aaHU/DSq0kLayNt0KYwCyXDeVRMOjIX/ri6R4M7hALoM0VMckTZRXR2ml69n7ng2FGtt+FHrAkKLvaEE1Xy3N/tK6dUEItrKWgiAQmkAqdAxax9uAL57S3LibCoApD4CjSi7rhgI8UeKObzl7aK3MsXBaQpD9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838578; c=relaxed/simple;
	bh=y0lvKISrd1nKPE27OZZhK6MLYzyOigabZPx5WAnCxjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izkDWwqtkXL9c1xbKc33j9/vSAkxYh06pOZ1dEPoe+hynA9tNVNxx91dyVwu+pcJ/JiYXpMwOqtdwYv7rahuTDj61CWzny0iawAmR5q2IfcoRBAtE67pEHQCdu0Vp74Ltjcd0UiKLyjY783S6cYZGGT94zxo6AVKLo5Mo63EfYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deJu6DRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deJu6DRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A258C32786;
	Mon, 27 May 2024 19:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838578;
	bh=y0lvKISrd1nKPE27OZZhK6MLYzyOigabZPx5WAnCxjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deJu6DRTwi9s8jV7r73zgpWWHlymZlUNQVLVOExOvlGGP9vs/zb/i/EByOCKM2d1d
	 ZCKEhF+LUtz66ptzsQ2IkZ9QwRc//ZSDgnqgJ0q/BG5zNJKfR+hdclcRAFeZbi3J3h
	 Ux9CB2bmWnogk7U+AXCqkkbfE7n3MSSjBBBUZoLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 448/493] x86/insn: Fix PUSH instruction in x86 instruction decoder opcode map
Date: Mon, 27 May 2024 20:57:30 +0200
Message-ID: <20240527185644.891222210@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



