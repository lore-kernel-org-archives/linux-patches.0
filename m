Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C884F30F2;
	Tue, 13 Oct 2026 11:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892702; cv=none; b=iDyf1nmGFBqUBUxtG4/X2JB/mv1cHFbTK9a4QBfkN7ZamNjPAOhPJwWyfto2/cvAAegaEZXhD60QgbNiAJ50WqLjqAwCHZsFzgDGrhPia/tFWPMHh71yzTpZ3dzX2N96HlrFtoa18SE0Mj1Q9zIxDqKzhOeCsIxp06rK9vT8Zhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892702; c=relaxed/simple;
	bh=cWui0Jz8hbuBE7+v0va1ZrZgdX9aKMFvOduSHx55D2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilvBmMl8nR7IrJjo7g0OV6zTO6gtYRavrXKWEGNnKpodmlMDvjxHUyqGn83a57tqmoDKX8mBVl/ozMO7uMQmkv0w4cEDaE39ehk1GZ8LZ7cV0ArnTxos0nTR19/MzXmEU11RXfYZ83xyKCgaloaDq/E79E799zrsJ5S+015KHzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdGZgHl7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdGZgHl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D911F00893;
	Tue, 13 Oct 2026 11:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892701;
	bh=uaFv05PUDj19youPSsMsiuSGxTgQOd5QIuRU3kRxEgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdGZgHl7B7wAY6KTxCssinL2CPAYJhc5TkjxYjyNEQ9ApbPPiGzFcHw0JaqQy10wG
	 mysP4wVflQY4HP1MaiisIp9PgVbzi+rw+aA752+v2mT8UZRzS9q1u3y1yYRJbqqdch
	 uN35zVfVBWj3UjjPmyr5Fg59y9RmXwnRTZWeVKKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 259/281] riscv: ptrace: Zero-initialize regset buffers before copyin
Date: Tue, 13 Oct 2026 13:39:35 +0200
Message-ID: <20261013112901.428055072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit 59052a88ba5fe4a7bb34b3a0a42aa5d453d3bb97 ]

user_regset_copyin() only copies `count` bytes, so a PTRACE_SETREGSET
request with a short iov_len leaves the rest of the stack buffer
uninitialized. In riscv_vr_set() that garbage is validated and copied
into the target's vstate, and in riscv_cfi_set() it can be stored as
the target's shadow stack pointer. Zero both buffers, as the get path
already does.

Fixes: 9300f0043974 ("RISC-V: Add ptrace support for vectors")
Fixes: 2af7c9cf021c ("riscv/ptrace: expose riscv CFI status and state via ptrace and in core files")
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://patch.msgid.link/20260826115711.86861-1-min_halo@163.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/ptrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 566856e42f658..a0055743d3ba5 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -230,6 +230,7 @@ static int riscv_vr_set(struct task_struct *target,
 		return -ENODATA;
 
 	/* Copy rest of the vstate except datap */
+	memset(&ptrace_vstate, 0, sizeof(ptrace_vstate));
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &ptrace_vstate, 0,
 				 sizeof(struct __riscv_v_regset_state));
 	if (unlikely(ret))
@@ -345,6 +346,7 @@ static int riscv_cfi_set(struct task_struct *target,
 
 	regs = task_pt_regs(target);
 
+	memset(&user_cfi, 0, sizeof(user_cfi));
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &user_cfi, 0, -1);
 	if (ret)
 		return ret;
-- 
2.53.0



