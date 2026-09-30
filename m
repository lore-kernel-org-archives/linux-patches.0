Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A61D51588D;
	Wed, 30 Sep 2026 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786524; cv=none; b=lIP9qalcOy6jqvzEL/BMKV+FEWO1cPyXJKKupP24axZSEjd+gtbD1Jg4eVMCj6eY2Rk9wS4QzmJH6dEhy4QEhtjh7IeLRZ5FnIr64TRvDonmXFdBceZtWR4ItTBaMHaje9WhIipkv1OEXcmuGQXHdKnxAVDkJiibUEVo1FIgOOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786524; c=relaxed/simple;
	bh=n/MLBsKt19yEjkYKWQmrmKkDyfbejg9KpWNwQTOuyBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfDTLl+CTckLuXv/oOxJOkbU3yGsVnMeyJA6veWP8jk7cHhqASWF9DsHn7rTN81Eq6WM0S9vvP4Ff/L5h0dmkRdUNBRmHWE2sm9DzpFY4+mFW3NNn/+CySTJLEN292WEIeTj9YcyfKrUhsX2cyTLemxg9OjQ7OiM7hCXqBsoSyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4OSp10w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4OSp10w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42C51F00898;
	Wed, 30 Sep 2026 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786523;
	bh=57pK+IS4JBz8dS2iWXpaqs+YiU4lzpnBlTtV4azJPsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4OSp10wsQkXUeRmLx6y82ktQf63ndUQuomTEm//jBs9lyYDkELpKaFfR2SpmP9GA
	 JoeIq1fqePqwbkOnZWMvxndq7QUfCMWg5qQhQgu7EyAz1a8UwetvL2T98Xyw9hsONv
	 FIM1xHi7Cx4Ojfgsg5ri3sAL+19Iy9gr/7uXkQsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 893/982] bpf: Fix BSWAP 32 and 16 on MIPS64
Date: Wed, 30 Sep 2026 17:27:09 +0200
Message-ID: <20260930152435.927362994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0e7c1bdcf9148..b45c6c3bf1641 100644
--- a/arch/mips/net/bpf_jit_comp64.c
+++ b/arch/mips/net/bpf_jit_comp64.c
@@ -302,8 +302,7 @@ static void emit_bswap_r64(struct jit_context *ctx, u8 dst, u32 width)
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



