Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FCC3B3C01;
	Wed, 30 Sep 2026 19:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796840; cv=none; b=qeRM2BDxtStXNOpA50Zo3YpQ/1dTINJEA4UaBUvxICoahrPxfInIDcm+wq6vMq4e8axAXIWTjNVq+tqE/3HcmzmIWQJ5Ihs11X2OVvbXP5w1Z3KN4vtnpW3xhoQeEPXlJWMjXA5hAx8eATplkZequo8/VGgDD26dlSLYhS0o7eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796840; c=relaxed/simple;
	bh=eXhSMJZqXQtCN7s9pcjMIszwQBRQ6zrAGGSoR2Prtg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pntLACyWdgZPwuv6ZAqJRGo2tDoOOpFZKq8ogzTgZIXVsJ5M1MiEstrf74Inz8KFKRxyGTvblzjhabPw2l8dQLqhAO4bOVd/DksloDZY6cCzgrW3iGInFc4syOddJrQV6KzUPXmgQQPz+wluK2ZVUU/pgn7GZMd4MsV8Xp8qIhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxBEajWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxBEajWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE791F000FF;
	Wed, 30 Sep 2026 19:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796839;
	bh=S1QMa9ZN07n9TQprXtXXW3OKoW3imQRaqidQc/5kHLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxBEajWiSvsGbrPCJPW6foJKOr4buY+75AL9cMQycF/23qzv6RJyXNE737D6H8w3D
	 9jqZshvMHDARjCp2ZrIYHR3bE/BKkOZQUJa53GOOcKiMZN5lFr3CTxQA99l/Gq1zKk
	 ojyN4kf79VEcxnVr2JzWcg52phA3kKQVTQD2+S8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1056/1193] bpf: Fix BSWAP 32 and 16 on MIPS64
Date: Wed, 30 Sep 2026 17:29:00 +0200
Message-ID: <20260930152457.689737145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



