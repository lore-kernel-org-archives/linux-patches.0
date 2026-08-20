Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977E436A37A;
	Thu, 20 Aug 2026 15:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238621; cv=none; b=YKRB5axk4w2tbfVDHn/6paJFjzi/NAwX7Est7kutNw+fvHjGi5ENcV1YmA92KCfRG7W7ntOsjaanIhyBgjv+0e/Hq/HY88ZzyGmGGhAfVl8xVMLsFuXtjzneOJPdmdyV2+3n+24Mu1IbBR216my9dOx1sx3CRGpE5sLS5Y+QTTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238621; c=relaxed/simple;
	bh=eHuIzfZZgGhzU9UjvYFSDUH/b2nEToEG0jBTqQKvKSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=myQylP1k34kLmz/7wGNeYqAOZzhy4c7liubjctsBZ4IzvxH73hj4QEx+HXC0xEdAkXj/Sht32P/10VEc5vK750CPpDhCHRlTEhXQNjdwos08b8LOKDL7w6Qd6VtybqUxRxLFXUWUC70jX4214mFpDBm5/HqwU1NeY90NJdRR7l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xejfWH5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xejfWH5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CFC1F000E9;
	Thu, 20 Aug 2026 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238620;
	bh=7RphpMBHJsKGi5YPYKltw1fAExgWhoFL9MWxZXfuQoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xejfWH5t1PMxy0AMXSstLCiC1hB5uAYJc4B9jVTxxhoNrAsrbmobo+oXk+UUTQ0Ze
	 UneoqPtLNbkm/TLNtwR384dQPqXm48NQ0IpaJmnjLq1/Dqv8iy/dGO0VmGgr5m9KCI
	 HvvylOYkD3WN3Bn7nP/fNPVPXg04qX5PxWbvdZ6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 211/228] pid: reject allocations through dead ancestor pid namespaces
Date: Thu, 20 Aug 2026 16:55:53 +0200
Message-ID: <20260820145251.445564130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit b64a9f67e082e04835ddd69d422a25168d69375b ]

alloc_pid() checks PIDNS_ADDING only on the leaf pid namespace before
making a new struct pid visible in every ancestor namespace. That is
insufficient when an unborn descendant pid namespace outlives an
ancestor whose init task has already exited. The descendant can still be
initialized later through setns(), and the new pid is then published
into the dead ancestor as well.

Keep the existing ENOMEM behavior, but require PIDNS_ADDING to be set in
every namespace that will receive the new pid before publishing any of
them. This preserves the invariant that free_pid() never decrements
pid_allocated in a namespace whose child_reaper is no longer live.

Fixes: a3bdc23ba8ea ("pid_namespace: allow opening pid_for_children before init was created")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/pid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index f55189a3d07d4..d01d0dd7114b2 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -324,8 +324,10 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	 * error path may try to wakeup the possibly freed ns->child_reaper.
 	 */
 	retval = -ENOMEM;
-	if (unlikely(!(ns->pid_allocated & PIDNS_ADDING)))
-		goto out_free;
+	for (upid = pid->numbers + ns->level; upid >= pid->numbers; --upid)
+		if (unlikely(!(upid->ns->pid_allocated & PIDNS_ADDING)))
+			goto out_free;
+
 	for (upid = pid->numbers + ns->level; upid >= pid->numbers; --upid) {
 		/* Make the PID visible to find_pid_ns. */
 		idr_replace(&upid->ns->idr, pid, upid->nr);
-- 
2.53.0



