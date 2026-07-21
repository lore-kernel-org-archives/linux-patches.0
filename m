Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7AF471250;
	Tue, 21 Jul 2026 18:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660304; cv=none; b=YHf6Zf6t+lBtPMGOHl+vR2o1kcmJAwIEdFFIPx8MJtz3/3pn2HgB9nQd1Owp2sDwEWKI1cngXeOZmiQye8WLxPmeh8iA/WVmC5CyErV+PPrXJgchB1yjdZIELscwsPmfQiP9kcLUfmEICOKFvWYnEVDj9VX7TRuRg0D6m+jE01Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660304; c=relaxed/simple;
	bh=wcTCZaZerMoyqjO+OUV81WZ0Iv/m94KMSGV5dVyxdZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph1pf7vD7mZXluFioGUp4EVDlZNKcAsZJ0l8W29op3X4eHHtw5IE0XnnkPQzAURw20CeTrEaqMtNk+zlvbWGcUJfcGoBgz8ybMIRIfB+xch9d9fWrJAxs7VD50LLtMTrUShRCLnjiDxLCXQ6G1e5l/27WbPr07yrDLAH3HrMeyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrmCdcGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrmCdcGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930B31F000E9;
	Tue, 21 Jul 2026 18:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660303;
	bh=NNY/BHU1sSoh834b+oT3xOIVsKQlvLyV0E4OOnDNbSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrmCdcGDh47APxguN0ORY/o3eNZXIL3Tz3Lr1Tz4pMrIuKsId1Ne1V2ZkYSqgxcuz
	 MZz6FaEDQ7dJBkDzuqIomkwkEtnx+S1TVDfaexSC/jB9DRM37vhLTIgxOtdJi0jGLy
	 w61R/GwdSB6KMjsIBT3F/tufpRjfjlrWd6+c+rPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0930/2077] perf sched: Fix thread reference leak in latency_switch_event
Date: Tue, 21 Jul 2026 17:10:03 +0200
Message-ID: <20260721152614.753609085@linuxfoundation.org>
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

[ Upstream commit 66ea9de60396a4dea5276bc87025884691876c36 ]

In latency_switch_event(), after acquiring thread references for
sched_out and sched_in via machine__findnew_thread(), the first
add_sched_out_event() failure path does 'return -1', bypassing the
out_put label that calls thread__put() on both references.

The second and third add_sched_out_event() failures correctly use
'goto out_put'.  Fix the first one to match.

Fixes: b91fc39f4ad7 ("perf machine: Protect the machine->threads with a rwlock")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 3dcd1f3525fde9..c6a96d0dd77d94 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1177,7 +1177,7 @@ static int latency_switch_event(struct perf_sched *sched,
 		}
 	}
 	if (add_sched_out_event(out_events, prev_state, timestamp))
-		return -1;
+		goto out_put;
 
 	in_events = thread_atoms_search(&sched->atom_root, sched_in, &sched->cmp_pid);
 	if (!in_events) {
-- 
2.53.0



