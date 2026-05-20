Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67AC369999;
	Wed, 20 May 2026 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297647; cv=none; b=PtlxqaWP+8Lsvz7818c8s+EI5+2skO1T9Kan09tPT+d9wDeNiBAdc+XkeKUdd/+cg3vcr7AuG7eAdJ6O68Sbn64Ar2eFkm8KEqpikIXmORXgQkgVHqXjvh2ifA3pVH33QuYlU+uF1H1Kq8wMc0AL/9XRN+P1ooymWzwBYJkkE4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297647; c=relaxed/simple;
	bh=HvQexGMLydu3+55grgY/oUWCeaFmbtYztuNlR//vu+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7vbUgyZ/IQ5EvUB1sq776sv63GYpt2ezn0qZMrP0Lq3lmefq/hIUqWbdsPhfDFM/NEi0s9Nhk1iBue/q4jmV6uXvW+jpIhpOTlMGmAJb7Ifr7M4LXvsQSrRQ+vEc28IvNsL4/pBRY7ky8Dak1F+rbn6eigc8rJujFcKyMvQxcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJyHU9Mb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJyHU9Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164941F0089D;
	Wed, 20 May 2026 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297645;
	bh=QAxbg+hgxn9CJdR2aLO7tRP5YFy32A0+NLqn+stncm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJyHU9MbF5Al8HQ6SWolKLVhf/lvm1LwFONAKX84Vk411+frH8UX6U7WSo6ln++Kl
	 ij4xG7ST30pZo/EXnadwlZKF5DRtWop8L+0dfvS3aTnhCzCI6e3JteJNpgvwKHdYoW
	 qleT2MLnCC4mlPb50gJf/3xNeSnhChC4/6krIRM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/957] bpf: Fix variable length stack write over spilled pointers
Date: Wed, 20 May 2026 18:09:53 +0200
Message-ID: <20260520162136.946561915@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 76503ed088b5d..0d1ec2b5d469a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5095,6 +5095,18 @@ static void check_fastcall_stack_contract(struct bpf_verifier_env *env,
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
@@ -5192,12 +5204,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	} else {
 		u8 type = STACK_MISC;
 
-		/* regular write of data into stack destroys any spilled ptr */
-		state->stack[spi].spilled_ptr.type = NOT_INIT;
-		/* Mark slots as STACK_MISC if they belonged to spilled ptr/dynptr/iter. */
-		if (is_stack_slot_special(&state->stack[spi]))
-			for (i = 0; i < BPF_REG_SIZE; i++)
-				scrub_spilled_slot(&state->stack[spi].slot_type[i]);
+		scrub_special_slot(state, spi);
 
 		/* when we zero initialize stack slots mark them as such */
 		if ((reg && register_is_null(reg)) ||
@@ -5321,8 +5328,13 @@ static int check_stack_write_var_off(struct bpf_verifier_env *env,
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



