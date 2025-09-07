Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09807315D54;
	Sun,  7 Sep 2025 20:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277380; cv=none; b=cHZBuT7CxXVDTzQOhICUcXPrH2qzLAWRJqUYuWVFCz+/Rubr0xsfrxFmyWT9oq5qm5EjF3hHZtQaZOB5FOOfIk5s4JitNjDeLNCSnIypt0UDlGPjQmmD1BPTKUB57Hj6cVAGaeZs770deqdU7SC99FoyiBzyH7htu+1Jz3WowC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277380; c=relaxed/simple;
	bh=w+BEXfj6iE/lwdyUJH9QKZe5S2IfoD4Mi2Z2pli2Juc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIQghT1l6ztyc0lPxemUbBDhwTZUGlipLtSVkihu2QeUV40CuZtBtzMvozoTNPLLj6F8F3Yk2u1OT5c2iH/X0U0BFsyIL6GKD54jzgJTdWhGgpNb8R5nH5ezAjclFLjoaQc3oUUHiOu+ryg3QU8MPH2XwpH6mESRiD47Bu2DrXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/WOZigH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/WOZigH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9E3C4CEF0;
	Sun,  7 Sep 2025 20:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277378;
	bh=w+BEXfj6iE/lwdyUJH9QKZe5S2IfoD4Mi2Z2pli2Juc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/WOZigH/0i9m+ttlqPYC0JwwKdMkB96WZa1TG6yEMvtvQcC8hd3watwHGe+bn6ro
	 QvTe8HP2oXxn5KhkuLL13wmtXqmGmNsKHxXZ/m9eZZGch6v2yoGrpmNtRIJWloNCt8
	 dJ2P8OqRZnr3RCVW5FugygOvtJMEvTnxNPKG3Xt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 170/175] riscv: use lw when reading int cpu in new_vmalloc_check
Date: Sun,  7 Sep 2025 21:59:25 +0200
Message-ID: <20250907195618.881724988@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@ventanamicro.com>

commit e108c8a94f3f958c877f6ec7a6052a893ae4aa98 upstream.

REG_L is wrong, because thread_info.cpu is 32-bit, not xlen-bit wide.
The struct currently has a hole after cpu, so little endian accesses
seemed fine.

Fixes: 503638e0babf ("riscv: Stop emitting preventive sfence.vma for new vmalloc mappings")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Link: https://lore.kernel.org/r/20250725165410.2896641-4-rkrcmar@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -46,7 +46,7 @@
 	 * a0 = &new_vmalloc[BIT_WORD(cpu)]
 	 * a1 = BIT_MASK(cpu)
 	 */
-	REG_L 	a2, TASK_TI_CPU(tp)
+	lw	a2, TASK_TI_CPU(tp)
 	/*
 	 * Compute the new_vmalloc element position:
 	 * (cpu / 64) * 8 = (cpu >> 6) << 3


