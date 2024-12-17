Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1437E1F429B;
	Tue, 17 Dec 2024 17:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456295; cv=none; b=nEdfsCc4+05DKkcOE+o5q2PvJrmI078Im3YG/+slfpiSasHuyEfehT5jBSe6KzlSue5JlnFmdr4FFUUCbOX+Gwb2S5MeZiY5pGw9vi0wdbqbwyU1wHVsqYaXKcsFrY6AD+fm1NY3ZkPzTHpqERUHD2AXK2R8lrbk2NZtnJyev4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456295; c=relaxed/simple;
	bh=yUlWImonp6WTqAZLjUgyp5yyUpcwF+75okfTcv7PkR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg5Dxa9/nPk9kgAgZBfsJ9mcabv4ht0BiOJ/4T0t59IqJITMqvyTYDDsnIxIBoEO1mubrZkTGG1tWfKKIhH9Cm8MLRYcycz0keGOQaWpQbxYwYmOxbFRSEow9zQLgcPQ5htTWOi/e1iQMlndDieEB69WDxeGiMtZvx4fdOi2PsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fttmwNWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fttmwNWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCB4C4CED3;
	Tue, 17 Dec 2024 17:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456295;
	bh=yUlWImonp6WTqAZLjUgyp5yyUpcwF+75okfTcv7PkR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fttmwNWBaDXwCLAbVXno0pbiwYS9M2aIIaO//Le2GenkAYkUZ0toEvJLolUYlLWHp
	 D8CGOe5e/frRe1eIMJfZvHUrDhpL9aejYsu0zzh3OnBhe0PxfSdRYyj99hk/QJi0yo
	 D916ktVOZ0QmpEOY1/SM/v0idtbwRZV9ce0Y8f/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 004/172] sched/deadline: Fix replenish_dl_new_period dl_server condition
Date: Tue, 17 Dec 2024 18:06:00 +0100
Message-ID: <20241217170546.412075790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Juri Lelli <juri.lelli@redhat.com>

commit 22368fe1f9bbf39db2b5b52859589883273e80ce upstream.

The condition in replenish_dl_new_period() that checks if a reservation
(dl_server) is deferred and is not handling a starvation case is
obviously wrong.

Fix it.

Fixes: a110a81c52a9 ("sched/deadline: Deferrable dl server")
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20241127063740.8278-1-juri.lelli@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d9d5a702f1a6..206691d35b7d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -781,7 +781,7 @@ static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 	 * If it is a deferred reservation, and the server
 	 * is not handling an starvation case, defer it.
 	 */
-	if (dl_se->dl_defer & !dl_se->dl_defer_running) {
+	if (dl_se->dl_defer && !dl_se->dl_defer_running) {
 		dl_se->dl_throttled = 1;
 		dl_se->dl_defer_armed = 1;
 	}
-- 
2.47.1



