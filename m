Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD071E0493;
	Tue, 17 Dec 2024 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455888; cv=none; b=d5t84SPMffPCy1ZRcw/kPXf9+mm7ey+0uvf4iIgFoJULf1lczICS7CNtySFEQzsHfAOrfX+NUqgb4JVYszCGoI+rJ+lihyP4c/um9dLx3CY2pfyaUGC19emMRRgVyUh9+mKyuhCyEAiZcA+113STpLc2ss/YBF2RyxW+V7mstag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455888; c=relaxed/simple;
	bh=yPU5n+5gIzaVC6W+CoZvW0/B5EyRJUaubsa2bwfea1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eB84pMJsHL+bar8JSwKRWNTJk0Kgu3oknmNg/MJWgBdguSSyEzPD+50CCCGJSr46GldfadvvpBc6BuJcu/fBem5ox6idLGBq82YTkfCO7OqlCWrY01p//aMd9T+//PRwBJFSEXqOQR7XCI4ViVxd+YXWyj+fomNnafCsEEIjVm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWG3NPfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWG3NPfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94BDC4CED3;
	Tue, 17 Dec 2024 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455888;
	bh=yPU5n+5gIzaVC6W+CoZvW0/B5EyRJUaubsa2bwfea1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWG3NPfpGoXKemB5mXvVja5asgCYrY96YgZ8ckEGsTUprIPQjN7laT6Njbkq08fAr
	 n27MosZIZWiq9ZxWojqf1Db6Vk5+uJTk7cB4zMmtCRyo3qtLCk6JRRKqhXfX149Nlu
	 c6+NxgEIFcrH537a/6ftu7Q408APUw3rbSLKcvKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH 6.1 67/76] tracing/kprobes: Skip symbol counting logic for module symbols in create_local_trace_kprobe()
Date: Tue, 17 Dec 2024 18:07:47 +0100
Message-ID: <20241217170529.191400017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
avoids checking number_of_same_symbols() for module symbol in
__trace_kprobe_create(), but create_local_trace_kprobe() should avoid this
check too. Doing this check leads to ENOENT for module_name:symbol_name
constructions passed over perf_event_open.

No bug in newer kernels as it was fixed more generally by
commit 9d8616034f16 ("tracing/kprobes: Add symbol counting check when module loads")

Link: https://lore.kernel.org/linux-trace-kernel/20240705161030.b3ddb33a8167013b9b1da202@kernel.org
Fixes: b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v1 -> v2:
 * Reword commit title and message
 * Send for stable instead of mainline

 kernel/trace/trace_kprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1816,7 +1816,7 @@ create_local_trace_kprobe(char *func, vo
 	int ret;
 	char *event;
 
-	if (func) {
+	if (func && !strchr(func, ':')) {
 		unsigned int count;
 
 		count = number_of_same_symbols(func);


