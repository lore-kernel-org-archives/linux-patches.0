Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6123F511225;
	Wed, 30 Sep 2026 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792399; cv=none; b=BH8HMeuZD/t80rUQQJBFiPHfgei5updUJJ30B2LzciYYMwoYMy9RIzyOFYr2iFmxasOHJQuClYp6C31qcfnRinB6H6Dn0aLTiyxs2zSTGQry0CQ9XVTPyIk29aiXMR4MV7KMHgHPA6ylyQ7VRv1UTb4QdrlTVc81d7yqp2hVzpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792399; c=relaxed/simple;
	bh=0hQmzNUQ40NdYTx0/wEV7BfON9vduF3MZjm9PaHr6mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSu0QwtJJcFBm18oM4sqBR3GOGqofyE6AZk6zXLM2vv4t5Lqi0I1nWWvGYH1MY50E052VXbuzAnwPvMlV2NTnGdhZzDf4MltUsM4lJwdWpCIV9dCxLhno80P/yeG8AnajqzybyrLKUWrTSA/5BBqnmzNq+kxAoCakUFncjHU39U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLbFeB/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLbFeB/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1F91F000FF;
	Wed, 30 Sep 2026 18:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792398;
	bh=mS5SyCrKTKktq7lhK8JkI33767QmYcn45D8FULguOJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLbFeB/j3jHJfxHrj+IB2PTLXFRbvkJJHqzbuG0GAKhJP157Q1JbuezyITCkDpsOK
	 22TudWt9DnDC9xC0yH3SzuuxjWAckujCvzIsGsQIRgNovIl9Q+bqOTSOWqQsrDK6Jt
	 Ysc1F2Amf2+t717Xc063O/74FTWSW+4zDOXUsRRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 640/752] bpf: Fix bpf_sock context code generation
Date: Wed, 30 Sep 2026 17:28:30 +0200
Message-ID: <20260930152412.115903418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit 4a4852376e3a2727ea40e61143d6d7c22bb6dfad ]

Currently, the ctx access code reads the rx_queue_mapping
field with either a 4-byte or 2-byte load. The rest of the bits
in the register are marked known zero by the verifier. However,
the emitted ctx access code places in the register on certain
the special value (-1) using BPF_MOV_IMM64, which gets sign-extended
to turn on all the bits in the register. By shifting this value right,
the program ends up with a value at runtime above what the verifier
assumes is possible.

Fix this by ensuring the read value is as wide as the assumed size.
Use MOV32 instructions instead of MOV64 instructions to keep
the upper bits zero as assumed by the verifier. Also properly report
the size of the destination variable (the bpf_sock field, 4 bytes) instead
of the source (the socket field, 2 bytes).

Fixes: c3c16f2ea6d2 ("bpf: Add rx_queue_mapping to bpf_sock")
Reported-by: Nicholas Carlini <nicholas@carlini.com>
Suggested-by: Nicholas Carlini <nicholas@carlini.com>
Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260922172028.6269-4-emil@etsalapatis.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1ee9432d516ed..f4a6ca23eef5b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9428,11 +9428,12 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 				       target_size));
 		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, NO_QUEUE_MAPPING,
 				      1);
-		*insn++ = BPF_MOV64_IMM(si->dst_reg, -1);
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, -1);
 #else
-		*insn++ = BPF_MOV64_IMM(si->dst_reg, -1);
-		*target_size = 2;
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, -1);
 #endif
+		*target_size = sizeof_field(struct bpf_sock, rx_queue_mapping);
+
 		break;
 	}
 
-- 
2.53.0



