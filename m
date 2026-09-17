Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC314E77F9;
	Thu, 17 Sep 2026 18:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669052; cv=none; b=YXsYEYBZL8Z2vlGhQoCIBZjKFErJXwQ7udqFCV+OOfNZ0pawOieoWChTEzjZsf1vnmsvUJlP+U9fmS98BxtwGYiG7MO76lJg2wunOZLzk8I6EJkTUyDQ40bn0N7/QUshP7vbjbgtpakgs9FNQ2rHlje+yj5+v0VYASoq4l+fzDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669052; c=relaxed/simple;
	bh=0/VoU2v+6G/OAnSCiArGwYRD/GWCyT5zJ+OCya2+RPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdUlSftFvYztq7dvggbX/iyggpKGTla/YJJeGptbeSxW27P1m03LPGYN7U80XsT1t38AW0okE4NmKYXzt1EKE+shIM4XJlBzQ/Q4X1bDdm/mMkm+yaOX7Rs/bHoLFmU0Nxug6YG6qERIuxdVEyyaYiKdA2HQwudDkMNcrbcDEjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYNkbglY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYNkbglY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2551F000FF;
	Thu, 17 Sep 2026 18:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669051;
	bh=EJgL9hT2ACxB9gqX58vQ2udlzu9zWygmtujmtk2pCGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYNkbglYECVq/1xTGB0JlnF1wegzyNwM5zwgefuww9h1SPerWXMCx0zlYeh/C/CyP
	 tyLfOxzE+Wa++pGDjh+sxBboKDWiUcwlVVm91xUUwgT3sU/M1e4RwdNbOfTi2U09DW
	 9dqcXkn4qLsE4KVOQuxYZS7DXhq/0zDImKs2JFiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0627/1102] bpf: reject BPF_PSEUDO_FUNC reference to the main program
Date: Thu, 17 Sep 2026 16:09:30 +0100
Message-ID: <20260917151555.838129840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 374b2c5561db80fcdd7cdce44af37a49416f61c7 ]

fixups.c:jit_subprogs() rewrites BPF_PSEUDO_FUNC loads to contain real
function addresses. This function is invoked from bpf_jit_subprogs()
only when env->subprog_cnt > 1. Meaning that for any program like
below:

  int main(void *ctx) {
    void *ptr = main;
    ...
    bpf_timer_set_callback(..., ptr);
    ...
  }

The 'ptr' won't be ever converted to contain an address.
In combination with e.g. bpf_timer_set_callback() this would lead to a
function call at a bogus address.

Instead of complicating the implementation, just assume that no useful
program needs main to be a sync or async callback and reject
BPF_PSEUDO_FUNC loads for the main subprogram.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260902233658.1186477-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 84a7b8d4f04dd..97742b0f3f8c6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15969,6 +15969,15 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			verbose(env, "callback function not static\n");
 			return -EINVAL;
 		}
+		/*
+		 * When env->subprog_cnt == 1 this instruction won't be rewritten
+		 * to hold a real function address. Assume that no usable program
+		 * combines e.g. main and timer callback and just reject here.
+		 */
+		if (subprogno == 0) {
+			verbose(env, "callback function cannot be the main program\n");
+			return -EINVAL;
+		}
 
 		dst_reg->type = PTR_TO_FUNC;
 		dst_reg->subprogno = subprogno;
-- 
2.53.0



