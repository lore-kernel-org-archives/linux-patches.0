Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385BC51A15C;
	Wed, 30 Sep 2026 17:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789276; cv=none; b=sxI7kqJTpEFaiQagOIi1SlqTifgvIGFbgmdWi4aifa1vfxBd5o1sp0LS4Ni3L9tnZrybAYtCNUFUtJI6utbzEK1wRpDx14ALaCAgKVQ5FGRcPbS5lRkxUwmYuDd+gC33PWbkdltEBV/hK2TKseflHtz02v2uz2cWsSrCNKncnRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789276; c=relaxed/simple;
	bh=cIDTodDheYqOY6oE1qlzmTTpGb901u4IfqJ/M4V5/8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGTGZdjxuxnvE0ihExxJJJlD6Q5v3Z9lJvhH7jYJzkniHiBCR/o1hye+LWhDoWMlypxLzz5T5H9hjCZ92xq0ggHcp3W9IeIaxZfJFeD+3DIYIwHDt9N/efh6liN4E3v9oYGx7AHhPrf429WC5Kr8CHZSRD1XTFSpw6C/CPAppok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKmgaB2P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKmgaB2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E961F000FF;
	Wed, 30 Sep 2026 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789275;
	bh=XGHXMs7vDQLqv6EXFCfbMV+Mbr1ZTFY0ju08kBiqyEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKmgaB2PHcMlxIGMx58v4SZBj5ISELqv95oyggKEBv8/L9g4eJ8944+2Ke6XMX2uS
	 8wm9rcwINxSsFSr4BdqMpPKFZ5Zs/lVgmyBTYxo0RllP+DEqxNXmjSvLcYJ3na14pV
	 if9+lIggL9u3yTLVTDq8S4DxikB+xk3TfjME/8I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 420/877] bpf: Fix BSWAP 32 and 16 on MIPS64
Date: Wed, 30 Sep 2026 17:22:11 +0200
Message-ID: <20260930152423.753487426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 8110ba09777873443db286b3cbb89b0e6311c554 ]

The 16/32-bit byteswap implementations for MIPS64r1 and earlier do
not have an explicit zero extension afterwards. The input is first
sign-extended to 64 bits, and the byteswap sequence can then leave
the result sign-extended depending on the value of the low bits.

Add the missing zero-extension.

Found with test_bpf on MIPS64r1 emulated by QEMU.

Fixes: fbc802de6b10 ("mips, bpf: Add new eBPF JIT for 64-bit MIPS")
Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260923105158.3514342-2-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/net/bpf_jit_comp64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/net/bpf_jit_comp64.c b/arch/mips/net/bpf_jit_comp64.c
index fa7e9aa37f498..6681ccac9dd9e 100644
--- a/arch/mips/net/bpf_jit_comp64.c
+++ b/arch/mips/net/bpf_jit_comp64.c
@@ -305,8 +305,7 @@ static void emit_bswap_r64(struct jit_context *ctx, u8 dst, u32 width)
 	case 16:
 		emit_sext(ctx, dst, dst);
 		emit_bswap_r(ctx, dst, width);
-		if (cpu_has_mips64r2 || cpu_has_mips64r6)
-			emit_zext(ctx, dst);
+		emit_zext(ctx, dst);
 		break;
 	}
 	clobber_reg(ctx, dst);
-- 
2.53.0



