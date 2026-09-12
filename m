Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDC7340400;
	Sat, 12 Sep 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225375; cv=none; b=ZUDtNvwzN3FjEP9TGISu+n2NLAhrrWiCfWbILpyJDkDWemAzsdQZiOwLDyftXzIMHmQGiRdNYN9m4tAHfRzxjHWYSVKTf9Jjjkn8APo/C61+ATJcw3l52ib9llJD+yvmb/VyPSccMiHf4z0IPEUMSavvxGnnBUWhrJxy8/YOnjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225375; c=relaxed/simple;
	bh=871bZfXfDeMiQfU2YcN06opzQi9RHGebJP+VdkRGmKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6CXiciudB/AeiSqIgusAtpdcWcnM6YKs7monPrcchuRM+bZ9nP5vcNwfQVE+gu/tH6sX0Opu3JSWxXMkQ8B7ywMKxvP4x5NKWiL4H3hF1qyi5LUN9Fv7OrPcIC2gJhEYxSV5Mq0dJTXzdK9I7QUls+QAu0OsYE2uNV0MZYDn6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YX95LOVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YX95LOVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071071F000FF;
	Sat, 12 Sep 2026 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225374;
	bh=4LK/2M6rpSG3JD6vHJpYX3mnOVh/hoWVExtzlRuARYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YX95LOVLtEnEd3F7/i6loOU3motB2hG1ME5qw/b6lTHRfgtFIHgW4LrgLVXrtvOqJ
	 ReJ0mrY1OE7r3ji4NeWZUzu4Zu5UQ/P0OOcFhI1LCplg4Lf1aZlrWF6+ciXCvYvxKD
	 99OgEhlJ79Vf1PS/Gfzx7QajBzFa3jLX7Z+jKFSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1142/1424] perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads
Date: Sat, 12 Sep 2026 08:59:34 +0200
Message-ID: <20260912065632.872987173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2e1c4a1536fd3..7566737617877 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1029,7 +1029,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	else
 		thread_nr = nr_threads_synthesize;
 
-	if (thread_nr <= 1) {
+	if (thread_nr <= 1 || n <= 1) {
 		err = __perf_event__synthesize_threads(tool, process,
 						       machine,
 						       needs_mmap, mmap_data,
-- 
2.53.0



