Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFE73DDAFD;
	Wed, 30 Sep 2026 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787449; cv=none; b=NURwFvWQwkUfuz3Xdg+Ew8nyTjKNe8RAb1XFnXwVr9v06ckYc62r5JnFdnIgD8ZHYc0SDTMvSW6S0BT9wT1gqsfZi+UQmCrNuF5Oz4mTmRXeFZvuPCctnjTU6YZIpA+4x7nBPLr4oXPfXHiDIGIhTmEH87X/PtV+1DDDXfFXvw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787449; c=relaxed/simple;
	bh=jsNpTwDCn0nfBrYqI0fOfJ9AI5GByY4R4oMSeP3a1Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWVIIaKhHgqLEheQcKOuZcy/yiiV1jsksTq9Jd+9NwGoUpLn15H0ZUDGbznzuTaZO9SkWPxzVNYwXsxO2TO9N/1xpQnNg8RvhUWjPGShlfYD/OC5bfy3wlVKHJwV1B3r2CBphC5LQ3cPGHc1UwJBEBZaW6edWWVbgMbn4+4vDSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUhqmwBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUhqmwBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875431F000FF;
	Wed, 30 Sep 2026 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787448;
	bh=+ZX1+KoX0Y6CThCd4PyocOCCiw6jPhXDBvuU4L9WBJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUhqmwBjU5CCNIjoMPROWMUBlIGd4yuze5gVBvQKNm7QhIClTWbJc8WI2aoEsacsz
	 hO3dvm1G+1IgTax1QMwUNc++ZjJ5opvEG4u1gFPqvg3OayQn9Ii0+Bhx5ajId0i34G
	 tfHJ2B+F3SS4HBVGOccImHsKVrPtLHCUmy6WTNvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 233/457] perf/core: Fix a refcount leak in attach_perf_ctx_data()
Date: Wed, 30 Sep 2026 17:25:38 +0200
Message-ID: <20260930152351.072433244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index 60e60809bedc7..866c595321868 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5454,6 +5454,8 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
 		}
 
 		if (refcount_inc_not_zero(&old->refcount)) {
+			if (global)
+				old->global = true;
 			free_perf_ctx_data(cd); /* unused */
 			return 0;
 		}
-- 
2.53.0



