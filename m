Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9EF26982C;
	Sat, 12 Sep 2026 07:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199732; cv=none; b=OCYV1hecvEbGACczRgwHBIcYaxbzzIN2PIdXhl5RZFwjXyafybsWWtOmo376gEdL/oJ+3pnxETg9I/3tneCXOkCX7enWJA0khoct+tsrf6loleSms4euyNgPEewLEx8d2nLlQQkqbO8ZY0YgavwxbIxQRvC/I5Cbif17v5YDYdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199732; c=relaxed/simple;
	bh=q66XopmC4D5eV579DtlJwrHjYXlI9yApzCwvLxBsEPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQe6kdP8/NmCf8E/lmBbE2KRVmo1lyDXAlQfTNjKd7dNqCkUUk7a7Xos1TMcg2BNjWaLsFGv7Z81Ijx6CBQhxVXsmN9jyjr4hQ0y7PClZzhJfVgVoESVoiMMFiECgixrHhy+e6hvhWBVYuspjnQrKlNKt9Auzouc+NYrmLIDH64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCf7sTTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCf7sTTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717FB1F00893;
	Sat, 12 Sep 2026 07:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199731;
	bh=/VdpiBVy4ijZd1kfgkF5aF81NrALEx2Iq6lT9SIa+3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCf7sTTcvKxw+HZ6CldexrRF1u1KfgibJ0oLDQpQnZgQZsX9G4APH7dmheh+9jnVG
	 FfsrH2FpFpKGDlJOEuKmaxQSyUp5O4/ubtBe9ktsEe2OqLgGfWu/2DT4T62hrF0Y8/
	 JZUuELdTOrpvBsfh94yz9FnEPQCxRqXCrpig62eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0646/1815] bpf: Fix CFI mismatch in task work callback
Date: Sat, 12 Sep 2026 08:39:56 +0200
Message-ID: <20260912065704.047538539@linuxfoundation.org>
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
index c18f1e16edee4..88b38db47de92 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4388,7 +4388,7 @@ struct bpf_task_work_ctx {
 	struct bpf_map *map;
 	void *map_val;
 	enum task_work_notify_mode mode;
-	bpf_task_work_callback_t callback_fn;
+	bpf_callback_t callback_fn;
 	struct rcu_head rcu;
 } __aligned(8);
 
@@ -4471,7 +4471,8 @@ static void bpf_task_work_callback(struct callback_head *cb)
 	key = (void *)map_key_from_value(ctx->map, ctx->map_val, &idx);
 
 	migrate_disable();
-	ctx->callback_fn(ctx->map, key, ctx->map_val);
+	ctx->callback_fn((u64)(long)ctx->map, (u64)(long)key,
+			 (u64)(long)ctx->map_val, 0, 0);
 	migrate_enable();
 
 	bpf_task_work_ctx_reset(ctx);
@@ -4594,7 +4595,7 @@ static struct bpf_task_work_ctx *bpf_task_work_acquire_ctx(struct bpf_task_work
 }
 
 static int bpf_task_work_schedule(struct task_struct *task, struct bpf_task_work *tw,
-				  struct bpf_map *map, bpf_task_work_callback_t callback_fn,
+				  struct bpf_map *map, void *callback_fn,
 				  struct bpf_prog_aux *aux, enum task_work_notify_mode mode)
 {
 	struct bpf_prog *prog;
@@ -4619,7 +4620,7 @@ static int bpf_task_work_schedule(struct task_struct *task, struct bpf_task_work
 	}
 
 	ctx->task = task;
-	ctx->callback_fn = callback_fn;
+	ctx->callback_fn = (bpf_callback_t)callback_fn;
 	ctx->prog = prog;
 	ctx->mode = mode;
 	ctx->map = map;
-- 
2.53.0



