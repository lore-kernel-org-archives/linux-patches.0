Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4190D248BD0;
	Wed, 15 Jan 2025 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938599; cv=none; b=l9oEv9ICoh7fjYMXyPq5pm1lGkYhK8OzBdzyiKCQfXvVV96Db9s4pj8h/pnLiHHEY+g4JL/oZrY9Yw5aMAI9SwpeSBdAgUzheGoroLTR+LVcwh4olFO6Zl67DCHxn4NBUfasDlmQxE6gXtuQddvYZqI9kaezmJBxIufxjtPGvBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938599; c=relaxed/simple;
	bh=scpgGz+09uSQMiEd9r9VZCsZRwb+2CDeYsdO2FChtmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJFRWDqVl7lAcoTxIctTAE7HDtSnthQfvRoWVypoLDu2fBllM++B8TwAHrKry1JxCqrMNG9uqovbOz8v0sKDI+Dfl8n2b2+SrVRrj6hO1iJ2evfsf0cTBCm/ZvEVBBYLNCtqeZBpkelCVFioRJslqLmnnKYIYljX1hJR79fn120=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU3h5M+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU3h5M+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC69BC4CEE1;
	Wed, 15 Jan 2025 10:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938599;
	bh=scpgGz+09uSQMiEd9r9VZCsZRwb+2CDeYsdO2FChtmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dU3h5M+aMnLyDSwKum55lmJgVJk3panxy6svOi1dJusdUWUeg34wuv7Xj6SRe+TQ9
	 kVqHf6gx9oDidXwQMa42jWbTtk2MdqELofLoRSuUdpE0cN7vjUYnW/8zMHubMf4YxE
	 VGmYA311VKXgk7ALXmpo8HxJd1s2ULOXaoCu1VE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 038/129] riscv: Fix early ftrace nop patching
Date: Wed, 15 Jan 2025 11:36:53 +0100
Message-ID: <20250115103555.891217695@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit 6ca445d8af0ed5950ebf899415fd6bfcd7d9d7a3 upstream.

Commit c97bf629963e ("riscv: Fix text patching when IPI are used")
converted ftrace_make_nop() to use patch_insn_write() which does not
emit any icache flush relying entirely on __ftrace_modify_code() to do
that.

But we missed that ftrace_make_nop() was called very early directly when
converting mcount calls into nops (actually on riscv it converts 2B nops
emitted by the compiler into 4B nops).

This caused crashes on multiple HW as reported by Conor and Björn since
the booting core could have half-patched instructions in its icache
which would trigger an illegal instruction trap: fix this by emitting a
local flush icache when early patching nops.

Fixes: c97bf629963e ("riscv: Fix text patching when IPI are used")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Tested-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20240523115134.70380-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/cacheflush.h |    6 ++++++
 arch/riscv/kernel/ftrace.c          |    3 +++
 2 files changed, 9 insertions(+)

--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -13,6 +13,12 @@ static inline void local_flush_icache_al
 	asm volatile ("fence.i" ::: "memory");
 }
 
+static inline void local_flush_icache_range(unsigned long start,
+					    unsigned long end)
+{
+	local_flush_icache_all();
+}
+
 #define PG_dcache_clean PG_arch_1
 
 static inline void flush_dcache_folio(struct folio *folio)
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -120,6 +120,9 @@ int ftrace_init_nop(struct module *mod,
 	out = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
 	mutex_unlock(&text_mutex);
 
+	if (!mod)
+		local_flush_icache_range(rec->ip, rec->ip + MCOUNT_INSN_SIZE);
+
 	return out;
 }
 


