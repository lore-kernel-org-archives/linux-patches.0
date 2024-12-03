Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF91E23CE;
	Tue,  3 Dec 2024 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241708; cv=none; b=Rk+6CcEd/wkTxw1DofW0kTd5unlIJaMxm1DXdqnAMjsZqNN7nqw3ckhYyR3q9uo1NjX0hSJ6n0xLo5YKCXWr0nHOhOFGUVuUExeLfo+0PEY9UQZc51STE7AGFCV3oK2JAPtjqfcsib2SOugTdOo1PuB4XII0Lw5VxtnSXrjeR/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241708; c=relaxed/simple;
	bh=NVyKa+/g9WhrBwwe1x52gME02tkaEmex1b57eMbZ+dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRDD+m2HKJooyS5RuCMmGK8HJVwGHYs2cWdRVhkO4qSR0HnFrEXVmPRTMsu3Ya+X0A09Pjx6wHh/1spe3/cf5VPG7Kq8EEHEwUrODV7FVlKPWuiEyqUvvFur7BlG/18NaAgISPiiiG/L4Jtzs33XRzDnilJYdyVDIIBIxP63KJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09AFT2iP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09AFT2iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F234C4CECF;
	Tue,  3 Dec 2024 16:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241707;
	bh=NVyKa+/g9WhrBwwe1x52gME02tkaEmex1b57eMbZ+dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09AFT2iPyixwdQBupjKIG7xSSEvupLpve3+uAGiI6Q+O4UTM2f59C7TNqGMWEWX29
	 NHjcvOmENr+kjYcSeUw4//jCtDfq7+D1oGYB8WI2UoxIDoLBbjLGvCRaPAUWTUMUsU
	 XX+1zs82OPA3LYgqL7LUGm0cXZ8mp4mBhgOzA1Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 495/826] perf ftrace latency: Fix unit on histogram first entry when using --use-nsec
Date: Tue,  3 Dec 2024 15:43:42 +0100
Message-ID: <20241203144803.064353147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index abcdc49b7a987..272d3c70810e7 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -815,7 +815,7 @@ static void display_histogram(int buckets[], bool use_nsec)
 
 	bar_len = buckets[0] * bar_total / total;
 	printf("  %4d - %-4d %s | %10d | %.*s%*s |\n",
-	       0, 1, "us", buckets[0], bar_len, bar, bar_total - bar_len, "");
+	       0, 1, use_nsec ? "ns" : "us", buckets[0], bar_len, bar, bar_total - bar_len, "");
 
 	for (i = 1; i < NUM_BUCKET - 1; i++) {
 		int start = (1 << (i - 1));
-- 
2.43.0



