Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7883534DCE4;
	Wed, 20 May 2026 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300125; cv=none; b=cNu0o4OnqVvc7TJR7FLZt6YOAGmvE8t95wunTWPO+RTMZldF9/R+xWMgDUrMcXMpuQFNpzBTXymJyzgAdFxmNqnqNi5gvXYuMHPTfFmLy8C6mqG15k0NxPzWQuYvovxYA/q/bEMpVF5xH8wLuNlk/4SrWWCtGjRWB8QsegNvsWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300125; c=relaxed/simple;
	bh=beC2TrO4qJVFKC4QYHSCU4m30l4t6Fvj2XL1ZG7Ufpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiX3vU85rJiL8irLGrqSDgG9cnJrKYEQEfPrKdpWA5te4DPcm6aiA695rImF0Nn7DT8Xtr0LbkJ9o0wGUh/MDEXFaRsFYY6SlmpTfeSU/INUyWtXz6YhNVOVfRsuNItNNh0xtyEBtBPYYGSIEICbxAZgZk0ufrbnfT07F+xa5gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZMpo5ZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZMpo5ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52281F000E9;
	Wed, 20 May 2026 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300124;
	bh=RALhIwvSyHx/GZeATZ2KLpC8F0M/JeRRcujHACqgXb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZMpo5ZBQ43BkD4nQuRyjdJHR/DCB25tDhygreohI1vxtYr9sx8NEbDi60uaPMy11
	 8QQpVMshwtdJzDEhvL7MK6Rd66KezvNMGY8HUMEChiSJQu0YQ5tIaU+cuqgr7HJj7I
	 +Qggecbcn5pIptshUkOW+t0Q8WVE1GV8cmrSbKmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/666] bpf: Fix variable length stack write over spilled pointers
Date: Wed, 20 May 2026 18:14:27 +0200
Message-ID: <20260520162112.449798421@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 4639eb9e30ab10c7935c7c19e872facf9a94713f ]

Scrub slots if variable-offset stack write goes over spilled pointers.
Otherwise is_spilled_reg() may == true && spilled_ptr.type == NOT_INIT
and valid program is rejected by check_stack_read_fixed_off()
with obscure "invalid size of register fill" message.

Fixes: 01f810ace9ed ("bpf: Allow variable-offset stack access")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260324215938.81733-1-alexei.starovoitov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 96a04cd904a11..feb90c6e94620 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4724,6 +4724,18 @@ static void check_fastcall_stack_contract(struct bpf_verifier_env *env,
 	}
 }
 
+static void scrub_special_slot(struct bpf_func_state *state, int spi)
+{
+	int i;
+
+	/* regular write of data into stack destroys any spilled ptr */
+	state->stack[spi].spilled_ptr.type = NOT_INIT;
+	/* Mark slots as STACK_MISC if they belonged to spilled ptr/dynptr/iter. */
+	if (is_stack_slot_special(&state->stack[spi]))
+		for (i = 0; i < BPF_REG_SIZE; i++)
+			scrub_spilled_slot(&state->stack[spi].slot_type[i]);
+}
+
 /* check_stack_{read,write}_fixed_off functions track spill/fill of registers,
  * stack boundary and alignment are checked in check_mem_access()
  */
@@ -4809,12 +4821,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	} else {
 		u8 type = STACK_MISC;
 
-		/* regular write of data into stack destroys any spilled ptr */
-		state->stack[spi].spilled_ptr.type = NOT_INIT;
-		/* Mark slots as STACK_MISC if they belonged to spilled ptr/dynptr/iter. */
-		if (is_stack_slot_special(&state->stack[spi]))
-			for (i = 0; i < BPF_REG_SIZE; i++)
-				scrub_spilled_slot(&state->stack[spi].slot_type[i]);
+		scrub_special_slot(state, spi);
 
 		/* only mark the slot as written if all 8 bytes were written
 		 * otherwise read propagation may incorrectly stop too soon
@@ -4949,8 +4956,13 @@ static int check_stack_write_var_off(struct bpf_verifier_env *env,
 			}
 		}
 
-		/* Erase all other spilled pointers. */
-		state->stack[spi].spilled_ptr.type = NOT_INIT;
+		/*
+		 * Scrub slots if variable-offset stack write goes over spilled pointers.
+		 * Otherwise is_spilled_reg() may == true && spilled_ptr.type == NOT_INIT
+		 * and valid program is rejected by check_stack_read_fixed_off()
+		 * with obscure "invalid size of register fill" message.
+		 */
+		scrub_special_slot(state, spi);
 
 		/* Update the slot type. */
 		new_type = STACK_MISC;
-- 
2.53.0



