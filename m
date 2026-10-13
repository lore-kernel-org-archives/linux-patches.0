Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EC33A1E81;
	Tue, 13 Oct 2026 12:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893059; cv=none; b=OvymVYDKYIKogrCL88JezXBZyLj/mXuCVxmSunEBpNRQUFi+LH7S3e/wUe5veunPgvHfmRDHbMPuazXRX746tgf0Nu3p5hFgT8VeDE5BnB5/8L5R5D77u7rya35cy/8bPbfi4iA0cU0sYa7sWAoVyObyFqtlYk3W4ijxX0UdTwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893059; c=relaxed/simple;
	bh=JbK3rhz4MhN0nlpPpln/cgcr6/0LnaWldYXBKUjtz9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToSb5uf4I4sn/QGuIWidxvCCp/+6zvWLhhoKQP002EZ9t7z8v9XaJ2Vj1tnlN50ZYHbPfGH07N4NHbDDtCB+uJ3zJA+2IWIFVrP79wlxQrByZTMPyTWawxICVc0NblHjfFk+E3ehZOwX3Q/QsB5vhKhIyP5CtBPmtHo4evgPBZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzCM1Nmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzCM1Nmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E41C1F000FF;
	Tue, 13 Oct 2026 12:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893058;
	bh=QUHDoheMp2AHVyzpZUG8jGH+3Lcf40oXdbxGcUbfzao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzCM1NmmreL7W3y3U6NNhPWxB4JQBHcta4KwQwnDEQ4lCOxdYOOMn7mp8bRPA0R/s
	 HQgXjygnIrS0IXAdAYsCwTuDppnsuCXMLCUpgPn1fn86fG217SD+wiPAi2ebsAXFoa
	 QykFGt7NuiuvD0HdiRZIVOm6D509mLkPyGmDTM6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 098/621] riscv: fix load_unaligned_zeropad() fixup for RV32
Date: Tue, 13 Oct 2026 13:31:33 +0200
Message-ID: <20261013112923.176109438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit d4f25b097e46d82718bb737d4540c99b7ab0a408 upstream.

The fixup for load_unaligned_zeropad() runs when REG_L crosses into an
unmapped page. REG_L is lw on RV32 and ld on RV64, but the fixup assumes
an 8-byte load: it rounds the address down to 8 bytes and derives the
shift from three address bits.

On RV32, a load starting in the last three bytes of a mapped page selects
the word four bytes earlier and shifts it by 40, 48, or 56 bits, more than
the register width. The caller gets earlier bytes instead of the string
tail followed by zeroes. This affects RV32 MMU kernels built with
RISCV_EFFICIENT_UNALIGNED_ACCESS=y, which selects DCACHE_WORD_ACCESS
and lets dcache name hashing and comparison and strscpy() use this
path.

Derive the alignment and offset masks from sizeof(data) instead of a fixed
8. This makes RV32 use the correct source word. RV64 code is unchanged: the
complete extable.o is byte-for-byte identical before and after.

Fixes: d0fdc20b0429 ("riscv: select DCACHE_WORD_ACCESS for efficient unaligned access HW")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260907190750.26303-1-kmehltretter@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/extable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/extable.c
+++ b/arch/riscv/mm/extable.c
@@ -68,8 +68,8 @@ ex_handler_load_unaligned_zeropad(const
 
 	addr = regs_get_gpr(regs, reg_addr * sizeof(unsigned long));
 
-	offset = addr & 0x7UL;
-	addr &= ~0x7UL;
+	offset = addr & (sizeof(data) - 1);
+	addr &= ~(sizeof(data) - 1);
 
 	data = *(unsigned long *)addr >> (offset * 8);
 


