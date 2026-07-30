Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B74743E48D;
	Thu, 30 Jul 2026 14:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421387; cv=none; b=sB+pnp3k/OHVQ31zV16J7g8cv+aCPN8/CUy0lvjA3QLuMdwH4yIRJjMquumHimfFfbs0qtsci9x18D/L3GQSoV0k+jyXVN5ckWbbUOwEn/OKP9xO2IBc94CPHuZyPR1WnYppUsYoOyqhiDzXzMzzdYZ5ypaVbMY1Yx4kjqBwx6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421387; c=relaxed/simple;
	bh=DR3eR4Y6VrQtgFfwnxdyXZAlHyoGEKK+jnNdaZBHlmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrC2QHtX7dtJUPrVrmVGYmJYbjXWOMAKf4KvC6hCEJxbzG/quI2rEvxsOqvIw2ysq/yt99mJe/Ka694Sf6itz+q97zGY1s+vHyvwTvYLf8ttH51JWi5VrFYqTLODNdfpfRCEYhwiQAvrL5ByqjQ40R9DqOsDuEiYnZb9DGy03eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3V3ROkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3V3ROkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7962D1F000E9;
	Thu, 30 Jul 2026 14:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421386;
	bh=XM7aW9U2bd9PQQrGr0KFBwSLkzVxbb9wmAI4LQ4fGdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3V3ROkc9GGLODIVsRVr68xekuTjl8UW/zwcH5hW5TZB7dgzaTmQ9aGKueOFYuUeK
	 qBrdCOHnWkW0a1aenRazILAPsIZ4cU8YalJDD9MAVFLtmXOsiPjGiNKdCkgzKaR121
	 G/rZpAsGa5DSxWZI7lpYxvsb9Lv3wNGwGBet9H3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 087/744] sched_ext: Record an error on errno-only sub-enable failure
Date: Thu, 30 Jul 2026 16:06:00 +0200
Message-ID: <20260730141446.117377568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit db4e9defd2e8620abee04cfe5809c0bcd6ecf06a ]

scx_sub_enable_workfn() has several failure paths that only return an errno
(e.g. -ENOMEM from an allocation) and jump to err_disable without calling
scx_error(). scx_flush_disable_work() runs the disable, and thus ops.exit(),
only when an error has been recorded, so an errno-only failure leaves the
half-initialized sub-scheduler linked.

Record an error at the err_disable sink so every errno-only failure runs the
disable path.

Fixes: ebeca1f930ea ("sched_ext: Introduce cgroup sub-sched support")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 432c4c68a2c010..46f7b33b565ba3 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -7440,6 +7440,12 @@ static void scx_sub_enable_workfn(struct kthread_work *work)
 	percpu_up_write(&scx_fork_rwsem);
 err_disable:
 	mutex_unlock(&scx_enable_mutex);
+	/*
+	 * Some enable failures only return an errno (e.g. -ENOMEM from an
+	 * allocation) without calling scx_error(). Record it so
+	 * scx_flush_disable_work() runs the disable and ops.exit() fires.
+	 */
+	scx_error(sch, "scx_sub_enable() failed (%d)", ret);
 	scx_flush_disable_work(sch);
 	cmd->ret = 0;
 }
-- 
2.53.0



