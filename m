Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED7751C058;
	Wed, 30 Sep 2026 18:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793177; cv=none; b=f6igV4uSigIH/o8B6OPbaIwWEXBAb9u4GEU0x0wxPrHgdw1xMdQJMEJxtWVLSOzYPIj++nsz59D54LLtOIJ/OzMlxHabzNNQFdn9swxxPEZlL8cY9vy4pjeAUC8OCtC6Z/6ZFg/i0Y0Rh/c7Ll2gbHkXspYiGu+s8RU9Rnzlc5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793177; c=relaxed/simple;
	bh=V7+f15eURqWhy1tp4asPhQECtjAqZIiX6RD1t101UJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYl7DBjG/e6riU04e8/UoDZAB4hyWBxfWh5QzP28vSdV+uWPL8OONvgovatDx2iKuTnswbm4Q5qnvGm1CtGgwMi4XznCMJSJB8PRd82noNAxoCSdsewKbObp//vSq1zsPbGVJHd+M9V25e37SNGJdEqk9xQeAXpLupnYiq/hVb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFTgcPZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFTgcPZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDEA1F000FF;
	Wed, 30 Sep 2026 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793175;
	bh=Nj6j5VYpSlys+ZBRuhO9uJ8Ya4OeiNCFjN7dm3h4Zqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFTgcPZ+xoAGKsQv+GYay2qbhQqcqBM1efEk/gbM1RG3bWjPNAiXVL5Ah1+1xI7Kd
	 NpBKVszZlET3qcFNF8EMyHSlJivljvLug75bai1k7EqHRn/je4L6Ipk4kyHtFyOqde
	 tZH9xUJKcbbDAg61iMzt4IYz9VPwpz79gHQ/cvxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/395] bpf: Fix BSWAP 32 and 16 on MIPS64
Date: Wed, 30 Sep 2026 17:27:03 +0200
Message-ID: <20260930152344.139948720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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



