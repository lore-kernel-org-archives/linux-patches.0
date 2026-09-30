Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7520F51B191;
	Wed, 30 Sep 2026 17:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789057; cv=none; b=lWBOMlTNM8g5xkNKI08TZRK12onhTNa1MXzV6QlxHrLN8zTAHH3WmtiGWKUcYhjGzMXP3SR2jcBqDLADAmT85ybZdB4H2FCF5fUaVOR1sND/yZetWoCy5Jr2mRENAAMpV7l+jIXt7mVaFO1aC0jp7yTOz/z+RloDYmi4+ZKrhu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789057; c=relaxed/simple;
	bh=dwr4ko7c7R+TXmwEeAUCBTXbPiM19CFXa7Sg1a/nqVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6MmUiZEq0lfUVG22JjgMT666SLWwC7qLm6MnKBXIuQKBqE/QFyF1uyDmPOQiDjVCiXX8Nj2idkHQrGYgVTpBFY/zEYfLKFkg0nW5BdlNrNY61xl05x6uXjUeLjdPCsBXoXd2d4jAcL3C/UOu5tV8CGcobRStOt8jFyWuNGh+Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CF07ecdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CF07ecdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58681F00898;
	Wed, 30 Sep 2026 17:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789056;
	bh=B3Je0jNkXmSxN2k9AZbNQDW0+VFy4mCcVWPlgqyolCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CF07ecdwl39eEUUv5C2IqeY6rHxNuMoHIfmCGyLz3OGQ6Hu+Ubj9f1ByXt3mnSp35
	 DIJ187XsLjLKoaze8Hx//3P29XFF2G6c2SOcGdxhI2UNNBicD51YgJFmqAA9vA24lH
	 f+1joSbQbn7hO4B7kvk//cIhL0Yq9UbP/D22XVhg=
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
Subject: [PATCH 6.12 342/877] xsk: Use a 32-bit compare in xsk_map_gen_lookup
Date: Wed, 30 Sep 2026 17:20:53 +0200
Message-ID: <20260930152422.049344493@linuxfoundation.org>
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
index afa457506274c..607f8b7e16d96 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -124,7 +124,7 @@ static int xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	struct bpf_insn *insn = insn_buf;
 
 	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
-	*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 5);
+	*insn++ = BPF_JMP32_IMM(BPF_JGE, ret, map->max_entries, 5);
 	*insn++ = BPF_ALU64_IMM(BPF_LSH, ret, ilog2(sizeof(struct xsk_sock *)));
 	*insn++ = BPF_ALU64_IMM(BPF_ADD, mp, offsetof(struct xsk_map, xsk_map));
 	*insn++ = BPF_ALU64_REG(BPF_ADD, ret, mp);
-- 
2.53.0



