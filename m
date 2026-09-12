Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35D5392806;
	Sat, 12 Sep 2026 19:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243166; cv=none; b=lnYKIOxB2eLSVJ8eyoFm85v+c++T8NWIz7J2aBAFmkmgQ0m2/LvhBU6GIxiurll9YVg61npiH2mW84yxZPKXCelq+Dlu4x+1/ffmIh7uWfDc6KYVHJl5drfKrmRgzchH4fld82WdKND/wc/uwVwWICnS+tZnof7m6XPkXvONIO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243166; c=relaxed/simple;
	bh=cS2xAWIUKvJ3Tnh9asPAZXxrAAdc8xZ2PvjPn2R8x+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmxcPNT9/IvehwAcyWkvpDLBitqVbbV35w93cgdjYx+q49OGoZ2aL+PQEhrb/kBQ7MNoTngmSajrKJPTNwwtvZESYRa11WIyxpV/ly3P1Gu9CADMWKt1IYTr6iEDDXHO3lQb0NysLVTObePq9Dhr4iCjcF+Iuoe98OjP/fupQgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NksuYQXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NksuYQXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3171F000FF;
	Sat, 12 Sep 2026 19:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243165;
	bh=28LapWENghwE+ifSquRcd3bpzAeSJz1pn+zZJaaE70E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NksuYQXIJ8mGlUEb56L5/NBHxKCaJbq38j824X3jAMWvnlPBHYP5GwPES8DXzv5/i
	 aHNjZH9vQEej23guyn55iLfPU9DjMPZHHyzbgjq8XzZBAuLA3A3u1Wc1uwuOMAcCKX
	 BxSZdFyOgUAJFhTRgw4w04KZiQI6rczW52vSb0I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 661/798] perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads
Date: Sat, 12 Sep 2026 09:04:49 +0200
Message-ID: <20260912065532.261526140@linuxfoundation.org>
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
index fcdafc35d5e48..519eca28fcdbf 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -924,7 +924,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	else
 		thread_nr = nr_threads_synthesize;
 
-	if (thread_nr <= 1) {
+	if (thread_nr <= 1 || n <= 1) {
 		err = __perf_event__synthesize_threads(tool, process,
 						       machine, mmap_data,
 						       dirent, base, n);
-- 
2.53.0



