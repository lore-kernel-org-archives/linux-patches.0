Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624778;
	b=HzQEh3DFqFZvFd8dC+8oB7jUCyj+nEHr6/+W4+QlM1GaJ1cjLDPnBz8qMmrmNmARiB3f
	 d9bCn9LpM/7Pm8l83O87rbbBRiFmc2JNs2YTg/mbEJK1onlea46Ajti6PLXLGom6Fi+bL
	 BZ5Tm5L+SMW0WXbhd7dAjlMNz5+ZU139h6E3Ve+mWO7fRnlSKSewQmkof3vEQagYmugOR
	 24SS/E0wDgW4Iw2+cSpTKiOBybk1n94QGHE0uEfOFs0s4ktAPI6RvE9KDaTc0o10SpDmp
	 MN/7rLvEPbNGDE2FpINWb7caJPCumX4sl/jRTOVHQdENVjgLy5TRz9HNQOYQtVmSZtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DURzyIzNldD1rIeBjmZMlqDgLKM0qdHGpCD35zDqirA=;
	b=vut9pxtCOf4VRXGPw3pNAvLcgnDstaQ4eYQxflikbPo4jFcubtJHsTHcaZ7VuK+nFQ2H
	 dJqqVMKuOuzIlTQMsyqyentvlho/49ArlE0HS6mSwlIadyyKC/PTFAgN0U6FeEDAzy26k
	 H6dSRGu0zHc/N/feh2ngbgm7C6pTWLi5FClyRi9yV3C3y9mLoAe13u75JQ1DSVISUafB4
	 GzxcF79s1etCfomG+Bacv+OB80Ylu1Vgor9zXNStHCOzL01MjC6xJ92TXdtWsmq8RmRrd
	 ygPUVsEsn/l8jV+NIlZ6ETV1qgznR2LLUQXfTa7wjfKO7Z9lTnBhfrRWCk3zOYmq3rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJJi8krg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B6A606A339;
	Wed, 25 Nov 2026 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJJi8krg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A111F000CF;
	Wed, 25 Nov 2026 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624777;
	bh=DURzyIzNldD1rIeBjmZMlqDgLKM0qdHGpCD35zDqirA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJJi8krgHGg48fyiI97xZHPA+VtRYS8yLizBxLwMKG62V3F0k9DV507Ag7jFTE6nm
	 6i6rxrdAcIVWgS2tk6ujeaDWWBo2a8hoE+djHKuUw41bC37CrJ+v7Oy3uYRRZvpbyV
	 4EpdYzcZ8CxdKxLhHEs9yH/4Vp3FmdHggf9nKa5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/816] SUNRPC: Balance switch queue length on transport removal
Date: Wed, 25 Nov 2026 15:30:51 +0100
Message-ID: <20261125143856.218229111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 8acd94f02a960c8936df25a7af9c02c8ea87064d ]

When call_connect_status() moves a task off a transport marked for
removal, it decrements xprt->queuelen but leaves the switch's
xps_queuelen unchanged. The stale count persists after the task
finishes and skews multipath transport selection.

Decrement xps_queuelen alongside xprt->queuelen, matching the normal
transport release path.

Fixes: 6f081693e7b2 ("sunrpc: remove an offlined xprt using sysfs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 80a4e2ca323c5..81e5e756d8ffa 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2241,6 +2241,7 @@ call_connect_status(struct rpc_task *task)
 
 				xprt_release(task);
 				value = atomic_long_dec_return(&xprt->queuelen);
+				atomic_long_dec(&xps->xps_queuelen);
 				if (value == 0)
 					rpc_xprt_switch_remove_xprt(xps, saved,
 								    true);
-- 
2.53.0



