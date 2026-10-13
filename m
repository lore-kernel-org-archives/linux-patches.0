Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30574F0522;
	Tue, 13 Oct 2026 12:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894309; cv=none; b=GI2T8Y7o5XhfaPEPSmatKURVtmVcFYYAxwLOyLrcwVy0ioNghIB0ktQp6VizqGQNwIP7EcTHiMStUTzk137U+ByrBsERYLUvI0Ac83QDyO89MX6KBg0MPITRrtHvwHqXQ/087DprY+erC/d0mV9K9hyiI1kCTXR3oJvwo+WiDwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894309; c=relaxed/simple;
	bh=oQbV0xKFNZt7PPZ3sIsGX0hCDWobnvsFMcWBPXANJzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZNY4l6UCyvUJ309W/Y7Ou9xeyy17GpgOIuGmjaRo4DY5yTB0VeTVZtI7yPBSeH2vBtFVMTCcIYNZfQtZcE/rl4jQHeK2mxiyCmzNjGoRXTnlPX5PcMYzT+bQmWYGmCrhrCdzxBGvrToHTvh1h/Wm6wfEeEint+hWPWa8suNLZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLaGgPUv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLaGgPUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DBC1F000FF;
	Tue, 13 Oct 2026 12:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894308;
	bh=fZ3YjrkdxN78rU326iKlpXt5hGwO/ghOkwMGMxscyfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLaGgPUvuEqJQF3nReDHfjOsaHojjiwOI9teBGwJOGXJdZc7mN+J4SIryyV1DanGE
	 MK9++hE8Bf0ougXZ9hpYvidZNgtSEF1BRVoeIv/sATlLcpMdXGdn4/tp+heAk9ep2o
	 EeXe6h7H7/sKgGJVm8cDThU+/2Z8qzpG9xgFQhAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 516/621] bpf: zero extend the result of an arena 32-bit cmpxchg
Date: Tue, 13 Oct 2026 13:38:31 +0200
Message-ID: <20261013112933.069951105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 4814ed6406f3493bd554ad046da5f7fc04833571 ]

bpf_convert_ctx_accesses() rewrites an atomic on an arena pointer from
BPF_STX | BPF_ATOMIC to BPF_STX | BPF_PROBE_ATOMIC, and it runs before
bpf_opt_subreg_zext_lo32_rnd_hi32().

That pass emits an explicit zero extension for a 32-bit cmpxchg even
when bpf_jit_needs_zext() is false. This is done because on some
architectures 32-bit cmpxchg requires explicit zero extension for the
dst register. E.g. on x86-64 'lock cmpxchg' does not change the %eax
if comparison is successful, while BPF semantics declare that each
operation on a 32-bit register zero extends it's upper half.

is_cmpxchg_insn() matches BPF_MODE == BPF_ATOMIC only, so an arena
cmpxchg misses said zero extension adjustment. This patch adjusts
is_cmpxchg_insn() to match BPF_PROBE_ATOMIC alongside BPF_ATOMIC.

Fixes: d503a04f8bc0 ("bpf: Add support for certain atomics in bpf_arena to x86 JIT")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260903171542.1438050-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 971446e05187c..494a3144c6a7a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -604,10 +604,15 @@ static bool helper_multiple_ref_obj_use(enum bpf_func_id func_id,
 	return ref_obj_uses > 1;
 }
 
+/*
+ * Matches BPF_PROBE_ATOMIC too: bpf_convert_ctx_accesses() rewrites arena
+ * atomics before bpf_opt_subreg_zext_lo32_rnd_hi32() runs.
+ */
 static bool is_cmpxchg_insn(const struct bpf_insn *insn)
 {
 	return BPF_CLASS(insn->code) == BPF_STX &&
-	       BPF_MODE(insn->code) == BPF_ATOMIC &&
+	       (BPF_MODE(insn->code) == BPF_ATOMIC ||
+		BPF_MODE(insn->code) == BPF_PROBE_ATOMIC) &&
 	       insn->imm == BPF_CMPXCHG;
 }
 
-- 
2.53.0



