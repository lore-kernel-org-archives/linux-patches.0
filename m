Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD8064AAF;
	Tue, 23 Jan 2024 00:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970776; cv=none; b=atLWmCL71KoOsGlMQPzxOz0ai0kHqzsf7FegZoBd2wQkTdHSGDBnNE1R+j7GoOOFJt8Pme6+LptBvZU/L0vUv6JfNQBXEPizDKTpXhxD3trFgtP+qAF+hXp3C32G8ZNzopB08x5DaRnHVlJyC7PVK6RLKHuqC13HuE8EakXdHVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970776; c=relaxed/simple;
	bh=l0Iv1A+ILgwhQTqecSE1ZZIHUo17wWfM+dFLglCU0u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiEOWsXwZiiWqSJcqgp/e29oeF7NqrAcN6RfyFDgxzDj2flSUYBsVbg0YTx9TehxmAIf2zvgU12xvRd3QU7gHPk5yIcOViphS/iEi7DS6PSvzj7Neue8ftbR0C1mgiGETdX2G83Cxf/g8tOpCe8sVC5cN4kHb9YeKWZQQ4nuRIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7T4kMlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7T4kMlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16429C433F1;
	Tue, 23 Jan 2024 00:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970776;
	bh=l0Iv1A+ILgwhQTqecSE1ZZIHUo17wWfM+dFLglCU0u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7T4kMlUiKFyyAGKJbw/Z+2mylIgb/y0T+7jgd8wMlMdZAJsL2gMkJfuZ7MNF1X8I
	 VAWti5cF5nOvsp9wlygWle1yWSQer3hADcYTqdaxev8Wzo2VgyLY2jw9f81DKDoayP
	 fGE9NyuwIH/rC//fvj1zzCPx9AjkBs/DTL8Kawpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Andrei Matei <andreimatei1@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/417] bpf: Fix verification of indirect var-off stack access
Date: Mon, 22 Jan 2024 15:54:35 -0800
Message-ID: <20240122235755.429341809@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andrei Matei <andreimatei1@gmail.com>

[ Upstream commit a833a17aeac73b33f79433d7cee68d5cafd71e4f ]

This patch fixes a bug around the verification of possibly-zero-sized
stack accesses. When the access was done through a var-offset stack
pointer, check_stack_access_within_bounds was incorrectly computing the
maximum-offset of a zero-sized read to be the same as the register's min
offset. Instead, we have to take in account the register's maximum
possible value. The patch also simplifies how the max offset is checked;
the check is now simpler than for min offset.

The bug was allowing accesses to erroneously pass the
check_stack_access_within_bounds() checks, only to later crash in
check_stack_range_initialized() when all the possibly-affected stack
slots are iterated (this time with a correct max offset).
check_stack_range_initialized() is relying on
check_stack_access_within_bounds() for its accesses to the
stack-tracking vector to be within bounds; in the case of zero-sized
accesses, we were essentially only verifying that the lowest possible
slot was within bounds. We would crash when the max-offset of the stack
pointer was >= 0 (which shouldn't pass verification, and hopefully is
not something anyone's code attempts to do in practice).

Thanks Hao for reporting!

Fixes: 01f810ace9ed3 ("bpf: Allow variable-offset stack access")
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231207041150.229139-2-andreimatei1@gmail.com

Closes: https://lore.kernel.org/bpf/CACkBjsZGEUaRCHsmaX=h-efVogsRfK1FPxmkgb0Os_frnHiNdw@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index adadf8546270..95e7b638418e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4950,10 +4950,7 @@ static int check_stack_access_within_bounds(
 
 	if (tnum_is_const(reg->var_off)) {
 		min_off = reg->var_off.value + off;
-		if (access_size > 0)
-			max_off = min_off + access_size - 1;
-		else
-			max_off = min_off;
+		max_off = min_off + access_size;
 	} else {
 		if (reg->smax_value >= BPF_MAX_VAR_OFF ||
 		    reg->smin_value <= -BPF_MAX_VAR_OFF) {
@@ -4962,15 +4959,12 @@ static int check_stack_access_within_bounds(
 			return -EACCES;
 		}
 		min_off = reg->smin_value + off;
-		if (access_size > 0)
-			max_off = reg->smax_value + off + access_size - 1;
-		else
-			max_off = min_off;
+		max_off = reg->smax_value + off + access_size;
 	}
 
 	err = check_stack_slot_within_bounds(min_off, state, type);
-	if (!err)
-		err = check_stack_slot_within_bounds(max_off, state, type);
+	if (!err && max_off > 0)
+		err = -EINVAL; /* out of stack access into non-negative offsets */
 
 	if (err) {
 		if (tnum_is_const(reg->var_off)) {
-- 
2.43.0



