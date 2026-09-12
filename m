Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D993A0B36;
	Sat, 12 Sep 2026 08:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201544; cv=none; b=IGz4gPWv0L+6CmOahe2YVRJy1oWD+2LwbzkTnAG+YDP9OSqgKvxYju68Zs0yz15sHPL97jFgZHZmnKdpl0n22KIPK1Mi9HLRIjK4cQOtDNUwBZg9bAEBYap/RfbhVttMdi0dVXWiwZrH02LXPGOV2yttFVrS228ejxsab7t3iqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201544; c=relaxed/simple;
	bh=PqSBMMoTr523l6Bf7czLhtVpsJ6ONJx2LKwpMRnLZps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw+5j1e5bGLeeMITGBrA6XVHFX0cA4YDSfpJVW4CUu+n/oFixj9oQEXNXlQJiHOBtql56TVLK0loKPHya1Rk/vrBALMKJy/2xt3d/ZmK0bPevo2dQPLQG3TIUQS3OZwmZ/xzi0GkQLZb22n6DTqm3ajZm/bYWNNRKTL8aXwMdmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4Htdxor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4Htdxor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6658D1F00899;
	Sat, 12 Sep 2026 08:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201542;
	bh=tqyORYogv1lQdL6OHWuNLIaJn5CZx3vEBFa17nAZcT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4HtdxorhiXzo0x7a6HR8o1TL51sPJSCQBx/l4tOSOXsJeFfiSIcb43sVnjaT3qfu
	 wlZ7N8KRPhUR7g6STzqbIhGI35QiORILkOTcDQl1N620lU2AUmdwoiKhjgbhk+tvlL
	 qxQfZ1awFpcO4u7ROrm/gMAzdNRXWYWY7yVy4vrw=
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
Subject: [PATCH 7.2 1018/1815] perf thread-stack: Fix heap buffer overflow on branch stack wrap copy
Date: Sat, 12 Sep 2026 08:46:08 +0200
Message-ID: <20260912065712.910580823@linuxfoundation.org>
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
index c5ce741b07446..1360f44421ef8 100644
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



