Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15C843D4E2;
	Tue, 21 Jul 2026 22:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671828; cv=none; b=V2Gl9d3YLYEiVssdYvuLBVBeqS1HvIURaD38T9+7DxjVimDuBdecO9ZjBUWFrfagL3wKkLFifAfJo4lwCxx2mY3LjIGqBM35sG4MAq5I4I6kh5oVQ0JaOz61GGr+HeSbWeWUwIcBEvYuJw4K70B6Tr/wOXRPdOLYSgLloe8z3Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671828; c=relaxed/simple;
	bh=ggW1GF8FPk2Bpi++wa9BaHJg1Oik4SoXaTeqWY/np0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhC4StH9ItDii24fOtYjANNQ1fJIquMs5WsiBKDf4xpnRIG0943Uxu2LWHAi0UDV4T0O55/+WBizALWnPR8SjLqAHW82Xtw8Cx5ls9Zl5iIe8VHmm5b0kZylylHYceiOLj7cvvK3lsYrlIBgMLNmvAHsX3tFrYRp8ArPT0J/fk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWDD0AWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWDD0AWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0D71F000E9;
	Tue, 21 Jul 2026 22:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671827;
	bh=sXK6wEN2oIDKDg2Q18n1+x3QJSDE4OiAuOnOKASkjBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWDD0AWglssVISfwr2rmRfAmR5+yPiq+oraZadAe6pBkp4KiEAA829YZ/ToGJg+HB
	 QeiHrEfZO3/b+oxLNwpIgZJRvlU6lRYvG/uTbv8wT2G2DztG2hdclc/Xwu54rU7fSZ
	 RL54Ne4r8vCSqOIyhEwHeTl6n6ZnjjD9J2rEC9Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/843] perf sched: Clean up idle_threads entry on init failure
Date: Tue, 21 Jul 2026 17:20:28 +0200
Message-ID: <20260721152414.881365609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cda5a94ad9181cd60cbf04be11d524201bf489a2 ]

get_idle_thread() allocates a thread via thread__new() and stores it in
idle_threads[cpu], then calls init_idle_thread() to set up the private
data.  If init_idle_thread() fails (e.g. OOM for the idle_thread_runtime
struct), the function returns NULL but leaves the partially initialized
thread in idle_threads[cpu].

On subsequent calls for the same CPU, get_idle_thread() finds a non-NULL
idle_threads[cpu], skips allocation, and returns thread__get() on a
thread that has no priv data.  Callers then get a thread whose
thread__priv() returns NULL, leading to unexpected behavior.

Release the thread and reset the slot to NULL on init failure so the
entry doesn't persist in a corrupted state.

Fixes: 49394a2a24c7 ("perf sched timehist: Introduce timehist command")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 35cc5339ede517..6264a2cded514f 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2289,8 +2289,11 @@ static struct thread *get_idle_thread(int cpu)
 		idle_threads[cpu] = thread__new(0, 0);
 
 		if (idle_threads[cpu]) {
-			if (init_idle_thread(idle_threads[cpu]) < 0)
+			if (init_idle_thread(idle_threads[cpu]) < 0) {
+				/* clean up so next call doesn't find a half-initialized thread */
+				thread__zput(idle_threads[cpu]);
 				return NULL;
+			}
 		}
 	}
 
-- 
2.53.0



