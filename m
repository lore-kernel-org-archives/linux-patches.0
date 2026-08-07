Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D0547669C;
	Fri,  7 Aug 2026 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115079; cv=none; b=q/AJfTnm2Rv2bixxFI3h0tiRH0vPWfkkM/DCoSwgKYph7oDDAPIcfs/dCirblo3WGtkgG6iRnrJ4OduODudJHPFRxb5oVYPGrarW0JzpUWb1POZCzt/x4UFZMRlhOeLXU5etmMmqCOd4UhkTOzdIvqPSY+n9hwUeJH1L6Eo9c/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115079; c=relaxed/simple;
	bh=HqbsZ0LimkRUi1BKZT8dZ5G3qUXOr0hU1/UmN7ztJ3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8TswI24uoCPvBrhOBivf6+Ac+XnqDA+axQTCBEI4kridhmd34s3Ekrenp/7pSDgraViq8OqnMlUdhInFHzoFcYrF1pZ4tjhkYbUoF+Mgn4szOMsWwJ1x5NWUyVEO9WGcf1gP3Kx6wWR5SxRLEuhZLwiI6V5us3CBi4/fwdTE1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eueXjMmo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eueXjMmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043991F00A3E;
	Fri,  7 Aug 2026 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115073;
	bh=5XnmAMIYKji/EJebYP0VMiuJFmgmXoF7mjh1JwnfRGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eueXjMmoDbPovIVx3x4NOuWTBRM6wCOHnPvBdoivoBeKerQzTT1XCbE6/bUyfTPQ6
	 x9cPEPaJexyJkwrs9lqY9m2lPLSZjgtqEVuCyiH0um7z+7imDiYcz446w3heIYvseA
	 jT6+RrY+tFZUlXb0FsEr7Ga8CzrLmFMc51375xsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/396] sched/deadline: Use revised wakeup rule only for running dl_server
Date: Fri,  7 Aug 2026 16:35:09 +0200
Message-ID: <20260807143427.523650411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d5052f238adf7..e8b9cf0767b27 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1036,7 +1036,8 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
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



