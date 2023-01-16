Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803CF33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6526C433F0;
	Mon, 16 Jan 2023 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884851;
	bh=wd3vyY6Ur5ZbB0O6nQQrAH5ir0YUw/++J7X4kYLTGFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcNwCHNq8KOfHy3HfyIvMI62YE8zqCzWCfQ5rhsq0yvIoyBgAMLTjMHDnKOVdpqvU
	 /9AKqBP5iltMJWZlzfgRscs4DqrqGsnxm5+m7hebf8V1N3ly9SP5tYmAOHRUcfHA0i
	 zwbmSWgjsU+BL7Syus78D+Sask0NzkvPQ7CusXqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/183] tools/nolibc: restore mips branch ordering in the _start block
Date: Mon, 16 Jan 2023 16:50:59 +0100
Message-Id: <20230116154809.119535980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 184177c3d6e023da934761e198c281344d7dd65b ]

Depending on the compiler used and the optimization options, the sbrk()
test was crashing, both on real hardware (mips-24kc) and in qemu. One
such example is kernel.org toolchain in version 11.3 optimizing at -Os.

Inspecting the sys_brk() call shows the following code:

  0040047c <sys_brk>:
    40047c:       24020fcd        li      v0,4045
    400480:       27bdffe0        addiu   sp,sp,-32
    400484:       0000000c        syscall
    400488:       27bd0020        addiu   sp,sp,32
    40048c:       10e00001        beqz    a3,400494 <sys_brk+0x18>
    400490:       00021023        negu    v0,v0
    400494:       03e00008        jr      ra

It is obviously wrong, the "negu" instruction is placed in beqz's
delayed slot, and worse, there's no nop nor instruction after the
return, so the next function's first instruction (addiu sip,sip,-32)
will also be executed as part of the delayed slot that follows the
return.

This is caused by the ".set noreorder" directive in the _start block,
that applies to the whole program. The compiler emits code without the
delayed slots and relies on the compiler to swap instructions when this
option is not set. Removing the option would require to change the
startup code in a way that wouldn't make it look like the resulting
code, which would not be easy to debug. Instead let's just save the
default ordering before changing it, and restore it at the end of the
_start block. Now the code is correct:

  0040047c <sys_brk>:
    40047c:       24020fcd        li      v0,4045
    400480:       27bdffe0        addiu   sp,sp,-32
    400484:       0000000c        syscall
    400488:       10e00002        beqz    a3,400494 <sys_brk+0x18>
    40048c:       27bd0020        addiu   sp,sp,32
    400490:       00021023        negu    v0,v0
    400494:       03e00008        jr      ra
    400498:       00000000        nop

Fixes: 66b6f755ad45 ("rcutorture: Import a copy of nolibc") #5.0
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-mips.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
index 5fc5b8029bff..7380093ba9e7 100644
--- a/tools/include/nolibc/arch-mips.h
+++ b/tools/include/nolibc/arch-mips.h
@@ -192,6 +192,7 @@ struct sys_stat_struct {
 __asm__ (".section .text\n"
     ".weak __start\n"
     ".set nomips16\n"
+    ".set push\n"
     ".set    noreorder\n"
     ".option pic0\n"
     ".ent __start\n"
@@ -210,6 +211,7 @@ __asm__ (".section .text\n"
     "li $v0, 4001\n"              // NR_exit == 4001
     "syscall\n"
     ".end __start\n"
+    ".set pop\n"
     "");
 
 #endif // _NOLIBC_ARCH_MIPS_H
-- 
2.35.1



