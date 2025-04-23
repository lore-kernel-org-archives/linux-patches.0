Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1CF279345;
	Wed, 23 Apr 2025 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422314; cv=none; b=WqYLdKlX3B3OBRrD7iqQjoRGm9qEyUZzCD398UdjCI0C1Sq8P138c14hr+8wNbz2j06W9b/18xqbwQo9XNeAQuoMpk+mlYM3D1+TNeyotSIj0lchlabrYle5ltOHjmX1uQKTjVyKvl2rpUZMyFdu+KfTtK+9ZLMAzMEraGg/sbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422314; c=relaxed/simple;
	bh=bp9srViOiOUQ0OkASSEr8PIYKlU7AQwHLdGmNqGpKgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgeT50LWwyb+J87zaJEuRrfPM+SXtA9hihCxvh/9XdDPhNtU9qqKqE4YL2YH/PMrdTWn4k1laOdQIDN3hG+rcDD362MqSWX4UN15gGn8I4k/PCVWJ7erAdXY+wk0buDNSDrc8EEoEuZ+jIjFMYwvVHjrVY8HA8a3ediepuQEzQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilNd5MUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilNd5MUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2B2C4CEE2;
	Wed, 23 Apr 2025 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422314;
	bh=bp9srViOiOUQ0OkASSEr8PIYKlU7AQwHLdGmNqGpKgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilNd5MUwclJb9tpCmqpwoQe7Ns/JJVZsNqwXafl0DHeqSfAHQ+VwpwAkX5Q0QSI6x
	 oVJ8PKnK3XoWeIk/Rg/G3MqqrntstU6pZlJM6Po8pZdfwqGgSVxK/HoIZYxwJtZXyw
	 5G8RPShMv3XsoTqzomopVmDvfwjz+9KzUf2it9vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 275/291] Revert "LoongArch: BPF: Fix off-by-one error in build_prologue()"
Date: Wed, 23 Apr 2025 16:44:24 +0200
Message-ID: <20250423142635.668874667@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit e9ccb262b39a which is
commit 7e2586991e36663c9bc48c828b83eab180ad30a9 upstream.

It breaks the build.

Link: https://lore.kernel.org/r/90288944-3f5b-45b7-ae7d-c7a54398db55@roeck-us.neta
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Vincent Li <vincent.mc.li@gmail.com>
Cc: Hengqi Chen <hengqi.chen@gmail.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    2 --
 arch/loongarch/net/bpf_jit.h |    5 -----
 2 files changed, 7 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -142,8 +142,6 @@ static void build_prologue(struct jit_ct
 	 */
 	if (seen_tail_call(ctx) && seen_call(ctx))
 		move_reg(ctx, TCC_SAVED, REG_TCC);
-	else
-		emit_insn(ctx, nop);
 
 	ctx->stack_size = stack_adjust;
 }
--- a/arch/loongarch/net/bpf_jit.h
+++ b/arch/loongarch/net/bpf_jit.h
@@ -25,11 +25,6 @@ struct jit_data {
 	struct jit_ctx ctx;
 };
 
-static inline void emit_nop(union loongarch_instruction *insn)
-{
-	insn->word = INSN_NOP;
-}
-
 #define emit_insn(ctx, func, ...)						\
 do {										\
 	if (ctx->image != NULL) {						\


