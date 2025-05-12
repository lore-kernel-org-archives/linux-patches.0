Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A87296FA1;
	Mon, 12 May 2025 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071940; cv=none; b=VX+QzGppr8qs/bQ6N35iG0aBDp8G8mUCsb61i8B2gct5RYOB6xjg3Bj3MVD6ZdNSTLZsSm4idpn5/0Pf7pvHhVkq+dDbVSkfm/g2qkNkfPTVlrXwaIH6WwyQfFD8E+y8Zo3RCRv7xGrPjztVWBJG2VeJs61UvMc6+CXsyNP5CfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071940; c=relaxed/simple;
	bh=pqmYyzFPrMqkhIZ87DR8WfauUQ2CEv5hrJdmld/+G94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bc9tb2y5DhwcY+EQrhJ5PYqrFSu5uRo7uGXhmO5CdZPsTsmsGowcTIcLjCBjRmlOc9rpI7x61pYmkr1tS6B4Dnk/DFZh4Bug80onOMPWRG6MF119OlOqC4uHSPU3D7cjK5FsLEREAfQh+CxmdHLWY0THKdCUUVs4CIB5YOHpWqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9J+3k4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9J+3k4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05487C4CEE9;
	Mon, 12 May 2025 17:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071940;
	bh=pqmYyzFPrMqkhIZ87DR8WfauUQ2CEv5hrJdmld/+G94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9J+3k4VTAXaJCpGvuUzJekk/L9nl4DR5AvN+Z6lKuCKVWaByMMnrp0sBQxwzqUDV
	 Qckd5KjRdNSKuUvPFB3nhXD8AGBr/dpzWr+IGpMCnhwN5lvzEF8rGzCbpXg1yxuUon
	 JVVns0i+8+qXtuPl/7OSZTu6ZNpmtTZ9WoeH/f4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.14 084/197] riscv: Fix kernel crash due to PR_SET_TAGGED_ADDR_CTRL
Date: Mon, 12 May 2025 19:38:54 +0200
Message-ID: <20250512172047.792990126@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit ae08d55807c099357c047dba17624b09414635dd upstream.

When userspace does PR_SET_TAGGED_ADDR_CTRL, but Supm extension is not
available, the kernel crashes:

Oops - illegal instruction [#1]
    [snip]
epc : set_tagged_addr_ctrl+0x112/0x15a
 ra : set_tagged_addr_ctrl+0x74/0x15a
epc : ffffffff80011ace ra : ffffffff80011a30 sp : ffffffc60039be10
    [snip]
status: 0000000200000120 badaddr: 0000000010a79073 cause: 0000000000000002
    set_tagged_addr_ctrl+0x112/0x15a
    __riscv_sys_prctl+0x352/0x73c
    do_trap_ecall_u+0x17c/0x20c
    andle_exception+0x150/0x15c

Fix it by checking if Supm is available.

Fixes: 09d6775f503b ("riscv: Add support for userspace pointer masking")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20250504101920.3393053-1-namcao@linutronix.de
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/process.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 7c244de77180..3db2c0c07acd 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -275,6 +275,9 @@ long set_tagged_addr_ctrl(struct task_struct *task, unsigned long arg)
 	unsigned long pmm;
 	u8 pmlen;
 
+	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_SUPM))
+		return -EINVAL;
+
 	if (is_compat_thread(ti))
 		return -EINVAL;
 
-- 
2.49.0



