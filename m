Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ED536404D;
	Sat, 12 Sep 2026 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203043; cv=none; b=NA3NN+KUHG1T1Q67rbg7Sbc0bxWJXKF3GD/DuD6zKH6WYxag7ImTRQB3Owpowb0iQbXD281rCEwFCg4Kaii//FydvokHXAsz0UIbSkZq7LdgfpawNqsFHC5XyPfiGLSJBbSsPvHyq94oHFwf9jbihlGCJxlIzQ1fl0PJEE7Tskg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203043; c=relaxed/simple;
	bh=vEPB9Jz7S67a0VaIlULMmHNLdyIEiHzKzAd8wVI0teQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKX4sP2kiIvWufoo/wH2SFBROOQ9LIr8pWyMNmX8O7FNCe2KVixscap8HDJyNpFsXqX+xU/zRkohZkLJiVy/P2CVo+4YHwpJkuVDMoGZXKdhR2HmiMy5Qy6OPU0dsHZk4Kp5uS8QwfIjV2dn/b4qnup+6twIAMF0Q/vRhj+JMCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWwWbxYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWwWbxYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E051F000FF;
	Sat, 12 Sep 2026 08:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203039;
	bh=nH+UZ3nwVLvIAvgnUIDEj/teFDIe8YxwmjggbR/BGd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWwWbxYJgCHZOQirHSwc7lnJRfdLKVeHMyX7AJa+IGN14iId4aSrcwGnFn6QAFbtb
	 5gHXZzv8ZOLYHw8yKTxCDL6cSbdLeZ7lsujQIvaZYFExLU/cBUadL1TOk/LOoWx+Ay
	 VAfbKpys+UMp22yH1/iMNHgiDpzC7dqYFKOPOTic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1284/1815] perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads
Date: Sat, 12 Sep 2026 08:50:34 +0200
Message-ID: <20260912065719.158688069@linuxfoundation.org>
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
index 35de41ad14d33..19c1f3eaf58d8 100644
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



