Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CA31ED30
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E8FC43395;
	Tue,  1 Aug 2023 09:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883377;
	bh=Kd+gMG8SekMRMwE3EeQIO/AWKpc01h4876KM0l62ELI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCy7yPuITwOSxjEmATgqMAM5n/OjJ3Yn/2xwopA6xwz9XFhO+mz97p0hetdz1cR4D
	 gz1MLpbxygRi6GPbLWdzTmDb95IYYSSdG4hiuVnf/CURIZxNreR6ItB5FaKqokOR8v
	 7Gx2XjP067I2Ga+DDjB1+YRqgQADIaE+Z5JvzBKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Colin King (gmail)" <colin.i.king@gmail.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.4 214/239] LoongArch: BPF: Fix check condition to call lu32id in move_imm()
Date: Tue,  1 Aug 2023 11:21:18 +0200
Message-ID: <20230801091933.592178432@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 4eece7e6de94d833c8aeed2f438faf487cbf94ff upstream.

As the code comment says, the initial aim is to reduce one instruction
in some corner cases, if bit[51:31] is all 0 or all 1, no need to call
lu32id. That is to say, it should call lu32id only if bit[51:31] is not
all 0 and not all 1. The current code always call lu32id, the result is
right but the logic is unexpected and wrong, fix it.

Cc: stable@vger.kernel.org # 6.1
Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Reported-by: Colin King (gmail) <colin.i.king@gmail.com>
Closes: https://lore.kernel.org/all/bcf97046-e336-712a-ac68-7fd194f2953e@gmail.com/
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.h
+++ b/arch/loongarch/net/bpf_jit.h
@@ -150,7 +150,7 @@ static inline void move_imm(struct jit_c
 			 * no need to call lu32id to do a new filled operation.
 			 */
 			imm_51_31 = (imm >> 31) & 0x1fffff;
-			if (imm_51_31 != 0 || imm_51_31 != 0x1fffff) {
+			if (imm_51_31 != 0 && imm_51_31 != 0x1fffff) {
 				/* lu32id rd, imm_51_32 */
 				imm_51_32 = (imm >> 32) & 0xfffff;
 				emit_insn(ctx, lu32id, rd, imm_51_32);


