Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB43B37FF60;
	Sat, 12 Sep 2026 09:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203881; cv=none; b=ZE30scRwm0Y1nD0zEt0r0sh+s9/+7oRk5rIFlBoPZvr8oR7N3ztWUKWy+ZHhDCsH4+4qGAmewydEnm+DXzWaFjtitiNsSSrSBF/JfOMoOOFnHqXVbXMEfXCIRUZe11lcIUBRmIpp9QRrpdVhkTuFALwiRQ8+30oUWJwU2TAk5Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203881; c=relaxed/simple;
	bh=1XlwboK1QMa2Dm/jsFwxPL4/mWM+mNTYcaBvxTALBhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/2/4NCd7Qv2XjVD/fbMvtYtgF0MNJBvFEZdIDOYK1wJHeuDgsZkNHT/sy38MwpH/uNinb+KFKTiu36Y+42FROy3yhQXIej7JaYxDIUF5F/AWpWXSs2rAD/pkdXmBr7p7eUPso0U2N+YWYmxdu9r9cgZDE1oSbBmAQ/FPDlpEWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+lOe1vP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+lOe1vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E941F000FF;
	Sat, 12 Sep 2026 09:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203879;
	bh=bkcIVGbCzhE7mrQXi9uNDbke3uGAHSA4px6sWN6us98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+lOe1vPn3t4lThmZBbAfJozA7MyWxmkOD9W3CMsQEASOsyH4dpMQogs093iyBwuI
	 J5opZU2q/uJBogiA0B5BIflC6wx0QMr9p6LcmpjYvO2cUjDaxx7L/KSwcnRM4XCxRM
	 sT8c/kYbzUxTFb+KbkTaXx9BWy/m//6LExZBiPc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1497/1815] bpf: Check pointer type for all atomic RMW paths
Date: Sat, 12 Sep 2026 08:54:07 +0200
Message-ID: <20260912065724.144016548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit 4bc49ae344d65cfcef738f281ac575cf73ca2fc5 ]

Atomic RMW verification records an instruction pointer type only when the
current destination is PTR_TO_ARENA. A second path can therefore reach the
same instruction with an ordinary pointer without comparing it against the
saved arena type.

The post-verification fixup uses the saved type to rewrite the instruction
to BPF_PROBE_ATOMIC for every path. Record the actual destination type for
all atomic RMW paths so the existing mismatch check rejects incompatible
uses of one instruction.

Fixes: d503a04f8bc0 ("bpf: Add support for certain atomics in bpf_arena to x86 JIT")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260816-bpf-next-038-mixed-atomic-v1-v2-1-4644c1886dbc@mails.tsinghua.edu.cn
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e55c145de6ac0..14a9fd2d54720 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6529,11 +6529,9 @@ static int check_atomic_rmw(struct bpf_verifier_env *env,
 	if (err)
 		return err;
 
-	if (is_arena_reg(env, insn->dst_reg)) {
-		err = save_aux_ptr_type(env, PTR_TO_ARENA, false);
-		if (err)
-			return err;
-	}
+	err = save_aux_ptr_type(env, dst_reg->type, false);
+	if (err)
+		return err;
 	/* Check whether we can write into the same memory. */
 	err = check_mem_access(env, env->insn_idx, dst_reg, argno_from_reg(insn->dst_reg), insn->off,
 			       BPF_SIZE(insn->code), BPF_WRITE, -1, true, false);
-- 
2.53.0



