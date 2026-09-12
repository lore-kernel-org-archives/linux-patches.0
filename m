Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1CA47ACF0;
	Sat, 12 Sep 2026 12:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217076; cv=none; b=aEq4FaQ0iUf2DifcYVhvXgqlZYYzKxwmZ86acNQbMkbhzCfrtHBTOO75WEEMzt1H9hFS/w/yWr4IVkrjehzIwRiUEtW2r7IvCShmPtyy+qQWB6DNUPBSeNU1YM9oyxW3UmQoJZQ72oXBCQPvqz6GOW/WdctDqcRpI/EoDzUyfoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217076; c=relaxed/simple;
	bh=e1PzIrRKMdfnwcKVetBZrv0CWa45r3HNFTUU4PAVk4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNaDSiVtBFLJwfN07Eak+cRnBfuVJs/IsvmVybfzBwf/3zVfjTqAombVqU/9dxKIVwvVcqVPfxcPUKUnOqrmEvNNMZneq7AiQUuvtQ2WnQUWs9Srv4aCUWP02p/7SvG7dFDax+UGwvTFop56lHxGATLyDnOJiTi15sfb0a/FF2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUUbhQBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUUbhQBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DA71F00893;
	Sat, 12 Sep 2026 12:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217075;
	bh=42nCRhHqMmdsbq79A7a6CJeATppr5U+nE0J5McMXUwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUUbhQBz8IXaS91Qwa2iNX9+YBeV6cQIz4da2/6cftaTPN8pcmBbwoo8Mswq4O8hv
	 L/p8WogsjM8OdWLl9USQn+pk9jHEOr+NyQzALT9A2rx4Qn6fVo6Kvhd7pZC9VQllyU
	 4aoU/FxxSg4BduC8akrNnC2nApqpCOagZEORgJjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0866/1376] perf thread-stack: Fix heap buffer overflow on branch stack wrap copy
Date: Sat, 12 Sep 2026 08:54:52 +0200
Message-ID: <20260912065626.859656520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit ab9c84d1cd59e6b3b73de34982a35a76e3a9b032 ]

thread_stack__br_sample() copies the wrap-around portion of the branch
stack ring buffer with:

  nr = min(ts->br_stack_pos, sz);
  memcpy(be, &src->entries[0], bsz * ts->br_stack_pos);

'nr' is correctly bounded to min(br_stack_pos, sz) but the memcpy uses
the unbounded ts->br_stack_pos directly.  When br_stack_pos exceeds
the remaining destination space 'sz', this writes past the destination
buffer.

Use 'nr' (the bounded value) in the memcpy size, matching the pattern
of the first memcpy in the same function.

Fixes: 86d67180b920 ("perf thread-stack: Add branch stack support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/thread-stack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
index c6a0a27b12c2a..47d5922efdee3 100644
--- a/tools/perf/util/thread-stack.c
+++ b/tools/perf/util/thread-stack.c
@@ -642,7 +642,7 @@ void thread_stack__br_sample(struct thread *thread, int cpu,
 		sz -= nr;
 		be = &dst->entries[nr];
 		nr = min(ts->br_stack_pos, sz);
-		memcpy(be, &src->entries[0], bsz * ts->br_stack_pos);
+		memcpy(be, &src->entries[0], bsz * nr);
 	}
 }
 
-- 
2.53.0



