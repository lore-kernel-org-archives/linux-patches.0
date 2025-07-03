Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A32DE6F9;
	Thu,  3 Jul 2025 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555152; cv=none; b=GYEWMk+Tq/j7W6YlFxuX5dgZdvfhDvmDVxHVzbV3Getl1kwWweNeoCeiA1ZEoa6uryblYJxXI/fVze23SOCUHsXxDvxFQiEDO61Ywn3x4qy5i9/zZ/UjdZFX7xOq4+2FB+YkElIXsCRk99CKqZK3zGgnuaSbNU9wiIQXYOx8PLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555152; c=relaxed/simple;
	bh=7LAX9YAE6i6sG3W8Qzp5WPRNxeirvyUcjJjNDxXikvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xxj5HdhSEI963hRvRtcYrsZCdfWTN1wlpOo/wZlLC5UHftJVPkN+REz6PLDzUibsX67xAKTIdkyEWRWduzCYKRSAogNSV6Wcz6tMi4JSdw8TXm3wjyI4SikZGcAdOMZrLH57M6K7yvYoobYtC75rTg+ndP9hDQkZq43Z8ayqrAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3kAMNz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3kAMNz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2255FC4CEE3;
	Thu,  3 Jul 2025 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555152;
	bh=7LAX9YAE6i6sG3W8Qzp5WPRNxeirvyUcjJjNDxXikvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3kAMNz/CQ41gpIFyhccgwVC/qq2ErvORKNBp0BAbYQjvjGnIK1TaQrtgQWBjLj93
	 NM7j9L8hYY9jblBdJ6EbiFb3XKiPvEcKRjUHG7tId8dcYIRDqyhxGliSA9ww9ZpQS8
	 1kSDkl31/uy5bDk7CHoQ/X9gdFhzGnJaEJ8GOPYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Mirabile <cmirabil@redhat.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 162/263] riscv: fix runtime constant support for nommu kernels
Date: Thu,  3 Jul 2025 16:41:22 +0200
Message-ID: <20250703144010.861074652@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Mirabile <cmirabil@redhat.com>

[ Upstream commit 8d90d9872edae7e78c3a12b98e239bfaa66f3639 ]

the `__runtime_fixup_32` function does not handle the case where `val` is
zero correctly (as might occur when patching a nommu kernel and referring
to a physical address below the 4GiB boundary whose upper 32 bits are all
zero) because nothing in the existing logic prevents the code from taking
the `else` branch of both nop-checks and emitting two `nop` instructions.

This leaves random garbage in the register that is supposed to receive the
upper 32 bits of the pointer instead of zero that when combined with the
value for the lower 32 bits yields an invalid pointer and causes a kernel
panic when that pointer is eventually accessed.

The author clearly considered the fact that if the `lui` is converted into
a `nop` that the second instruction needs to be adjusted to become an `li`
instead of an `addi`, hence introducing the `addi_insn_mask` variable, but
didn't follow that logic through fully to the case where the `else` branch
executes. To fix it just adjust the logic to ensure that the second `else`
branch is not taken if the first instruction will be patched to a `nop`.

Fixes: a44fb5722199 ("riscv: Add runtime constant support")

Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20250530211422.784415-2-cmirabil@redhat.com
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/runtime-const.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/runtime-const.h b/arch/riscv/include/asm/runtime-const.h
index 451fd76b88115..d766e2b9e6df1 100644
--- a/arch/riscv/include/asm/runtime-const.h
+++ b/arch/riscv/include/asm/runtime-const.h
@@ -206,7 +206,7 @@ static inline void __runtime_fixup_32(__le16 *lui_parcel, __le16 *addi_parcel, u
 		addi_insn_mask &= 0x07fff;
 	}
 
-	if (lower_immediate & 0x00000fff) {
+	if (lower_immediate & 0x00000fff || lui_insn == RISCV_INSN_NOP4) {
 		/* replace upper 12 bits of addi with lower 12 bits of val */
 		addi_insn &= addi_insn_mask;
 		addi_insn |= (lower_immediate & 0x00000fff) << 20;
-- 
2.39.5



