Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02931FBEB0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301927; cv=none; b=jDr61F27wnBnBMC1iz0K1Dti2bF7a2E8KAEgSoDdWmNvW7BcEmzFDe6oEfVwVdzxA/FPMWYYgIGY2hv3jycPmq23WtdsOYVMMJSIrZilJGrnEiotyNJvIjRC97+HgveatZW+FSp78yDXek0EBVYH1h6HyZHXFVibmd8s2gkZFj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301927; c=relaxed/simple;
	bh=9WghuBAcQ6cONzRHyPpQmgq22aZBPVFaISJzqkpU7rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKGa0+q7CsVEN28ZS4W3eOAxV+RuXI/ZXphKHCnNfuGTkPX0IfUGh8eF0+JCQJLD09pLAo9V3vUinUaoN/5e7mwyQaxaT3B5Zdajd8uyWXRR5L9sfeka5yeiqvZnRgarRFB899bhRhX2M8+84LPB9Pb8i34Zu0zikiAAhrvDyOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SErXqBt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SErXqBt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C3AC19424;
	Sat, 28 Feb 2026 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301927;
	bh=9WghuBAcQ6cONzRHyPpQmgq22aZBPVFaISJzqkpU7rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SErXqBt+wDdjXhk4PIMwCxGqy0x/A6YzHr5duANSNy7Xt2RKlI9GOwy7CEmfOcV04
	 TehcDfjCAPmD+yhB7Wbds2GLfb3Iwl9yPnv4egfuiua/M8N3MUx0HX5Rs9aBCbLVbT
	 8fgmz9cuHhA+SApG/fBd6ZZrmBzs3U59yOyVpGhwd/Fh25uN0oufRMm2qyKMdJ7OpZ
	 l09tazxdjUUR3DXbfULwVzyz6p1qNp6H8fBltKS/DLnlksd2WkXOj1FPsSW/GYwh9W
	 sSMlUmR+kCDuJx0UmRCRIWLIV+rK0iI3Ye4AVjin1gm6+lxUkHMUqtCcTNQtej1S3P
	 hqxs++5wZubzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: zhouwenhao <zhouwenhao7600@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Matt Wu <wuqiang.matt@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 362/385] objpool: fix the overestimation of object pooling metadata size
Date: Sat, 28 Feb 2026 12:59:44 -0500
Message-ID: <20260228180011.1568201-362-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: zhouwenhao <zhouwenhao7600@gmail.com>

[ Upstream commit 5ed4b6b37c647d168ae31035b3f61b705997e043 ]

objpool uses struct objpool_head to store metadata information, and its
cpu_slots member points to an array of pointers that store the addresses
of the percpu ring arrays.  However, the memory size allocated during the
initialization of cpu_slots is nr_cpu_ids * sizeof(struct objpool_slot).
On a 64-bit machine, the size of struct objpool_slot is 16 bytes, which is
twice the size of the actual pointer required, and the extra memory is
never be used, resulting in a waste of memory.  Therefore, the memory size
required for cpu_slots needs to be corrected.

Link: https://lkml.kernel.org/r/20260202132846.68257-1-zhouwenhao7600@gmail.com
Fixes: b4edb8d2d464 ("lib: objpool added: ring-array based lockless MPMC")
Signed-off-by: zhouwenhao <zhouwenhao7600@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matt Wu <wuqiang.matt@bytedance.com>
Cc: wuqiang.matt <wuqiang.matt@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/objpool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/objpool.c b/lib/objpool.c
index b998b720c7329..d98fadf1de169 100644
--- a/lib/objpool.c
+++ b/lib/objpool.c
@@ -142,7 +142,7 @@ int objpool_init(struct objpool_head *pool, int nr_objs, int object_size,
 	pool->gfp = gfp & ~__GFP_ZERO;
 	pool->context = context;
 	pool->release = release;
-	slot_size = nr_cpu_ids * sizeof(struct objpool_slot);
+	slot_size = nr_cpu_ids * sizeof(struct objpool_slot *);
 	pool->cpu_slots = kzalloc(slot_size, pool->gfp);
 	if (!pool->cpu_slots)
 		return -ENOMEM;
-- 
2.51.0

