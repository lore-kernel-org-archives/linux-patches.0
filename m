Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BECC3AF646;
	Sat, 12 Sep 2026 18:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239061; cv=none; b=ADGefN+oUFbMApCDb04j2tWcHyBzyoBUanjTRh3rgTKuoC5h7Wyk2cPz+lM6Ksud+4sLvTFHlAoqxrGVonISPsu7geY9Hk6aHI5MGkQgknGPGnfhhsugKLyr4l3mUmIlmYL0XEPdrHsHcFzE7FJVIuNZ+fHf2OdkuJOpzYwlwLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239061; c=relaxed/simple;
	bh=LeeDS/IQDxPomunnx8S4FHsiNErtAfpWtC+DSh6e/ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PInXsKYlUZ1LOoh52M39FELowLL3afrxp63yR26w9DSd+LRsLCD++9ITREdQXf6P04U7GMTUX/YzKlUO+yME2VfTJrjeCx5Rgu4pqjNN83c/3khY+Qri9WTk1ckAuJRaSb5C0YiZzjXXSm0nIsQvZeQ7FgVUs5EQKwFhcimkn/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRGBA/R9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRGBA/R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D021F000FF;
	Sat, 12 Sep 2026 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239060;
	bh=Hhj5d0KcWf5t6k4lSZ5jyiozJmN8kKqreSApKA7xq1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRGBA/R9jtRXJ16+a88j2f0NWyurEjKqlvvjAS54MtLEo6m7kNc9u346xNXl7IF+b
	 pRZwbtBcViP+P6CjeeorfyeaLVRBg2GXuRRjjCM79N2HtxtHgApYtQSZzCH/ZYpU8d
	 7J+q2OFCkXkSPnfFheArQLsLoyhs+M2kU/Xe/588=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 535/935] bpf: Sync tail_call_reachable with callee state on entry
Date: Sat, 12 Sep 2026 08:59:25 +0200
Message-ID: <20260912065539.091095476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 3513ea9dab6c1a3d2dc8e6160c41f690206948b6 ]

Currently in check_max_stack_depth_subprog, when the verifier enters a
new callee branch, the local tail_call_reachable is not properly
synchronized with the callee's state.

Consider a main prog branching into multiple subprogs:

       subprog0 -> tailcall
main <
       subprog1 -> subprog2

When the verifier finishes checking subprog0 and backtracks to main
prog, the local tail_call_reachable state is left as true. As it
proceeds to subprog1, this uncleared state leaks into the new branch,
falsely marking subprog1 and subprog2 as tailcall reachable.

Fix this by explicitly syncing tail_call_reachable with the callee's
has_tail_call state on entry. The caller's state is safely preserved and
restored via the existing backtracking logic.

Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://patch.msgid.link/20260716120157.835937-2-pulehui@huaweicloud.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4e2d49b0d1f1c..40904b5b3c91a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3954,8 +3954,8 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
 		i = next_insn;
 		idx = sidx;
 
-		if (subprog[idx].has_tail_call)
-			tail_call_reachable = true;
+		/* sync tail_call_reachable with callee state on entry */
+		tail_call_reachable = subprog[idx].has_tail_call;
 
 		frame++;
 		if (frame >= MAX_CALL_FRAMES) {
-- 
2.53.0



