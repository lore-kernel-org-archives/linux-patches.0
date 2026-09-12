Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE4539F18A;
	Sat, 12 Sep 2026 19:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239967; cv=none; b=cJq77oQWpLnXSDcDDNV+6m32UTrAMN8TJPNBTomOt59496RfD2HnvoTGO7b2ZUJEht/+vAYI4P9ULK42gEtcZeuQPfYAdoKZCsBa1wDEHkW/sGhgRjUPsHFadY1GprA8Z81djVPFFaKkESbfc9poBWEJ+hrIZAKwWwsSuALi69Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239967; c=relaxed/simple;
	bh=XcLYUtiqzY6RctpyPu7NWeLEj/rsIM8+nXms0WQZ1TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8VNQh8Mn12q9+s1yOzcdLMUAi9yQsfKe2MzNV21TQ9NsU6DLnu+5e+qUVU664xOmR+SfUyhHeG19RW2OOkDZEDoOkPdSyIP3Y6kHK7muvZyd1BXt7RuibGtLYij2C+ORMWRrB04dAkyjUTccTbdg1v+Ir8/tCb6w5dT1LSECa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMll4oFN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMll4oFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498B41F000FF;
	Sat, 12 Sep 2026 19:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239966;
	bh=jb3JDu3muqywh11AUAlojmvpRqQCX4DmvonCGJAvo0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMll4oFNwEvV3gnRzFnk/DEArYL3rQICxTNEye0Jc6YRAJlI0L2qjdaGiTbRMukLO
	 w3bvLzKI9ktO16YLowdUTbB6LFLEJxOIxII3iWcR3w/prs0hCmLScy8AOyE4gZBAO6
	 omWairQf4VZpSt95N47werr8VKhxSxBMH0JJRuX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 765/935] perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads
Date: Sat, 12 Sep 2026 09:03:15 +0200
Message-ID: <20260912065544.378052703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 66ba0fa1e3835..ef1b5828649a2 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1003,7 +1003,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	else
 		thread_nr = nr_threads_synthesize;
 
-	if (thread_nr <= 1) {
+	if (thread_nr <= 1 || n <= 1) {
 		err = __perf_event__synthesize_threads(tool, process,
 						       machine, mmap_data,
 						       dirent, base, n);
-- 
2.53.0



