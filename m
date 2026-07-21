Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B8245BD4E;
	Tue, 21 Jul 2026 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648987; cv=none; b=nuloql2DdayXmVZW2dr0SzoLZf8Z7VDyBH2DxdGmd054817bKzw/U/zPuqsmQbtOwdMcYDhD9DJDeWdUe2Xzv5p7GKuF7wUgjx79WCEB5dgL/jsCCzMm6Vb9nvKe/xyvPW+c8XepV79KOSEIJcVGd3NBS4wKA8uxHGqVoD2G1iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648987; c=relaxed/simple;
	bh=X+l/Lou+np4bW8FQfzDpW34jFkyGyNvI1jGd9ZPiGSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JALDN5jBos5dx67mulFbZCrCSIXH7ml4aetLehUGYItAFRG3DE+dYY+CruNiPahZg0f67uf53ci0s1uW/unZLjNky35L4/UZx1WggDYEgx20rKPlYsTheibmKrC2q5KKLsqF7yCgsszszRJZMhHaJR6UKvqJ8GCKePM5G5Ntw+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOQdgdoY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOQdgdoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0F61F000E9;
	Tue, 21 Jul 2026 15:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648986;
	bh=LnszW2JmqvFYHWKb+Z2FMP1MAR5k0V/oBYn7BXE0PsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOQdgdoYsDWx1v5mU5r9NHvCpOR5OaKu8TjiZIBbhQR4yfKrgA8a3Ua9y8zecjppT
	 cPkeIB54ZnRfoKkiUPZiZJOyterhR8spjNNsl/kkpI1Q/0BD9t54zZwW6IcxkjF4nY
	 xLLpsl1twq6MNbOgdSnUaMDXvMwOXTLp01oZwQuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko@sashiko.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0405/2077] libbpf: Skip hash computation when loader generation failed
Date: Tue, 21 Jul 2026 17:01:18 +0200
Message-ID: <20260721152602.270574142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3c5e2f1a85844abbb65df4694f5ebad0a13e219c ]

bpf_gen__finish() calls compute_sha_update_offsets() gated only on
the gen_hash option, without first consulting gen->error. On a failed
generation this is buggy: a failed realloc_data_buf() sets gen->data_start
to NULL (leaving gen->data_cur dangling), so compute_sha_update_offsets()
runs libbpf_sha256() over a NULL buffer with a bogus length; a failed
realloc_insn_buf() likewise sets gen->insn_start to NULL and the hash
immediates get patched through that NULL base.

The computed program is discarded in either case, since the following
"if (!gen->error)" block does not publish opts->insns once an error is
set. Thus, skip the hash pass when generation has already failed.

Fixes: ea923080c145 ("libbpf: Embed and verify the metadata hash in the loader")
Reported-by: sashiko <sashiko@sashiko.dev>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260529094119.307264-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 9478b8f78f260c..e2fe841a56698b 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -398,13 +398,12 @@ int bpf_gen__finish(struct bpf_gen *gen, int nr_progs, int nr_maps)
 			      blob_fd_array_off(gen, i));
 	emit(gen, BPF_MOV64_IMM(BPF_REG_0, 0));
 	emit(gen, BPF_EXIT_INSN());
-	if (OPTS_GET(gen->opts, gen_hash, false))
-		compute_sha_update_offsets(gen);
-
-	pr_debug("gen: finish %s\n", errstr(gen->error));
 	if (!gen->error) {
 		struct gen_loader_opts *opts = gen->opts;
 
+		if (OPTS_GET(opts, gen_hash, false))
+			compute_sha_update_offsets(gen);
+
 		opts->insns = gen->insn_start;
 		opts->insns_sz = gen->insn_cur - gen->insn_start;
 		opts->data = gen->data_start;
@@ -419,6 +418,7 @@ int bpf_gen__finish(struct bpf_gen *gen, int nr_progs, int nr_maps)
 				bpf_insn_bswap(insn++);
 		}
 	}
+	pr_debug("gen: finish %s\n", errstr(gen->error));
 	return gen->error;
 }
 
-- 
2.53.0



