Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE59A3DDB03;
	Tue, 21 Jul 2026 22:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673957; cv=none; b=Qm9Rnt2W42LFxalYlU/NT1xgyxP7x0N+7LaOnqHse3UMUQ1fSghpKB5nQW1Q8HlvcABufzuCOcWnoTwtVSS6hMT0apIVgJi/NJ58446RrgLeCx5yuftDRUPr7AI6BIHQMybmbDy86JOd0Q5BadzKb6W6vOrBwhLSShF5C5WEGhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673957; c=relaxed/simple;
	bh=o0zI7/7tUuiVXIFYbaoQbKQOu4fxNW6FPgnGjISgZiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+EUpAIBHlFjCe+jHhV0h/WuK4s4BJCwW1on/cUPNwOr/KxEF6EjSzIIlZ8peS+uhNs/FcessoAuASTrj9ZG4woUUKEDLv/ZuPP9co2exOUhQo7xz3OqW/LTnLD1dAoJQyycSnDiEmrRyAXCrySrxPVrUOHbUefVqsSAmYEC9vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UezY5gU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UezY5gU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203591F000E9;
	Tue, 21 Jul 2026 22:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673956;
	bh=IwtTBWYc1u7EC2pDTbjyqha5DFarjsR9m+liDOmNnis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UezY5gU/2ISCa80zB0mxWGQB5dnWh55cqNcORz4JBepeOGqnUSJ+FHcbj5eld1lpe
	 edWIDhcZjNKoxWK76XbSvuCRIboTmN7pW77AhpiK24eVqS1Pkk2DagxRcdoHLdrjeT
	 62xjTsxAyHcfhXsjcz1dQ24rFaX5VYWWu5o3UhAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/699] perf tools: Fix thread__set_comm_from_proc() on empty comm file
Date: Tue, 21 Jul 2026 17:21:15 +0200
Message-ID: <20260721152402.821764996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 31d596054550f793508abe7dd593853ece47d428 ]

thread__set_comm_from_proc() calls procfs__read_str() then strips
the trailing newline via comm[sz - 1] = '\0'.  procfs__read_str()
allocates the buffer before reading, so on an empty /proc/pid/comm
(reachable during late exit teardown) it returns success with sz = 0
and an unterminated heap buffer.

The sz - 1 underflow was the original sashiko finding: it writes a
null byte before the allocation.  But even with a sz > 0 guard on
the newline strip, the unterminated buffer would still be passed to
thread__set_comm() which calls strlen() — an unbounded heap read.

Fix by treating sz == 0 as failure: free the buffer and return -1.
This is consistent with pmu.c's perf_pmu__parse_scale/unit which
already treat len == 0 from filename__read_str as an error.

Fixes: 2f3027ac28bf6bc3 ("perf thread: Introduce method to set comm from /proc/pid/self")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/thread.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 665e5c0618ed3d..6840a2d357b6a6 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -282,6 +282,11 @@ int thread__set_comm_from_proc(struct thread *thread)
 	if (!(snprintf(path, sizeof(path), "%d/task/%d/comm",
 		       thread->pid_, thread->tid) >= (int)sizeof(path)) &&
 	    procfs__read_str(path, &comm, &sz) == 0) {
+		/* sz==0: read got nothing, e.g. race during exit teardown */
+		if (sz == 0) {
+			free(comm);
+			return -1;
+		}
 		comm[sz - 1] = '\0';
 		err = thread__set_comm(thread, comm, 0);
 	}
-- 
2.53.0



