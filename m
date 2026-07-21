Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56053672B8;
	Tue, 21 Jul 2026 21:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669406; cv=none; b=DGS8VjpIhLY9FV3zp6+RxdTRiDzYNk78XCqoBrrX5Ta6O8ZSe7U/a9oLJC6nKv3AR9LQX+lxqjHQ7rjnV4c7C1chNKI8LVTUtCawMP9HGQ6JwRJwMZD/18dzHgz1+HVIQ1+fVT59EPjqsGOGuHMZlX9jhy+O0ZYIq+DXLpHNUA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669406; c=relaxed/simple;
	bh=VpSxTCQqVHIZyQbLbKc1DhL6X4VrkZuMHkqLeqhjen4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/F+5IHrNfnwLq9f3dGQzZaUlR8GZ4GXzfjfhALsFiTXMlstxHsZogCzJ5Mo35xhci8WQDZK+UODQzjhgQWE2yjFGO4R374x+NB5J9ccQWviRAXaOuihon9m0OVnH3eUr8u7QMTA1Q4UhlkFPpeb76OKSZ9TvMbjhrB5V5oGqsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzJxOoYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzJxOoYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B481F00A3A;
	Tue, 21 Jul 2026 21:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669404;
	bh=CYuxqVohyl8MnGkTUZyffX8Llbo5m6ZZIdripRTgspE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JzJxOoYxqf0m+nzIUJnNpmArJQXgA66yt9Z1l3J4+cyIkFAmgrjwkuMyIznj9b8JH
	 0fB2SWvJ8Cm3Y8t8lLM7IV2dkNl3nFKQ6KgWHnoQZc1UxLkGKwfnJZ0vkdQiIZxXOV
	 ObsLPMJW2vtwR+wmRGr2PzeHo3zpUqGTT8YSEZqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0542/1067] perf tools: Fix thread__set_comm_from_proc() on empty comm file
Date: Tue, 21 Jul 2026 17:19:03 +0200
Message-ID: <20260721152436.735828095@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e3e5427e1c3c87..4098a677360e1f 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -283,6 +283,11 @@ int thread__set_comm_from_proc(struct thread *thread)
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



