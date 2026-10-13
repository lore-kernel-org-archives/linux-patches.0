Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EC74E73C0;
	Tue, 13 Oct 2026 11:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892247; cv=none; b=Dh1S3wC+EAjyiUk7DjtrKo2NwFPQyPSGRIucqS5cQPjm59CbHU4zqTu1m1sdBLlYwGi9wB+oRIVAYpqCQQHJa1AshYv+7smUx/MVTOc7wd6Z1HGShE2d9WEGVQODliV8NOUpjDBeJXcGsYhYDzQlaw0nq3hst6LnkSRQ0YplFY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892247; c=relaxed/simple;
	bh=cbX8B36mnUJ75Lrp/l6p4IlXJydC/cwqnJ/PFD0h7A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhyJa8AadihvAHu6JSLDKEwSMkkT3pioqpPly+bqMTJZekD2aoaQ+t/sZtYjmWmazYc8VA23DOWy8x7TiAOJpdbn5goPgiC5iAYYiyWdJz0tT+URSU+nGommFJ/lyy9E0LhTjxMox/JwQABcBpf7WbOI7yzbrKaFYtUxMfbgrx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVAOeDUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVAOeDUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481A51F000FF;
	Tue, 13 Oct 2026 11:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892245;
	bh=OokFJdJxBXl1E7LtmM2s8xOKm/6CRNmNXLLvzogYKxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVAOeDUCPKhdvZnkM3t7plNXa6/+pY9F4k2TVSA8Mo8GFqlri+TzXzaYutlM8B3LT
	 zKuP1OxDnbU8IdwwAZXzs5taRlmE+Q+9WdladPlzDnbszLmnlsnmqgz+JKbSKDqZN8
	 OBJ+d6qghBU5G564qUG/BFNPN6fkS6FhPi5SxTlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 108/281] riscv: fix load_unaligned_zeropad() fixup for RV32
Date: Tue, 13 Oct 2026 13:37:04 +0200
Message-ID: <20261013112857.764690653@linuxfoundation.org>
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
 


