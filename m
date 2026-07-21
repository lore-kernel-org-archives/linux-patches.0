Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C054646EF86;
	Tue, 21 Jul 2026 19:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660543; cv=none; b=Oi2JPtoXercBRm+gP0mP1rOgT1sHqa9789xNdxkjQRi1oomfKxWnC+nbzdDyfDeKmUTrdHAC6YGw5pSkP/44dolHJUBBzNhrpFUK7aWW+owHzCs194wleQgTWyn4TI3eMILTLMikrzo3y3Qe904UA6IKankqT3kRBt2sPA+AL0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660543; c=relaxed/simple;
	bh=J0ahfTPlbKnmaiMSUFxKk3Uwkz0zsvsgzRUSXEC5lcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKJ2t+El9Ur/V1bDZxCQEilKWnZze5WPaLTVICQ8m+pZ1ED1Hn2HqRKlaIp5oARFWHJssJbJhrTO6SFma/1pz3NSsspIrizH1wb2hy9AtwgVFV+0rg+1fYtI8zYYoLO2RrTA1W7XXfuuwHkox+4Vp5sgxAOTgCuZ6264NhwYWd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdZwd8s6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdZwd8s6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54781F000E9;
	Tue, 21 Jul 2026 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660539;
	bh=XUc11RNtbO9DUBZrEg7FsAHXIB6hX6cP/Sda4DVG9Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdZwd8s6V1zFW7OXUXP6tASY7gYZaV5si2qKnuZHgT6UckX1LoTxu5FhClEagqbSG
	 1DoGSNdlmn8qnqsdArrNjVfi/O9+9WPGWo2eYNpBLOibhjU//o1z4CYOtzhPqd/NcV
	 NdjAbmsrc8Wb7Ih2qv1b5Y8kxZbrTodQdAl24fK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1011/2077] perf tools: Fix thread__set_comm_from_proc() on empty comm file
Date: Tue, 21 Jul 2026 17:11:24 +0200
Message-ID: <20260721152616.662082307@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 22be77225bb0cc..2faa258f9c15f4 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -294,6 +294,11 @@ int thread__set_comm_from_proc(struct thread *thread)
 	if (!(snprintf(path, sizeof(path), "%d/task/%d/comm",
 		       thread__pid(thread), thread__tid(thread)) >= (int)sizeof(path)) &&
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



