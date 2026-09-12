Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21A0423EB9;
	Sat, 12 Sep 2026 10:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208212; cv=none; b=Hcefd3UpFYBA6X/rBbeS0t5Hj8GocHYsItOzZZjS3szodNa5bFuYHZZYBlmf0jkuzVYiCEoO/4dhX7jcF1wCMo41gPVW7cpAcucwm5Cw4Q/7EPacU8T53U9VivtnNRr7wK0xp05dpf7wbI1Eg2tPqDyG9ixyQ9y6oVt+cfNCgJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208212; c=relaxed/simple;
	bh=8jiO7ziXxDoWSYZzRDUmUTal2G30Eal7llMfYR2pjrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkWn5oO3WQjvGx+k5UuJOeR02Ggl2vISGX+Shtm0iYFg0giQC4c9PhPBufzck2mAjnT/8FlmDveNB9SEiD8rz3Y2/tjCMRFAiw4HeDLZQVF5BkyQaTnWlul+0d3q27SNaDsCArukOibmqdFwN6kS63Wp9YJ3h+etZmHjutDDVI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhiRDoG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhiRDoG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E3F1F000FF;
	Sat, 12 Sep 2026 10:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208206;
	bh=/4CfwEzVDpRD/wgSeUPlZV7f0xkOxu5lvmBp8ZQq1ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhiRDoG8o83GPnODcSA3Z8hnM/ZxE71SCiJpU2OG/5XDbSRGQyUS1SQyABpIXmrkA
	 DNlsCj7SkKDgZKfM3PHXyHJT2BWCFm45uPEwJTfRvscCLKzg76qDitfQqa6T5VhjVY
	 JYDonwfo6xadDarJWGwV7vKtXfJh0oieRrIwqwYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0571/1518] bpf: Fix CFI mismatch in task work callback
Date: Sat, 12 Sep 2026 08:45:40 +0200
Message-ID: <20260912065636.348175369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 2805abd089576799b15092949420e3f8ba97fabd ]

BPF subprograms use the bpf_callback_t ABI, but task work invokes the
callback through a three-argument function pointer. This trips kCFI.

Store and invoke the callback as bpf_callback_t.

Fixes: 38aa7003e369 ("bpf: task work scheduling kfuncs")
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://lore.kernel.org/bpf/20260724-task_work_cfi-v1-1-2616691781ed@meta.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5aed5659822f1..72757f7290ec2 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3960,7 +3960,7 @@ struct bpf_task_work_ctx {
 	struct bpf_map *map;
 	void *map_val;
 	enum task_work_notify_mode mode;
-	bpf_task_work_callback_t callback_fn;
+	bpf_callback_t callback_fn;
 	struct rcu_head rcu;
 } __aligned(8);
 
@@ -4035,7 +4035,8 @@ static void bpf_task_work_callback(struct callback_head *cb)
 	key = (void *)map_key_from_value(ctx->map, ctx->map_val, &idx);
 
 	migrate_disable();
-	ctx->callback_fn(ctx->map, key, ctx->map_val);
+	ctx->callback_fn((u64)(long)ctx->map, (u64)(long)key,
+			 (u64)(long)ctx->map_val, 0, 0);
 	migrate_enable();
 
 	bpf_task_work_ctx_reset(ctx);
@@ -4148,7 +4149,7 @@ static struct bpf_task_work_ctx *bpf_task_work_acquire_ctx(struct bpf_task_work
 }
 
 static int bpf_task_work_schedule(struct task_struct *task, struct bpf_task_work *tw,
-				  struct bpf_map *map, bpf_task_work_callback_t callback_fn,
+				  struct bpf_map *map, void *callback_fn,
 				  struct bpf_prog_aux *aux, enum task_work_notify_mode mode)
 {
 	struct bpf_prog *prog;
@@ -4173,7 +4174,7 @@ static int bpf_task_work_schedule(struct task_struct *task, struct bpf_task_work
 	}
 
 	ctx->task = task;
-	ctx->callback_fn = callback_fn;
+	ctx->callback_fn = (bpf_callback_t)callback_fn;
 	ctx->prog = prog;
 	ctx->mode = mode;
 	ctx->map = map;
-- 
2.53.0



