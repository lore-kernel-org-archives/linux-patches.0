Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB4A3B83E0;
	Tue, 21 Jul 2026 21:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669315; cv=none; b=BDMeptaRwoCftMy1qnp+oNYAREAX2V6a3QYGfzWj+GvQxmCUXGIUQTKYHSlsF71fbWa0QEbsrQBAylCCd398BFU7B7R+FUtQw0sFhaL1mEeSrR/+001ZTokzr+SrwcPa8fYcIvbqMSjrHPvKTfaz+LLl2VstscONcnziCkbpF1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669315; c=relaxed/simple;
	bh=3H02CE8ldFbCLDD6dRJ6VQW/ytKk4T9n0wZHNXzJY3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUu1rztcjS7UsWwv93VDO+DMJ4KkLYVkNmaFVc23hbVg9TqM8nb0vSLrx5e+NZzF+xQ7h7LNXOeLuiCI2aa/zWRgwFIBNDIKk/zO6NEBbXz2QudHwss1rPh6A/3sEsVBjOZxXKKua3AcPYe4GRmsPPBdJovUtQHGTwGBxp151wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4FoqKjN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4FoqKjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C545C1F00A3F;
	Tue, 21 Jul 2026 21:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669308;
	bh=dQg0CJJlbokusrWDQ3TOAMyM1rsQuP2cQoaYT5pufng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4FoqKjNS/iWFlrS+MnPLvxBjLIcQxmcJHDeSJAFMMKlhnGRm1RyKpBxtkGnso1mQ
	 KMex5foloDPYTmfT16EejVcG3Suhsq9LZdbd/zHO4HZQoDXPQKSGRRDvKcrNWD9uoH
	 er0TaaO8PeGxntvxXmFl6y4ONNFsSluj/XhyZaFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0505/1067] perf sched: Clean up idle_threads entry on init failure
Date: Tue, 21 Jul 2026 17:18:26 +0200
Message-ID: <20260721152435.912524321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 927c0ece3a074f..167532c7adf006 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2349,8 +2349,11 @@ static struct thread *get_idle_thread(int cpu)
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



