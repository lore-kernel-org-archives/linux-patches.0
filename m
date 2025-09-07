Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83BC315D54;
	Sun,  7 Sep 2025 20:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277381; cv=none; b=iGL8QDCDTKSuioCkT5Q6msQX8LZ8d8rx7igZJ36nDmA0vje4F4FxYQAA8r/6zAopAJlPL8t5fdVTanPMMwIdRc9lR0fGQRAmG7NTPGO8yathUI1WBODPBHdWy6bEdE7q9qE0UoCYaXZyas2mx64wS9XrjUtW66Xy6lmBn77jIhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277381; c=relaxed/simple;
	bh=K3mzHxUbNSyN48gkp90NTIHnvRm6jH7/WEjqw4eb0Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fzgHgUbgC1kNIBC1vnOKKXqtt3BFZu2u+qHIbF11zi/neEbmsPheDEj1x1nX8MjPjqLL24nDp88vZj3c9XFFnkw82jPpdJLyZvSlL0S/SBKYZka5CtGb6eIzYu+aFZLLvv+pMAGUzQY5Ah/MHidlYmQXQSaaH6QO8mbWcGATbPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7+iFaE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7+iFaE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50754C4CEF0;
	Sun,  7 Sep 2025 20:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277381;
	bh=K3mzHxUbNSyN48gkp90NTIHnvRm6jH7/WEjqw4eb0Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7+iFaE6vlgra04vUp9nmOVpacfR4dvFv+s8cGlL/+BYSCS4x8ywtjm5VgV6BCsE5
	 4Ble9LhBRb59wVoLq2Uo+M0W7EoBnF9khR7b95iCugWzKTeEGGEWhJrvPep0hVn29Z
	 PNZRBSyiVNlbzG7orKxWFfujx71oacygBZ/n4Vgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 171/175] riscv: use lw when reading int cpu in asm_per_cpu
Date: Sun,  7 Sep 2025 21:59:26 +0200
Message-ID: <20250907195618.905516110@linuxfoundation.org>
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

commit f4ea67a722e8c9e1fb8109adebb9fb881ff0793a upstream.

REG_L is wrong, because thread_info.cpu is 32-bit, not xlen-bit wide.
The struct currently has a hole after cpu, so little endian accesses
seemed fine.

Fixes: be97d0db5f44 ("riscv: VMAP_STACK overflow detection thread-safe")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Link: https://lore.kernel.org/r/20250725165410.2896641-5-rkrcmar@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/asm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -90,7 +90,7 @@
 #endif
 
 .macro asm_per_cpu dst sym tmp
-	REG_L \tmp, TASK_TI_CPU_NUM(tp)
+	lw    \tmp, TASK_TI_CPU_NUM(tp)
 	slli  \tmp, \tmp, PER_CPU_OFFSET_SHIFT
 	la    \dst, __per_cpu_offset
 	add   \dst, \dst, \tmp


