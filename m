Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA9C24E4A8;
	Thu, 27 Nov 2025 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255981; cv=none; b=AkidX9ZsODVobbWxq3l7VT9OVHe7uk7EAQQlb7D/xy6bt4y/DnCgJXwViabHBaXVl3plmx5+0EAq53C9c2pNhhVVk2bkeI2iYoSO7tXdaJK+aOMcTLIwxv/PQ7DOWusygzL0a+WdGLuTKJut6Mb09ZGyPIRkqN2j+Z9ls5CpCso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255981; c=relaxed/simple;
	bh=o34LgHoxWwvOzm15PJM5pBcal5JYriaDHclVo6JVr8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3CcpNwXsghY1IMNRyTWQyjsVixzbYaqjVUgTgII/JDCTIsNCIvNG3323gR1HlJYzEghvCxyVzVP/2qbRIsjo5g3QvCj71YWVN2wj1nlmWfQvCPrev8G8cFc5UZmStvmuCCEDY/qlIs4Gz0WOWuKSttxPSbwQgxzkNKbSEHS69k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAgUx5Yv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAgUx5Yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6DCC4CEF8;
	Thu, 27 Nov 2025 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255980;
	bh=o34LgHoxWwvOzm15PJM5pBcal5JYriaDHclVo6JVr8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAgUx5Yv+rg0Cz0aUh0RlgHUdNYwtgReiE8GnMPBbuIofMjPV8dxWZNKd/unpUbno
	 HYBxmVB7nSTFvrp14zrVvUKjeFB4ecQ5EYzmrfxH0FAoAc5vgs0U62YRI6B1ca4Lml
	 sX8sKBjKo6U7zcunmFsnQ2PaOOTmajoH/BIhwPhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.17 174/175] sched_ext: Fix scx_kick_pseqs corruption on concurrent scheduler loads
Date: Thu, 27 Nov 2025 15:47:07 +0100
Message-ID: <20251127144049.312367820@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

commit 05e63305c85c88141500f0a2fb02afcfba9396e1 upstream.

If we load a BPF scheduler while another scheduler is already running,
alloc_kick_pseqs() would be called again, overwriting the previously
allocated arrays.

Fix by moving the alloc_kick_pseqs() call after the scx_enable_state()
check, ensuring that the arrays are only allocated when a scheduler can
actually be loaded.

Fixes: 14c1da3895a11 ("sched_ext: Allocate scx_kick_cpus_pnt_seqs lazily using kvzalloc()")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4632,15 +4632,15 @@ static int scx_enable(struct sched_ext_o
 
 	mutex_lock(&scx_enable_mutex);
 
-	ret = alloc_kick_pseqs();
-	if (ret)
-		goto err_unlock;
-
 	if (scx_enable_state() != SCX_DISABLED) {
 		ret = -EBUSY;
-		goto err_free_pseqs;
+		goto err_unlock;
 	}
 
+	ret = alloc_kick_pseqs();
+	if (ret)
+		goto err_unlock;
+
 	sch = scx_alloc_and_add_sched(ops);
 	if (IS_ERR(sch)) {
 		ret = PTR_ERR(sch);


