Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD03432BE4;
	Tue, 21 Jul 2026 19:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662616; cv=none; b=dex8u+hhkcSAbdlfd9xDXwDNkCw+NVu6nKbGocExCH//vul/dVGGTbTwDicMpBBULm00+ync55Wh2zI61nnWlzxZXrVfkBrE/d/hjDs81Xq0ykHw6im4owJ5EDR8EC8UWa4Yxz+mDWxwBkVhkobM1mIU8er0JjCplYIE5dqTdaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662616; c=relaxed/simple;
	bh=xVjLoEIOveJjHG/U5+lPkOlAMoOKF0iwksLWGwFw2VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOb41V1H+/q4hh5jHaSupwM2Zdb+MYafURrMocmSvc7ZOMukfuZ7XfZGxhoNYycts5SJYsE1rXvnzbq+mbGfkANml/3CQmFy7OUN+63+D5ptvEJekdVW72j7AXYw+JF+aCBtA4/ETddg3enwumxtr6Z5JG8mzf/1m/OgxcAh7Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc2aZyd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc2aZyd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E301F000E9;
	Tue, 21 Jul 2026 19:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662615;
	bh=0gd3w6FbGLPZDx279oZlp4hJQHxImDpFwguTnbwbDh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nc2aZyd6aaJcmGPH45HPDQZVPFJtNHQqiLPEBY8kACQKJyBIrf/ZN3wTYoT8UVLFW
	 tFNgLHZOLQXjdX+ioIYeqXTDJllD51IYlze7b70wPf1dS1WuvzxHUWILDI4ipFl5Oo
	 nX/hPCVs3OObKrIBDDP6V84Chs91L3rzeZMY7G28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0459/1276] perf sched: Fix thread reference leak in latency_switch_event
Date: Tue, 21 Jul 2026 17:15:02 +0200
Message-ID: <20260721152456.376500503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6d7106fb1c0cbc..c0fd6a8595d0f2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1175,7 +1175,7 @@ static int latency_switch_event(struct perf_sched *sched,
 		}
 	}
 	if (add_sched_out_event(out_events, prev_state, timestamp))
-		return -1;
+		goto out_put;
 
 	in_events = thread_atoms_search(&sched->atom_root, sched_in, &sched->cmp_pid);
 	if (!in_events) {
-- 
2.53.0



