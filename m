Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B8F46D2BF;
	Tue, 21 Jul 2026 18:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660320; cv=none; b=Qo4IHeUlT9OrM6+WMBb+Lr80WMfIvCEJvYsAROz2GfYRMul+7QxEZl6YjCWCMFMeudOgdJEQjQ535+kjz4ucm/qKw0MgpRBKnfMv4a7kXSRTmNR3d7lqVaqr1g6yjc5bsfGudQFfkg/aawtfq8dRGuiNj7xpLLQBeULKhp1GeOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660320; c=relaxed/simple;
	bh=jfDp6Wpw7zPi6kF/ZmnM3OyX0njO0YZuHZ22aKY3ib0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWzZqAkOXM1RPrGcx70z7cnIbaL1QUyV71ApsGIP6YaHWIfYuh1kQoHSw5f1e9uxBe4FyrGHy+FKDWoZmKQqRZZ5pKx6lz0HP3Hp98Cokc51SamqyFsDb5hMdlClwddkHgjAJGSF26rlzii9WOpioIRMtdPloo/aDK6+xzNImhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWQ9R2zP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWQ9R2zP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785091F000E9;
	Tue, 21 Jul 2026 18:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660319;
	bh=PBJpB6Mbp2/E9bcopWbIV+VI8JKUqopv0qS7kh67/bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWQ9R2zPQemP5VhdQaQyRSLSqnWixnuuiDN9ZqB+kntGmBYUbEDDp/iMFwh/ly5YH
	 CeVdu5KCAgnaKdMW96Wi43wQMtKfEgJ4vG31i9fseqRJhND2OAp4WuzcDiigoa83Ig
	 MZejfzE0I+C2bfPzPICJi4apGIvH0iCV0R2KKGP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0936/2077] perf sched: Fix thread reference leaks in timehist_get_thread()
Date: Tue, 21 Jul 2026 17:10:09 +0200
Message-ID: <20260721152614.892273679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit fa20c1f8f4e094abe0169d39fce8181bc26d6dab ]

timehist_get_thread() acquires a thread reference via
machine__findnew_thread() and an idle thread reference via
get_idle_thread() (which calls thread__get()).  Two error paths in
the idle_hist block return NULL without releasing these references:

 - When get_idle_thread() fails, the thread reference leaks.
 - When thread__priv(idle) returns NULL, both idle and thread leak.

Additionally, the idle thread reference acquired on the success path
is never released, leaking a reference on every sample when
--idle-hist is active.

Add thread__put() calls on both error paths and release the idle
reference after use on the success path.

Fixes: 5d8f17fb5822 ("perf sched timehist: Add -I/--idle-hist option")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6f5d5f3ce715c7..7503fc00ff20a3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2547,12 +2547,16 @@ static struct thread *timehist_get_thread(struct perf_sched *sched,
 			idle = get_idle_thread(sample->cpu);
 			if (idle == NULL) {
 				pr_err("Failed to get idle thread for cpu %d.\n", sample->cpu);
+				thread__put(thread);
 				return NULL;
 			}
 
 			itr = thread__priv(idle);
-			if (itr == NULL)
+			if (itr == NULL) {
+				thread__put(idle);
+				thread__put(thread);
 				return NULL;
+			}
 
 			thread__put(itr->last_thread);
 			itr->last_thread = thread__get(thread);
@@ -2560,6 +2564,8 @@ static struct thread *timehist_get_thread(struct perf_sched *sched,
 			/* copy task callchain when entering to idle */
 			if (evsel__intval(evsel, sample, "next_pid") == 0)
 				save_idle_callchain(sched, itr, sample);
+
+			thread__put(idle);
 		}
 	}
 
-- 
2.53.0



