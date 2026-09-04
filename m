Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53719416878;
	Fri,  4 Sep 2026 05:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499427; cv=none; b=fQM/794BTW+fAZxf0ytXgyfrshbrzSnyK81XH0C/7m2SzKx49W4NOqvtl81xIhNPvGUhmP+9JUrePK4BcLuvpYu7AUA4cUYGLhsHY/v1pPvrBh/UB9G617VS+8zjSB+JykBO3Eq+o2WNb5FLF535UwrQ3Jw3rzibEiXNr06uwL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499427; c=relaxed/simple;
	bh=L2Bn/XsA+denyxAdrrs8TnbGeKOhfp4GSXk50DudmA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3X6xmHePrK9UF/MnLKJdVa+3RH0Vg38X7pmIwxgnt+FrJMyDDZU6WQjhhd/rc/xuzE7DcEDCbm1Vx8oD6IQ/wEYMhYizZc2C96EMnOnnpj/qmyexo6/xLPFZMvSpo9KMcT4MUWPFLdtXEkw8Rv2hbDd2hEB9UGwDM88XvSHvp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7BebXiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7BebXiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6D31F00A3D;
	Fri,  4 Sep 2026 05:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499426;
	bh=h9SwxUOwabjaI50aNkP0Xj4LPEK37k4BRG6gPZyxDxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7BebXiWegW2zEKkU1KR0k8LwrRvTZmUiIKP0lrlgo2BtfhGzHqj93A6DC+sHH1pg
	 LTxECjR4TUp1g6RnUkwxbGCr1q30cdC9YV2qunyz5iGwFs7CTpIWSHN2cKmguypp89
	 T8552O8In4vjhPLA5PxFcnFIqBf3cWqe0jPjqGl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fangqiurong <fangqiurong@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 414/713] sched_ext: Fix exit_task leak on fork failure during enable
Date: Fri,  4 Sep 2026 06:56:22 +0200
Message-ID: <20260904045813.109407537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: fangqiurong <fangqiurong@kylinos.cn>

commit 03506edca637a8465dba9f635c50e9884fbcaf4e upstream.

scx_fork() initializes tasks when scx_init_task_enabled is set, but
scx_cancel_fork() only exits them when scx_enabled() is true. A fork
that fails in the enable window (between releasing scx_fork_rwsem and
setting __scx_enabled) runs ops.init_task() but never ops.exit_task().

Gate scx_cancel_fork() on scx_init_task_enabled.

Fixes: 4269c603cc26 ("sched_ext: Enable scx_ops_init_task() separately")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: fangqiurong <fangqiurong@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3988,7 +3988,7 @@ void scx_post_fork(struct task_struct *p
 
 void scx_cancel_fork(struct task_struct *p)
 {
-	if (scx_enabled()) {
+	if (scx_init_task_enabled) {
 		struct rq *rq;
 		struct rq_flags rf;
 


