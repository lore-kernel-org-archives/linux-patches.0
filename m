Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAB3364038;
	Sat, 12 Sep 2026 08:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203489; cv=none; b=Kn0hq57v9IVs+z5/bbNGiV0zC7lZFPnqJerHKrZYdmYrJJoljabTbyUfLE5sTuEfs8x3eD31kMCAtpWnegEpGJDGqsD3JTE9/I46jC9qDKrFEKs9fgh63Z2vTKO3U6QLo/wzXWoSn4sujei095KqcVNR1vyx6oWsoJydZuEvo6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203489; c=relaxed/simple;
	bh=ecJLwrWgRucF24P0JHx2dtJXtNx+pwN7i7dUwbcuYnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdgfYLC7K/z7kZgcl4pKLnQWR7CGUXLS8RB+067776dPRvwYw9pWTt70ngt6E2oPjkOHGDTMmkUXs8UKyOwlA3Ap11PR9SeeLYBOO3x/RjqqRkr0synjDL/MAXDcsZJFnKRKMXsCcOPDno+ZVPLabB1V21z6nPywSi06RMKgox8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzCGbRF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzCGbRF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB4E1F000FF;
	Sat, 12 Sep 2026 08:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203487;
	bh=ZjfVtrW3rPhB4JmL4YXrbdGhshjrXN2dtSPlxGPan5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzCGbRF+x0tGj8+hIgs1rMx4BG0tGCqb7b8axz03s79Nn9T2VTD1+yo1mooRH+rrf
	 lxefqYkHzGqo+jBkqcabC/43byBDRpR9CLBzF9d1q7XKqUmw27nS5JQkuooQCUa7FK
	 mqGrotVqC06NCilTFTQX/rBSVnLmeIkc2wsCpWPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ning Ding <dingning04@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1376/1815] bpf: Compare iterator types during state pruning
Date: Sat, 12 Sep 2026 08:52:06 +0200
Message-ID: <20260912065721.330304377@linuxfoundation.org>
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

From: Ning Ding <dingning04@gmail.com>

[ Upstream commit 83608e303b95d07afba1c15da0b5d9e513c2f15a ]

An iterator stack slot can be MEM_RCU or PTR_UNTRUSTED. These states
must not be equal, or the verifier can prune an unsafe path.

Compare the pointer type for STACK_ITER slots.

Fixes: dfab99df147b ("bpf: teach the verifier to enforce css_iter and task_iter in RCU CS")
Signed-off-by: Ning Ding <dingning04@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260811035955.132989-2-dingning04@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/states.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/states.c b/kernel/bpf/states.c
index ea2153cf28d0a..4e6aafad33bd2 100644
--- a/kernel/bpf/states.c
+++ b/kernel/bpf/states.c
@@ -812,7 +812,8 @@ static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
 			 * infinite loop check triggering, see
 			 * iter_active_depths_differ()
 			 */
-			if (old_reg->iter.btf != cur_reg->iter.btf ||
+			if (old_reg->type != cur_reg->type ||
+			    old_reg->iter.btf != cur_reg->iter.btf ||
 			    old_reg->iter.btf_id != cur_reg->iter.btf_id ||
 			    old_reg->iter.state != cur_reg->iter.state ||
 			    /* ignore {old_reg,cur_reg}->iter.depth, see above */
-- 
2.53.0



