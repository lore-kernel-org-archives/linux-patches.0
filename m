Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FE0395DAA;
	Fri,  7 Aug 2026 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117051; cv=none; b=aPYEfLpIpjiCBUhVVwjCX9NvQ1aHBud1znCOeXxLCTRHYW2xNgsZm3XnHuBqMJNMZJdThamwFxmrrElvyBXkw2Y8Oo4XxEwAvo0jFWA12Agnyy0VqY+bxd94JRx6QarP29YQVQT64xk+NVKHrg0tVsryQHgwf3JvFB5ph9cSvXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117051; c=relaxed/simple;
	bh=Cs82OO6H2z2C/7eJSWlj3haFYNvdz+29NB+PWr11im4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+v3pQU2kiZf+Tu6ENCBQMKipZFT9Goczzap6ibePVbIfuxvyknz66AluNPoYhdDoii/JhUloUTjl8XBspMcpsP3S6aUdFJ5JvtDnA4XkFOxts6lBWdD+uFlwDPRX8YujFw4XJoRaTRw8OZwOto22D2vJmiouPAIx39KxBbzQzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/wdEvxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/wdEvxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0100C1F000E9;
	Fri,  7 Aug 2026 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117050;
	bh=yM7378bOzzs7LU2u+w2Expzppb4gUNHdl5P+06ogobM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/wdEvxgFl3OznjL0PAoLDBAmVY6Hh3mP5Ionf8NNJe8cY8Cv6qCNZkHMONCaVtIb
	 GA6Pjv1OESSQtYoDpabRY/jt8e0jr8/zThLq1WImDJbENTJt7YDp5W+7KUdHEQJ3t8
	 Kxw5jHQmgUY3Mh2bvs2xbTI4cyDZHtu/VR0OhKN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 183/438] sched/deadline: Use revised wakeup rule only for running dl_server
Date: Fri,  7 Aug 2026 16:36:19 +0200
Message-ID: <20260807143431.933990709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 1842bf97af109f5ebf830175c9725bf81ebb78b1 ]

Commit 14a857056466 ("sched/deadline: Use revised wakeup rule for
dl_server") applies the revised wakeup rule to any server, as a result
servers that are not running (dl_defer_running == 0) and start with a
deadline overflow get enqueued and can boost tasks as if they were
running, invalidating the defer rule and the documented state model.

Apply the revised wakeup rule only for deferrable servers that are
marked as running.

Fixes: 14a857056466 ("sched/deadline: Use revised wakeup rule for dl_server")
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Andrea Righi <arighi@nvidia.com>
Link: https://patch.msgid.link/20260522125833.264145-1-gmonaco@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7db4c87df83b0..e5a7701a8af71 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1017,7 +1017,8 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
 	    dl_entity_overflow(dl_se, rq_clock(rq))) {
 
-		if (unlikely((!dl_is_implicit(dl_se) || dl_se->dl_defer) &&
+		if (unlikely((!dl_is_implicit(dl_se) ||
+			      (dl_se->dl_defer && dl_se->dl_defer_running)) &&
 			     !dl_time_before(dl_se->deadline, rq_clock(rq)) &&
 			     !is_dl_boosted(dl_se))) {
 			update_dl_revised_wakeup(dl_se, rq);
-- 
2.53.0



