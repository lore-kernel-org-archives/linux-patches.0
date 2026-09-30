Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB1851E445;
	Wed, 30 Sep 2026 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793289; cv=none; b=l5LPKKEYv38FL7pO91+Kc3kLYF/Gx6vb+Q74wgajiJV/mY1R/L6mDBbB4XQX0W3oVQyTcKBwcBVAqyclOo33n5DWH9l3slxy1XOfHIbN7Rhdh4JKC/Yxb8hJ27WhBywvBweYMyV9Jx9Xmp9HRho5RtKOCGDchF/2JECzmQbyu44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793289; c=relaxed/simple;
	bh=9ZebHdTxlhkWJtJvMO49YPVfDEVi02Wv9rKWoK8dEy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/RTSIIxkR+0lWpa1KvAlRQe/9bY7z49VIDfIVsneXGGlkcJzsSvMRX9rwDSm4RWuKoDHTO2U1mUXQqDYMF0YJNR1dFI1bBjP3pl0COwGhalOjFhA5rKGCbrmqdYE6uOaLH+luRGfPaIxjbcZMKMUJoTJKS9ndNZJ6RYoObJBKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfS6frzB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfS6frzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9D81F000FF;
	Wed, 30 Sep 2026 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793288;
	bh=Oqm7VouQfNCq/ouHn4Y4SI2Wy2YatmMQy90hJMiTlN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfS6frzBjn8M8zzgFTiM3nthCMnYOwKITsrWqXy3uBm9rGx99R5sBVZ1ZYQKIBRoS
	 heEXDPBLhMlbUa8x5UM5of1CI22m2lORbOgULrO2YtbmRUreL3JoiIVCOtAreuuvaS
	 dOeUlVaI8nHgxRDBC/6g4E1kslDiUe8tUAQtmYuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/395] perf/core: Fix a refcount leak in attach_perf_ctx_data()
Date: Wed, 30 Sep 2026 17:27:43 +0200
Message-ID: <20260930152345.009907141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit cca4980630b3c7a85f53cb43c6018184ce5d4e37 ]

The attach_perf_ctx_data() can race on global and !global cases.  The
global case is protected by global_ctx_data_rwsem and shares a single
reference count using perf_ctx_data.global field.

But when it races with !global case, it may miss to set the global field
and result in a reference count leak.

 CPU1                                  CPU2
 ----------------------------------------------------------------
 attach_task_ctx_data(.global=1)       attach_task_ctx_data(.global=0)
   cd1 = alloc_perf_ctx_data();          cd2 = alloc_perf_ctx_data();
                                         //    { .global = 0, .refcount = 1 };

                                         try_cmpxchg(); // success,
                                         // task->perf_ctx_data = cd2
   try_cmpxhg(); // fail; old = cd2
   refcount_inc_not_zero(&old->refcount); // success
     // old.refcount = 2
   free_perf_ctx_data(cd1);

Then later detach_global_ctx_data() will see the data but it's not
marked as global, so it won't call detach_task_ctx_data().

Fixes: 506e64e710ff ("perf: attach/detach PMU specific data")
Assisted-by: Sashiko.dev:Gemini-3.1-pro
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260920231639.11910-1-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ad52e4bda8ff9..bcb4f34f3f0aa 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5311,6 +5311,8 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
 		}
 
 		if (refcount_inc_not_zero(&old->refcount)) {
+			if (global)
+				old->global = true;
 			free_perf_ctx_data(cd); /* unused */
 			return 0;
 		}
-- 
2.53.0



