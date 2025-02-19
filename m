Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570AD1AF0C8;
	Wed, 19 Feb 2025 09:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956224; cv=none; b=nyvxbPk/S1N4TNaTZNnQ47pId+W0AuXgZ9BzRLtncQEL1xak+ZF0YusIWUOeKnOQ3OkyzxeRZw3ClRN0R74hCIcBisJa/daRgT8n1qN2jt7aVhX4v8iT9v8NnfcAig8ZAZebwRPu//A06WRku35pKCo6wjN5k/HMUCegjQemQAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956224; c=relaxed/simple;
	bh=e9yVtp4N4U0gLz/HoVHaG/c3YbV3zF6LQyZ9eSF0Xh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaaANZBED86KsLkkvh5YZJgeF88capdUI+bsmX/6zdP9gx8UIuE8Xy15QUrsMM0qYLQlvdJ5GVYfW/1cvQeD8iUqbLq5IY0Vgyv6c7rs+WyNbHKIsn44y+Idt9rD4nBs7eueIYDeK/g9JbV4Av2CZ4ROc1/64/t8YgghPp0sEeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIfO8zwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIfO8zwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5383C4CED1;
	Wed, 19 Feb 2025 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956224;
	bh=e9yVtp4N4U0gLz/HoVHaG/c3YbV3zF6LQyZ9eSF0Xh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIfO8zwNUu2GNa2PKRieQ5DeUqqRlb8gYcWgjHHCldXk59Jp8ESumvA9BYMJTP/ta
	 S8GJ/RX693Q+FFwA76pjBC9EG3TGvWBUy0Lpj8cYrQ8SVJCuSwvERneSdX+TKAtjO4
	 etwTwOMZZwDOzz+Wo/s4NcdhftVnD23+O03jX3d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <song@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/578] perf header: Fix one memory leakage in process_bpf_btf()
Date: Wed, 19 Feb 2025 09:21:50 +0100
Message-ID: <20250219082657.142824976@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 875d22980a062521beed7b5df71fb13a1af15d83 ]

If __perf_env__insert_btf() returns false due to a duplicate btf node
insertion, the temporary node will leak. Add a check to ensure the memory
is freed if the function returns false.

Fixes: a70a1123174ab592 ("perf bpf: Save BTF information as headers to perf.data")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20241205084500.823660-2-quic_zhonhan@quicinc.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b2b0293567f07..c4c8a04f3acad 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3183,7 +3183,8 @@ static int process_bpf_btf(struct feat_fd *ff, void *data __maybe_unused)
 		if (__do_read(ff, node->data, data_size))
 			goto out;
 
-		__perf_env__insert_btf(env, node);
+		if (!__perf_env__insert_btf(env, node))
+			free(node);
 		node = NULL;
 	}
 
-- 
2.39.5



