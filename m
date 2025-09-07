Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5F2D528;
	Sun,  7 Sep 2025 20:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276807; cv=none; b=OxlGbZt6ygqtwmEHRDU+bUIdBJj6DxpBwLeLjcotU/+7y60S890qQq0ddBWn8CuL7Z3JJHO4SRX9lwHVoe24J1lsoPrcyLxbFoqvWzQS1xcENOEQ2e0IzsgPg6040x7Tw0m/GhIpWwfTKcf5xX16SDVFXxB3jA45BzdaCGXTrjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276807; c=relaxed/simple;
	bh=4XNFb+F+DYZbmh8jo5KM5r08xK7+m41NK5QID3DqJcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAjKv/7cRSwkWDMidlhsaiug8y0mUYdg+6vhBj5lpTKLu7CHDyXoSje/Qj1xMhml1luWDQaNhBhbTAqrV3Mi47Jg37hGiRQSe6DKmEYewxa6jf2XoFQzMx3k/CieRHwxar5s2F2wBgskTWUoaSEpWFCqc8toNavHNCd3CJ5w5bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBHSVEdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBHSVEdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B46C4CEF0;
	Sun,  7 Sep 2025 20:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276807;
	bh=4XNFb+F+DYZbmh8jo5KM5r08xK7+m41NK5QID3DqJcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBHSVEdvezsNdHqHj1pJfSL0+mYviEJxgs/5jLVNXbcvgnpIimQe0kh8o8D7k3iB9
	 aAFxen/jui0lv/9N89mEIYIp8srqtYkfcKrL7XyHFuGfbS4XfWu4eVBNguaU5zwmrA
	 ccDSFmNWxd7VOtgoM63uSzJOP1o00JHJIc8y2n1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.6 116/121] riscv: use lw when reading int cpu in asm_per_cpu
Date: Sun,  7 Sep 2025 21:59:12 +0200
Message-ID: <20250907195612.824246310@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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


