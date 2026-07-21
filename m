Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472DB415F13;
	Tue, 21 Jul 2026 21:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669688; cv=none; b=tFz4vKY0gPIQI0L0lNJjT3tU6UxZhXAs3p0XwWn+WSYKBqGe8Hvj9x/Kx2AwTSfmpd6ZdqKS2QWtwQ9r2wBqzekPeKeNUPtJ/6kpvDMLaP4spTac5+O3smC6fTZVHByozYUjDpmxJzD42NUNP0AJZSExFzduDVx6ZVqqzgvMIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669688; c=relaxed/simple;
	bh=jpIohWB9HpvYwAZuaMa7Jj+qdEUw/1SxfY2obyJfvQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFj7Ja/EgH+sQf56niNIc8hOO5pN6a/ZkzwTQW/AISWtBYus8ZWeQp5IDHQ0VTCjKbhLcQFTfaEv2v8z/Pqoy1s0z9zroENNH4DzfoQvWZ1OUAZklJ/KdJ77Hs/CNYhXH4JWWhPQiWjN6mBYBrJ63GvGkT6/2ba6ALtS0GmXfis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rddsslh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rddsslh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC061F00A3A;
	Tue, 21 Jul 2026 21:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669684;
	bh=x2K5aDky0C2fSiu9p0sFJWUGUd36XUNinlrKsIe0D1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rddsslh4INfwMMd7Ekp9Gjgimv6C3Fbc4bSaGHK+Brh4eaC7hjM5lqzZINFEWSgD
	 ka2aPvCM5p7fj7Q0C/lAQeVdbF2rUv2Czwo4/FG5gxaKPXMyEp3SW5ggNR9yKLOOXk
	 OOPyg87mIMduKPwUStdfp8FeuujwII4ckAW2C4cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerhorst <luis.gerhorst@fau.de>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0611/1067] bpf: Fix stack slot index in nospec checks
Date: Tue, 21 Jul 2026 17:20:12 +0200
Message-ID: <20260721152438.266521757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

[ Upstream commit d1d53aa30ab3b5ae89161c9cc840b3f7489ad386 ]

check_stack_write_fixed_off() computes the byte slot for a fixed-offset
stack write as -off - 1, and records each written byte in slot_type[] with
(slot - i) % BPF_REG_SIZE.

The Spectre v4 sanitization pre-check uses slot_type[i] instead. For a
4-byte write at fp-8 after the lower half of fp-8 has been zeroed, the
pre-check scans bytes 0..3 and sees STACK_ZERO while the actual write updates
bytes 7..4. That can leave the second half-slot write without nospec_result
even though the bytes being overwritten still require sanitization.

Use the same slot index in the sanitization pre-check that the write path uses
when updating slot_type[].

Fixes: 2039f26f3aca ("bpf: Fix leakage due to insufficient speculative store bypass mitigation")
Acked-by: Luis Gerhorst <luis.gerhorst@fau.de>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/r/20260618-f01-11-stack-nospec-slot-index-v3-1-780297041721@mails.tsinghua.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d8d3616abceb63..4380082f321c7a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3234,7 +3234,8 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 		bool sanitize = reg && is_spillable_regtype(reg->type);
 
 		for (i = 0; i < size; i++) {
-			u8 type = state->stack[spi].slot_type[i];
+			u8 type = state->stack[spi].slot_type[(slot - i) %
+							      BPF_REG_SIZE];
 
 			if (type != STACK_MISC && type != STACK_ZERO) {
 				sanitize = true;
-- 
2.53.0



