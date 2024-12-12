Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93216223E81;
	Thu, 12 Dec 2024 16:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019681; cv=none; b=nQbSre1wfQxf4OK3G6wt8Ko9+sgOED4QKV6PWJGVzaOW9wZA1QoeqmBtZpYmBwTo/u8XLoYoUgfsT05Bi/+/vdDfHPYqm4yVtRNKpGt8t8Y92zTldfeySOLBepXsJqf/y2UqHEzgSJc7x360wJopY+WK9IkrdAlLpZxTaJa/BB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019681; c=relaxed/simple;
	bh=PUj7ddEPQ4brmZvcnHwucz10oOBAZ+3Nb7ycdmqJCRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSYBVoxYHvzd0vptCfYltPtVsWN1s5eOegUDXjZM+1mIoimOtyVeOYkDIYYVttTCmqNBEIUtuiD9m4W/Su38thXrhvRtsqG9K35HzTs01cK5qwCvM8dpDLd8pxKOGhduiOkYQoZBmx+CO2s2tn7Kp0a2FEU+GlyPqrvD6ca7rx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1o1K0VGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1o1K0VGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1047C4CECE;
	Thu, 12 Dec 2024 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019681;
	bh=PUj7ddEPQ4brmZvcnHwucz10oOBAZ+3Nb7ycdmqJCRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1o1K0VGCvmozNgF4b6SDEy3qNxVZCUvTIXmoz+juiTeU5jPCY+w0JBQYa8Yy07t4d
	 dShd18wcQFHe4rzoRrE8jYru7PdJiMkP7M7olcEIZkRHc4i8lSjxLlJAwM+zSCs8tB
	 iU12tzmw+bSMOtIDFBYvQWpDvMHo/Io6RztUxNMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 271/772] perf ftrace latency: Fix unit on histogram first entry when using --use-nsec
Date: Thu, 12 Dec 2024 15:53:36 +0100
Message-ID: <20241212144401.113346501@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@kernel.org>

[ Upstream commit 064d569e20e82c065b1dec9d20c29c7087bb1a00 ]

The use_nsec arg wasn't being taken into account when printing the first
histogram entry, fix it:

  root@number:~# perf ftrace latency --use-nsec -T switch_mm_irqs_off -a sleep 2
  #   DURATION     |      COUNT | GRAPH                                          |
       0 - 1    us |          0 |                                                |
       1 - 2    ns |          0 |                                                |
       2 - 4    ns |          0 |                                                |
       4 - 8    ns |          0 |                                                |
       8 - 16   ns |          0 |                                                |
      16 - 32   ns |          0 |                                                |
      32 - 64   ns |        125 |                                                |
      64 - 128  ns |        335 |                                                |
     128 - 256  ns |       2155 | ####                                           |
     256 - 512  ns |       9996 | ###################                            |
     512 - 1024 ns |       4958 | #########                                      |
       1 - 2    us |       4636 | #########                                      |
       2 - 4    us |       1053 | ##                                             |
       4 - 8    us |         15 |                                                |
       8 - 16   us |          1 |                                                |
      16 - 32   us |          0 |                                                |
      32 - 64   us |          0 |                                                |
      64 - 128  us |          0 |                                                |
     128 - 256  us |          0 |                                                |
     256 - 512  us |          0 |                                                |
     512 - 1024 us |          0 |                                                |
       1 - ...  ms |          0 |                                                |
  root@number:~#

After:

  root@number:~# perf ftrace latency --use-nsec -T switch_mm_irqs_off -a sleep 2
  #   DURATION     |      COUNT | GRAPH                                          |
       0 - 1    ns |          0 |                                                |
       1 - 2    ns |          0 |                                                |
       2 - 4    ns |          0 |                                                |
       4 - 8    ns |          0 |                                                |
       8 - 16   ns |          0 |                                                |
      16 - 32   ns |          0 |                                                |
      32 - 64   ns |         19 |                                                |
      64 - 128  ns |         94 |                                                |
     128 - 256  ns |       2191 | ####                                           |
     256 - 512  ns |       9719 | ####################                           |
     512 - 1024 ns |       5330 | ###########                                    |
       1 - 2    us |       4104 | ########                                       |
       2 - 4    us |        807 | #                                              |
       4 - 8    us |          9 |                                                |
       8 - 16   us |          0 |                                                |
      16 - 32   us |          0 |                                                |
      32 - 64   us |          0 |                                                |
      64 - 128  us |          0 |                                                |
     128 - 256  us |          0 |                                                |
     256 - 512  us |          0 |                                                |
     512 - 1024 us |          0 |                                                |
       1 - ...  ms |          0 |                                                |
  root@number:~#

Fixes: 84005bb6148618cc ("perf ftrace latency: Add -n/--use-nsec option")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/r/ZyE3frB-hMXHCnMO@x1
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 1d40f9bcb63bc..86597f6119003 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -769,7 +769,7 @@ static void display_histogram(int buckets[], bool use_nsec)
 
 	bar_len = buckets[0] * bar_total / total;
 	printf("  %4d - %-4d %s | %10d | %.*s%*s |\n",
-	       0, 1, "us", buckets[0], bar_len, bar, bar_total - bar_len, "");
+	       0, 1, use_nsec ? "ns" : "us", buckets[0], bar_len, bar, bar_total - bar_len, "");
 
 	for (i = 1; i < NUM_BUCKET - 1; i++) {
 		int start = (1 << (i - 1));
-- 
2.43.0



