Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D1A355024;
	Tue,  6 Jan 2026 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720232; cv=none; b=JFv+9dprks5PR9KT24nRuD5XOC9GUxwftZ1A1XHyyQPp28XAtpIAe/bFjpQqGsyukGvmwz1KH+avj5aOC854EAO5TVr5gK5HuKpIKtSzTmZxaGxtzVxvAkmDtxf8J5TR/B7dCN3pJlPuQPGuqD19HwzxrERSS6LxifniBCEyVP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720232; c=relaxed/simple;
	bh=ESZwAcv1LlGh+4SiselkyIIJWrqR+5NX1VOpEArAUhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lfb7LnRzytWB0OzN1Vk0xS6Yd+d2URXlAIgFxWhUvk5uBGCsrcR7yRRztgkWkgYQsyPw/bARVBhmhYYnf2TbpvnjSj6S+BAYv86MvmtfyOCbXL0fB7mggiOZkGaBtXXj5uPqhrHZV3MaBStcHUUW6LRE6qfxdq6RANrWEHGJfnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P02S7Sxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P02S7Sxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF36C16AAE;
	Tue,  6 Jan 2026 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720232;
	bh=ESZwAcv1LlGh+4SiselkyIIJWrqR+5NX1VOpEArAUhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P02S7Sxsyo0AELwakPGZMx9a7Jju1XdDWQrcz3Tt8srhay6xAiUgTo5GLKfrU2wyc
	 bAcqdiNuT+HnpXaY93Qi6D1Bk9QMuW3pTVyMWye1Oi4mX6TraCcckHny9jfwOXj+1U
	 78V17pIJ2Vv0rcCKijzWQKlBHgsMxcKTBg5X4xZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/567] libperf cpumap: Fix perf_cpu_map__max for an empty/NULL map
Date: Tue,  6 Jan 2026 17:58:44 +0100
Message-ID: <20260106170456.579215292@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit a0a4173631bfcfd3520192c0a61cf911d6a52c3a ]

Passing an empty map to perf_cpu_map__max triggered a SEGV. Explicitly
test for the empty map.

Reported-by: Ingo Molnar <mingo@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/aSwt7yzFjVJCEmVp@gmail.com/
Tested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/cpumap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
index cae799ad44e1..e5938b91199f 100644
--- a/tools/lib/perf/cpumap.c
+++ b/tools/lib/perf/cpumap.c
@@ -409,10 +409,12 @@ struct perf_cpu perf_cpu_map__max(const struct perf_cpu_map *map)
 		.cpu = -1
 	};
 
-	// cpu_map__trim_new() qsort()s it, cpu_map__default_new() sorts it as well.
-	return __perf_cpu_map__nr(map) > 0
-		? __perf_cpu_map__cpu(map, __perf_cpu_map__nr(map) - 1)
-		: result;
+	if (!map)
+		return result;
+
+	// The CPUs are always sorted and nr is always > 0 as 0 length map is
+	// encoded as NULL.
+	return __perf_cpu_map__cpu(map, __perf_cpu_map__nr(map) - 1);
 }
 
 /** Is 'b' a subset of 'a'. */
-- 
2.51.0



