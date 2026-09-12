Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F0F38F92F;
	Sat, 12 Sep 2026 19:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242962; cv=none; b=j276OrZrgQmup92Pq4ivZb5JYO3gMf+rXIiGL8oUB9Wn+MVyeW2i1OK8n4yWW8wJZLuegPyaH1kp9WBhfHyMTn6Li1D8sJvbzrJSmEz+KuAsfn9iOScyUCcqRZduHc3j7vwI5l7qNq+QyZ4YBWwB52pC7ruu9zIDUUsT/8WoDYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242962; c=relaxed/simple;
	bh=CaiTGsXBBMYsQWDnUZR6d4XiWcBwnx/bhMLn+IvxAYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUX5LZZ+TnoBy5SmuCQQdpBNYY0GHzsL2PuhfJtfIa3tmyunL/hMRxXpfLQqRR3qhVqtsUoD+3SF6ffg3xtIKygR0u5OEsiIwRMGH0J3Jq8rSYKQj5AibrossjEdoksbLFA+3U8dUoZRzwwyEXqptIzNCvw0I3RvZ/v2tARPXbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXEr4+7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXEr4+7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730461F000FF;
	Sat, 12 Sep 2026 19:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242959;
	bh=JnfRRCbKl3+npuawIiNInyeaw8+GivKcIBrXB6A5Qd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXEr4+7ZM6C9kiZr23LFJYboSYkrUHWGeurzHPU2Yayb3KXzN0uni1eD4J8yj2jVv
	 oxbnlYvMia0tkQcOF9rS/TjyRqncSFkMyz5/1W+rv63L4eMtBIgSHqcRJYwrEiQB0x
	 j/kL9in9c55bzb2h0nX/gwEoPlKh54il2jmmZgik=
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
Subject: [PATCH 5.10 586/798] perf thread-stack: Fix heap buffer overflow on branch stack wrap copy
Date: Sat, 12 Sep 2026 09:03:34 +0200
Message-ID: <20260912065530.556049656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1b992bbba4e8e..b1766d62eb718 100644
--- a/tools/perf/util/thread-stack.c
+++ b/tools/perf/util/thread-stack.c
@@ -641,7 +641,7 @@ void thread_stack__br_sample(struct thread *thread, int cpu,
 		sz -= nr;
 		be = &dst->entries[nr];
 		nr = min(ts->br_stack_pos, sz);
-		memcpy(be, &src->entries[0], bsz * ts->br_stack_pos);
+		memcpy(be, &src->entries[0], bsz * nr);
 	}
 }
 
-- 
2.53.0



