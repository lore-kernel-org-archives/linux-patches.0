Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B90749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23840C433D2;
	Thu, 12 Jan 2023 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532354;
	bh=amqTdM9XMNnHKete7CvX/sBJxSkCGR5FUoOd94KIqcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDrUbDoImAGi3wn07jEaaa5aNdAEhRT9ethmAKiFcOAHuuE5nFB5bk+ddLwkWKHd5
	 D3vKQo9uAJISdJiT7zzyCUhrwds4xDx9OzaRGjbCkNV6Uz0eQ7b6yp3qRcqzZK+i77
	 YvTFMkDSgVIjOcnKYv/JuAH6AkMToPYTSw6ahznE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/783] bpf: Fix slot type check in check_stack_write_var_off
Date: Thu, 12 Jan 2023 14:47:29 +0100
Message-Id: <20230112135530.484850348@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit f5e477a861e4a20d8a1c5f7a245f3a3c3c376b03 ]

For the case where allow_ptr_leaks is false, code is checking whether
slot type is STACK_INVALID and STACK_SPILL and rejecting other cases.
This is a consequence of incorrectly checking for register type instead
of the slot type (NOT_INIT and SCALAR_VALUE respectively). Fix the
check.

Fixes: 01f810ace9ed ("bpf: Allow variable-offset stack access")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20221103191013.1236066-5-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 50364031eb4d..4d62822f5502 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2439,14 +2439,17 @@ static int check_stack_write_var_off(struct bpf_verifier_env *env,
 		spi = slot / BPF_REG_SIZE;
 		stype = &state->stack[spi].slot_type[slot % BPF_REG_SIZE];
 
-		if (!env->allow_ptr_leaks
-				&& *stype != NOT_INIT
-				&& *stype != SCALAR_VALUE) {
-			/* Reject the write if there's are spilled pointers in
-			 * range. If we didn't reject here, the ptr status
-			 * would be erased below (even though not all slots are
-			 * actually overwritten), possibly opening the door to
-			 * leaks.
+		if (!env->allow_ptr_leaks && *stype != STACK_MISC && *stype != STACK_ZERO) {
+			/* Reject the write if range we may write to has not
+			 * been initialized beforehand. If we didn't reject
+			 * here, the ptr status would be erased below (even
+			 * though not all slots are actually overwritten),
+			 * possibly opening the door to leaks.
+			 *
+			 * We do however catch STACK_INVALID case below, and
+			 * only allow reading possibly uninitialized memory
+			 * later for CAP_PERFMON, as the write may not happen to
+			 * that slot.
 			 */
 			verbose(env, "spilled ptr in range of var-offset stack write; insn %d, ptr off: %d",
 				insn_idx, i);
-- 
2.35.1



