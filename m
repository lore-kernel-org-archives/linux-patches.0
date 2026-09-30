Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814C9513556;
	Wed, 30 Sep 2026 16:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786348; cv=none; b=VcSZUcDpFkGLuTrttN2+Z7is5+HqFoLH++gq4F5lGoEb1swzCNbVx/hrnneqNTSIxbtq0EVc8mOVwlYHliaOFY4jGN9TpSSXuw3KC/h+w4Khs/EmAcBZ7epZQFvqoXkMi5QbjoXg3vHbaqpDLGLXlM1y7TyjMJSZ93zO/QQJuuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786348; c=relaxed/simple;
	bh=ivJ4sz2aexcWfUBxpM5OAilR1rnM6XSwjK/L2I/uac8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcdwfhgyGF+UjV9B350gac6eeFgdMfDOuknJPZ2vE7IR7gth61GUV5qoR42RiQvrZ+8QRTa605uJAfGoYPu4BkRUOPt3C/hQB9MlBZ/9FdWhi1nML3mtUUemAEAyHaDoJejGb2YF15JuuxU8siCoX2hR4GmDeMJwRdajNNx1U7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOl99/Vs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOl99/Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E216D1F000FF;
	Wed, 30 Sep 2026 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786347;
	bh=en+zGEW3vT7U7zl8l2gsruZy1koQ79LtUkbl9uv2Pho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOl99/VsMmWr9mf9FYLlTQRAyYkGCx3eFoDPZYnaOrrvoi9+sy5rCL++B8VjwBo4Y
	 cWQB0Fz0S6MTiSur8fy4MUa5TEihB1hPKrLHhBq1P5aSME+a7wseHdb1MgrpLAeckk
	 e7AYstdj0i+ZFaWafRB13qiKztGfr3iHR3W0N7Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Alexei Starovoitov <ast@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 828/982] xsk: Use a 32-bit compare in xsk_map_gen_lookup
Date: Wed, 30 Sep 2026 17:26:04 +0200
Message-ID: <20260930152434.543490220@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 70504de0bb627848667207bec7ccfd647deb8814 ]

xsk_map_gen_lookup() loads a u32 key and compares it with max_entries
using BPF_JMP_IMM. BPF immediates are sign-extended to 64 bits, so a
max_entries value of 0x80000000 or higher becomes a threshold larger
than every zero-extended 32-bit key. An out-of-range index then skips
the bounds check and the generated lookup reads past xsk_map[].

Compare with BPF_JMP32_IMM so the check stays in 32-bit unsigned range.

Fixes: e65650f291ee ("bpf: Implement map_gen_lookup() callback for XSKMAP")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://patch.msgid.link/7d2cb8e8dfaa9eb8fdff85156987a60960787dc3.1789056660.git.zhilinz@nebusec.ai
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xskmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 47cb92c4d541b..d52a1a822622e 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -116,7 +116,7 @@ static int xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	struct bpf_insn *insn = insn_buf;
 
 	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
-	*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 5);
+	*insn++ = BPF_JMP32_IMM(BPF_JGE, ret, map->max_entries, 5);
 	*insn++ = BPF_ALU64_IMM(BPF_LSH, ret, ilog2(sizeof(struct xsk_sock *)));
 	*insn++ = BPF_ALU64_IMM(BPF_ADD, mp, offsetof(struct xsk_map, xsk_map));
 	*insn++ = BPF_ALU64_REG(BPF_ADD, ret, mp);
-- 
2.53.0



