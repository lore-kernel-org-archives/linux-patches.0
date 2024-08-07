Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB81823CE;
	Wed,  7 Aug 2024 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042904; cv=none; b=Ce1fGrm9nFb7UhgNSG5kIWIhJkHfvo/D1la9NkBkuFrB2UE0pPYjQ/vDhxUkzmBOsB8+pCyIM+VplvG7yXfQuygaCVFkg/gq/xSySVffAPXpVMvkD3GqXM0gFjLevIGk8VjAT5YWp1CEp3M/HkrJsGUEonm1qzfzxkkifiyBQDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042904; c=relaxed/simple;
	bh=a+J/kI3WB7Jyscp9u8lxWa2CXmiYs0iITC10kYq0j6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSaSFCeSHQARGactN49GrrvV0gEK2M97fitoR3+AW4xa6GMRZCtF9/9YGgC1J0CNksawzhMyhcoTrXxBTie70uX6jJClt3/IJk5PuIZT+JUOuSNO1dcJYCVKPp169xmxLrt8FOV1dZrcVxdzUK3rOWVlSg5vDihaRSSBhAgTPfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEgm4k/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEgm4k/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCFBC32781;
	Wed,  7 Aug 2024 15:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042904;
	bh=a+J/kI3WB7Jyscp9u8lxWa2CXmiYs0iITC10kYq0j6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEgm4k/GP0ZRqQBTf3lOSm09fQ+6I4WTqcQIQOkRsmVctp1+CX/PZtrBKZVhIkjYV
	 gky3Bs9K9aQhmonFuDNudGgcvOCs0axmBCLu4M8kb04k5xjJoxsWuIWB06gVaczIg3
	 XpKG9huJRNKnMzDugIE66bBFiytT1LBYSsCTcqSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Chen <cachen@purestorage.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	yzhong@purestorage.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 019/123] perf tool: fix dereferencing NULL al->maps
Date: Wed,  7 Aug 2024 16:58:58 +0200
Message-ID: <20240807150021.441970732@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Chen <cachen@purestorage.com>

[ Upstream commit 4c17736689ccfc44ec7dcc472577f25c34cf8724 ]

With 0dd5041c9a0e ("perf addr_location: Add init/exit/copy functions"),
when cpumode is 3 (macro PERF_RECORD_MISC_HYPERVISOR),
thread__find_map() could return with al->maps being NULL.

The path below could add a callchain_cursor_node with NULL ms.maps.

add_callchain_ip()
  thread__find_symbol(.., &al)
    thread__find_map(.., &al)   // al->maps becomes NULL
  ms.maps = maps__get(al.maps)
  callchain_cursor_append(..., &ms, ...)
    node->ms.maps = maps__get(ms->maps)

Then the path below would dereference NULL maps and get segfault.

fill_callchain_info()
  maps__machine(node->ms.maps);

Fix it by checking if maps is NULL in fill_callchain_info().

Fixes: 0dd5041c9a0e ("perf addr_location: Add init/exit/copy functions")
Signed-off-by: Casey Chen <cachen@purestorage.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: yzhong@purestorage.com
Link: https://lore.kernel.org/r/20240722211548.61455-1-cachen@purestorage.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/callchain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 1730b852a9474..6d075648d2ccf 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -1141,7 +1141,7 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
 int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
 			bool hide_unresolved)
 {
-	struct machine *machine = maps__machine(node->ms.maps);
+	struct machine *machine = node->ms.maps ? maps__machine(node->ms.maps) : NULL;
 
 	maps__put(al->maps);
 	al->maps = maps__get(node->ms.maps);
-- 
2.43.0



