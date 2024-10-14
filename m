Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C659F43AA9;
	Mon, 14 Oct 2024 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919675; cv=none; b=huf8WxgTxkheOL0mG9g3C5VuoxdAFxXlCCzV7objB4fml4brseGbPjrGc/zpjsudHfLKEIafnmrzqZgioMweAtO1GjM/p9QIYJmysV8UdZmYcQ82AH3QUFcw4obVoxQAvDBnneJ/iPTwWH5iZibiHdHpNtfYJQPdbzUoENcuJIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919675; c=relaxed/simple;
	bh=Wps9GTuz5wk3jqcrwZC72jAJwsXLfZNo6NiQtZfA74I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWZMgWEaxyC3HCRn77TRTm49h6+TDLwZfMOiw837E6NiCDNt9dtW4s9e/4HoymAVS/Kgpm2JQ7Td3ZncnKf4xuyrhaDg33JvesCiyeKLAsMgDCPTN0azl6qCPugWIW6z/iF+P/HzVysztEBNwgukff7YMg46SXpPQu9aKTEloyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYBAbh59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYBAbh59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FE7C4CEC3;
	Mon, 14 Oct 2024 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919675;
	bh=Wps9GTuz5wk3jqcrwZC72jAJwsXLfZNo6NiQtZfA74I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYBAbh5916ewoOzPuKxolX3Sw27Z1+/JXEH9wziE6iiE2YWlMZyhKahOv+ssto8OG
	 c+9AuKOIOarytHxXhJaFMjbnbIqbuenYHpC85xSGXOXUq8i0fZu/ZttLXye+oG2oCP
	 XbLN7DC539pZHIsJq4Y1f+nRwq//mvO82X+/oCG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 676/798] perf sched: Move curr_thread initialization to perf_sched__map()
Date: Mon, 14 Oct 2024 16:20:30 +0200
Message-ID: <20241014141244.625151562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 5e895278697c014e95ae7ae5e79a72ef68c5184e ]

The curr_thread is used only for the 'perf sched map'. Put initialization
in perf_sched__map() to reduce unnecessary actions in other commands.

Simple functional testing:

  # perf sched record perf bench sched messaging
  # Running 'sched/messaging' benchmark:
  # 20 sender and receiver processes per group
  # 10 groups == 400 processes run

       Total time: 0.197 [sec]
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 15.526 MB perf.data (140095 samples) ]

  # perf sched map
    *A0                                                               451264.532445 secs A0 => migration/0:15
    *.                                                                451264.532468 secs .  => swapper:0
     .  *B0                                                           451264.532537 secs B0 => migration/1:21
     .  *.                                                            451264.532560 secs
     .   .  *C0                                                       451264.532644 secs C0 => migration/2:27
     .   .  *.                                                        451264.532668 secs
     .   .   .  *D0                                                   451264.532753 secs D0 => migration/3:33
     .   .   .  *.                                                    451264.532778 secs
     .   .   .   .  *E0                                               451264.532861 secs E0 => migration/4:39
     .   .   .   .  *.                                                451264.532886 secs
     .   .   .   .   .  *F0                                           451264.532973 secs F0 => migration/5:45
  <SNIP>
     A7  A7  A7  A7  A7 *A7  .   .   .   .   .   .   .   .   .   .    451264.790785 secs
     A7  A7  A7  A7  A7  A7 *A7  .   .   .   .   .   .   .   .   .    451264.790858 secs
     A7  A7  A7  A7  A7  A7  A7 *A7  .   .   .   .   .   .   .   .    451264.790934 secs
     A7  A7  A7  A7  A7  A7  A7  A7 *A7  .   .   .   .   .   .   .    451264.791004 secs
     A7  A7  A7  A7  A7  A7  A7  A7  A7 *A7  .   .   .   .   .   .    451264.791075 secs
     A7  A7  A7  A7  A7  A7  A7  A7  A7  A7 *A7  .   .   .   .   .    451264.791143 secs
     A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7 *A7  .   .   .   .    451264.791232 secs
     A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7 *A7  .   .   .    451264.791336 secs
     A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7 *A7  .   .    451264.791407 secs
     A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7 *A7  .    451264.791484 secs
     A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7  A7 *A7   451264.791553 secs
  # echo $?
  0

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240206083228.172607-4-yangjihong1@huawei.com
Stable-dep-of: 1a5efc9e13f3 ("libsubcmd: Don't free the usage string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 8abd48a99ec5e..0cdb220229d39 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3298,9 +3298,13 @@ static int perf_sched__map(struct perf_sched *sched)
 {
 	int rc = -1;
 
-	if (setup_map_cpus(sched))
+	sched->curr_thread = calloc(MAX_CPUS, sizeof(*(sched->curr_thread)));
+	if (!sched->curr_thread)
 		return rc;
 
+	if (setup_map_cpus(sched))
+		goto out_free_curr_thread;
+
 	if (setup_color_pids(sched))
 		goto out_put_map_cpus;
 
@@ -3323,6 +3327,9 @@ static int perf_sched__map(struct perf_sched *sched)
 out_put_map_cpus:
 	zfree(&sched->map.comp_cpus);
 	perf_cpu_map__put(sched->map.cpus);
+
+out_free_curr_thread:
+	zfree(&sched->curr_thread);
 	return rc;
 }
 
@@ -3608,11 +3615,6 @@ int cmd_sched(int argc, const char **argv)
 	unsigned int i;
 	int ret = 0;
 
-	sched.curr_thread = calloc(MAX_CPUS, sizeof(*sched.curr_thread));
-	if (!sched.curr_thread) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	sched.cpu_last_switched = calloc(MAX_CPUS, sizeof(*sched.cpu_last_switched));
 	if (!sched.cpu_last_switched) {
 		ret = -ENOMEM;
@@ -3694,7 +3696,6 @@ int cmd_sched(int argc, const char **argv)
 out:
 	free(sched.curr_pid);
 	free(sched.cpu_last_switched);
-	free(sched.curr_thread);
 
 	return ret;
 }
-- 
2.43.0



