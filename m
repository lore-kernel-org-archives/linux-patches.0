Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E74B0482;
	Fri,  7 Aug 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114092; cv=none; b=f/nndT+UeRZk6Ne6hC7tzbKqnACgDCtjq2BmN8zb6NWL+EU4LNgp0cv/fVqcvHGR0g5GS/6RTrLM++0W8rKruayZWe8PL5faI/heijaB5FAdu8Z2IG9iFNK7cky+B5qtbIth2gQCt0S6GS4jMtlS6hDHc+WMMCZKn8YbOwj4Kl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114092; c=relaxed/simple;
	bh=sBWI/k+6NfVoW0/M76GVHAeLoUTGLV4fnXLfABtsLUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMfdDNALxoG3ttJQ4fGaGRPBJMloLlzgRiu/s/DAULR5LTChoLAK3n/sqfF960jWw8nUFI+0Go5lgkXI3KqrQ+RUIeXL40Diie5ftDjuqxBEOLC6ela7y7kFMSEoZwz3yjQx33WWPqtYNHfTEccXCibKbUCojy9aY9lMqgzjgoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DE97+PCT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DE97+PCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D621F000E9;
	Fri,  7 Aug 2026 14:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114090;
	bh=cR/aqD6f1laEHSZe8qbg9WURa8IG2sBlXREOyPu6VqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DE97+PCT1hKqzOoa2UAHHkxmsWLWOHEuQ7s4cVikjzmy3BDCq+qy7KWR9mNWJMyLc
	 C4iavNqc4H0Uer9/kHmiOTWM2g78sZLqFsZSffVN5YoAVDU2+/QehlgEEmWnV3+Gz5
	 G+jlHMyHP1cIVL105iO54Y9dBqHrIDVXnqsUwNek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/337] sched/deadline: Use revised wakeup rule only for running dl_server
Date: Fri,  7 Aug 2026 16:35:27 +0200
Message-ID: <20260807143421.219275239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index cb8eff0ebd228..f5c64d1a019d5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1079,7 +1079,8 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
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



