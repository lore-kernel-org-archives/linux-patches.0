Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83988519DFD;
	Wed, 30 Sep 2026 18:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792878; cv=none; b=ZfzxlHm4/SLOFw5upNQMeK1GZWrIPfG3XXiMH4iiBGEeBRaPqbEzQL9t5cFFpX2sOhejxMDwEw5UERetg5Zk4UCsaA00gVEF0oTfkABTOfZ8LpIfrxkaNQ/CtFAMR02iOe1FCSnYeAz4WJvieO5WFcdmFoX5LOGg0Naoht8Cqhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792878; c=relaxed/simple;
	bh=MwaF1p/PKcR9gpGA0vzlKWHWzmeoYQQXmljUdCelvnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkmPKe6L2q7mqgSFMtGLy/UV9XQSHdLOBqjnFWfREKe311iQiAlFVUpy89OBBuI4tnMUwzHkiisKVaXNxRuf6Uzw+AzZHH/ipL39M34Qu3j1dmVjDI0BFIPjtU5rphFC6LJ2lvGeQAycSbfC1CjxuNYFC2WrQJcMq82tKSHQy1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjNtnDrp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjNtnDrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FC01F000FF;
	Wed, 30 Sep 2026 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792877;
	bh=QnPkxpICwsROBrdnCsHFRMXZD8zd+4aJfXEwmUH9gYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjNtnDrpHPN01W2UwhaqBF0zHLLMzaUCmmgPPcBTcofAls2ZMf6XymeHZNdp7vPuW
	 ConYPu/w4vS8ot24rPGrBlpS963vjR9kE5MeXaZhEeo4gA6gzczQEYK2YWXiSEFA+M
	 guIRbNNYsMSol9y72urY066KUfWFBHeB8YHV1Duw=
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
Subject: [PATCH 6.18 056/395] xsk: Use a 32-bit compare in xsk_map_gen_lookup
Date: Wed, 30 Sep 2026 17:25:18 +0200
Message-ID: <20260930152341.850932027@linuxfoundation.org>
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



