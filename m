Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2E720EB;
	Mon, 14 Oct 2024 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916753; cv=none; b=Kbm/7r7CYafyvGAfiK6aWaactvrQ4i65L9s38MskaCsWVgXe2cqvGAvE0mf0YINT7w9a/is3pdLtLEWG5M4oHo8/5+2GvQXP0sTFFDVunxluHru2FeEmTH19ZojYzVslHne2+XVXD68vIusCadwcDG2h3p8bxmCg7XJvqQwZVKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916753; c=relaxed/simple;
	bh=WmO65fj0xH8c1gXRbauisboKCoPrPrKLi8UJah+TnzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4fSl5WnPSD7rwFlJUzHJM+9rFmKc/uSEnX0F0ASmDhpR6iQqOcumVm1CSW+y3VjxJHB4rUQMzKQTXpbn3VPIuWhFCAxx5pqlNQbDYZbgZnRsMe/Kfm71dpoNDnSs2xK4jaUUmIz489DrgAAkE3H18tcsSUCO3zv74jmsyGQXrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMNtE8XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMNtE8XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD11C4CEC3;
	Mon, 14 Oct 2024 14:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916753;
	bh=WmO65fj0xH8c1gXRbauisboKCoPrPrKLi8UJah+TnzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMNtE8XI19aKgRg9AgyugHpIoYp1e5r/gtGlp15znFRja3dwPCiTuKXDs4In+Bp6Q
	 j7T+rTWNpnM6yt4S4+DeujOTb+O2dMYjkhmIFy0vzjzXdOH1aFueL+879FI7HsusmO
	 skJiGwftocwBop1ZvxEbWgmywGQ/glcjreS4YVhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/213] perf sched: Move curr_thread initialization to perf_sched__map()
Date: Mon, 14 Oct 2024 16:19:04 +0200
Message-ID: <20241014141044.477272498@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8143828fdc585..e498b559ea68a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3310,9 +3310,13 @@ static int perf_sched__map(struct perf_sched *sched)
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
 
@@ -3335,6 +3339,9 @@ static int perf_sched__map(struct perf_sched *sched)
 out_put_map_cpus:
 	zfree(&sched->map.comp_cpus);
 	perf_cpu_map__put(sched->map.cpus);
+
+out_free_curr_thread:
+	zfree(&sched->curr_thread);
 	return rc;
 }
 
@@ -3620,11 +3627,6 @@ int cmd_sched(int argc, const char **argv)
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
@@ -3706,7 +3708,6 @@ int cmd_sched(int argc, const char **argv)
 out:
 	free(sched.curr_pid);
 	free(sched.cpu_last_switched);
-	free(sched.curr_thread);
 
 	return ret;
 }
-- 
2.43.0



