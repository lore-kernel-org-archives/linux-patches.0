Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDA441B8E4;
	Sat, 12 Sep 2026 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210727; cv=none; b=F4jmwf720d+JvomFVncivPOnYlymOUXo3Lb2HexZwmUq63IFFOe8ZkYl3Sm4HwYMhdgBDJugMhNWitZr1wgq6XnomuPYcAyViBgoegEVootnGLDPHr/v+7slD4B5wE8pj2vtUiqsJvmSLOD4r41NB2zyMxIKhjVJKYGM/zlp5yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210727; c=relaxed/simple;
	bh=vQH27wI9LHnefBapH+3GentOkIBIZ9JV6ShA76NiHqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYTJvcj8RY4g0TaAHa4t8raWFX06rOqRRO7RnKTaQ56opJXecxv+7aVNg969yKWCYqj74s41gwKHsp3VV+dAlbFpvzOYDpRNl+JmGpvctBJIfHYsHBUn63DxzCkl9CNDbgFHQJ8vR4itXQBpSKvyh6OSkwUr3AmiwtDqxytPYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwWGrsaI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwWGrsaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353671F000FF;
	Sat, 12 Sep 2026 10:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210726;
	bh=rsmM/TrigBNgd7t2Z7UD5pJMuCYyvsVrAfMDfctGI2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwWGrsaI0iKIrDN432fyNsUT8LdsN/R0Zr2HHuiIoOhXxaL+h2Gokrkq409RNaDHM
	 couR2o6ouYBPXJYAXhqSZOtzyPo8IH/j8YuqfOq5VwrvUGZ0UIV3F1UnDEdYFQBj4C
	 RTqfoSi8Agvq7mmwIPzb42yZ1qFWX7VEhr5QGMaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1058/1518] perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads
Date: Sat, 12 Sep 2026 08:53:47 +0200
Message-ID: <20260912065647.385199430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 16a12a54e9a1151a37aab74914a51b86f7f58d0e ]

If scandir() finds no matching tasks in /proc, n is 0. If thread_nr is > 1,
we bypass the single-thread fast path and then clamp thread_nr to n, making
it 0. This results in a divide by zero when calculating num_per_thread.

Handle n <= 1 early to use the single-thread fast path and prevent the
crash.

Fixes: 340b47f510bb ("perf top: Implement multithreading for perf_event__synthesize_threads")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index f2d09fcaafb76..ef0586cbc103b 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1058,7 +1058,7 @@ int perf_event__synthesize_threads(const struct perf_tool *tool,
 	else
 		thread_nr = nr_threads_synthesize;
 
-	if (thread_nr <= 1) {
+	if (thread_nr <= 1 || n <= 1) {
 		err = __perf_event__synthesize_threads(tool, process,
 						       machine,
 						       needs_mmap, mmap_data,
-- 
2.53.0



