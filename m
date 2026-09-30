Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E84C33D1;
	Wed, 30 Sep 2026 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786360; cv=none; b=H9vTgPka4pFUdZSNohwklmJKcHIxdAB/fiCtZKLKV6XOJ6hXVV29wrWRwfy5VVMFJmz8MX+saMhh8mN23+0O/+rv9Rp0ADrjhBNptLFDQuyGHHS03YqP/RcjPRIFxJ/g/H+fBKNEh2rK11LXRSNZ8AaOiR0+722FmXGnEJofeZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786360; c=relaxed/simple;
	bh=Q2Y9UQrnWwVv7Q0jZ2VyrptIkR8XpzvjdHzDUStQ2AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KH3WPr20vs4ihQ4t5V/aJv7Izi1Pwy0ksxgq1Tfm7HDsRec1jyOv7DjTexEYvThdRr2OkecWIFBUYlXHbKT7ytF1WyIZ9tv8OHVq+4sDECXfem0uqSPEtGPTLWNovAR2RceK1YLEpORXcY2Rc8Chc66h9TeArOhFkrhA+in/tJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlIKskRq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlIKskRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1051F000FF;
	Wed, 30 Sep 2026 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786358;
	bh=cR+oSe7zHgvO1fpgr4a8Ld0snFY+FQ2QYIDF+lX6TiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GlIKskRq23b70ySY8wWxkgs62x08T7zLasPUtzulK5c2d9kOFAFCBDWVtUE/c0/2F
	 6YJEl1a0T45b0jolOjD4mLiERda1BoVqXBRLqJsMB7rQUzFsLpuUUGCoBDHUOqMKx/
	 jbbqC5cJk/bku+gmp8CN//PeF/VF74aIYB20yIj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Xiaokun <shinnkka1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 789/982] io_uring/io-wq: Fix memory leak in io_wq_create() on success path
Date: Wed, 30 Sep 2026 17:25:25 +0200
Message-ID: <20260930152433.702822120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Xiaokun <shinnkka1@gmail.com>

[ This is a stable-only patch for 6.1.y ]

Commit 657ca82526d0 ("io_uring/io-wq: inherit cpuset of cgroup in io
worker") was backported from upstream commit 84eacf177faa to 6.1.y.

In linux-6.1.y, this backport introduced a temporary allowed_mask
variable in io_wq_create().  It is correctly freed on the error path,
but is not freed on the success path.  As a result, every successful
call to io_wq_create() leaks cpumask_size() bytes of memory.

This is a 6.1-specific backport issue caused by the differences in the
io-wq implementation, so the fix only applies to 6.1.y.

Fixes: 657ca82526d0 ("io_uring/io-wq: inherit cpuset of cgroup in io worker")
Signed-off-by: Chen Xiaokun <shinnkka1@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 0c3de2fead81c..f1bc212309c81 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1221,6 +1221,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	wq->task = get_task_struct(data->task);
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
+	free_cpumask_var(allowed_mask);
 	return wq;
 err:
 	io_wq_put_hash(data->hash);
-- 
2.53.0



