Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAC17E107;
	Sun,  7 Sep 2025 20:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277958; cv=none; b=irE2Bz37vbETcA6XANJF90kmjXZFJu6vrKUebifrUypZLs4B99DjMnWUAf801BprjUKMFQucKu/5qjZpziyrMvYi1MtyBbasHHcQgrlwF3lDxWy0cqiXaEVfmeiyxMuX441T370v4CZM5ayC4sphLvZVrrsAkzpRURDYYHnHEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277958; c=relaxed/simple;
	bh=5vMZl055YmwvsTr5oiWq0lAj6M1vACC+Z6dISMMBSbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTiilVYiDaqAmhJv+URBlBsFOYa8lYOCD39ZbJtvWpDJknozpFtdxsx36Gu8R/zvyTEebGZFotvMe0OJemDmsdYUV8wDty9Fjl/UwKRUIC9AxOXOtG8hSFDNQT0NHx7zxrarX1YjKyPhn4oRh+84doaJrnZ7f9xjDyeG0cSSBmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybes/CzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybes/CzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D019C4CEF8;
	Sun,  7 Sep 2025 20:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277957;
	bh=5vMZl055YmwvsTr5oiWq0lAj6M1vACC+Z6dISMMBSbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybes/CzYDhM356LgYG5ogqHSqIwjg91n5ivK3gOSwxU4nBIlOPbSzXem00kmTyXNk
	 ybXwl6tEC9+EhuBcProRBbsnREMyMCdAgqaCaKbWfPtspBiu7hGaFjSODT2NO08CY3
	 wK/LBastCDsqiRULUBl/4VdDanH/fWbdCSfWVhWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 177/183] riscv: use lw when reading int cpu in asm_per_cpu
Date: Sun,  7 Sep 2025 22:00:04 +0200
Message-ID: <20250907195620.030181486@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -91,7 +91,7 @@
 #endif
 
 .macro asm_per_cpu dst sym tmp
-	REG_L \tmp, TASK_TI_CPU_NUM(tp)
+	lw    \tmp, TASK_TI_CPU_NUM(tp)
 	slli  \tmp, \tmp, PER_CPU_OFFSET_SHIFT
 	la    \dst, __per_cpu_offset
 	add   \dst, \dst, \tmp


