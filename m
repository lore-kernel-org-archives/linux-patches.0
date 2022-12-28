Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649981863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8E5C433EF;
	Wed, 28 Dec 2022 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240388;
	bh=udMDw423tMPoLJhSl+vO+UtqlbZFbxkuHR+1iAEP2tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaUcrifuHWgWjlwriy9+LnO+oF9MSWzwhnUBvx+reTME/zc0ds6s1//XUhSzsS5ID
	 kVC5pDm2Y4sgpdIpz4bSA9sqjDQ/qS7ATupPUiNhXYop27c+6uw2rGUgviLB1GapeW
	 HRQSnAj3gJfZCBL6k9/8ZPyMFd17OhPiwzPiWTWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lee <haolee.swjtu@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0116/1146] sched/psi: Fix possible missing or delayed pending event
Date: Wed, 28 Dec 2022 15:27:35 +0100
Message-Id: <20221228144333.308334203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Lee <haolee.swjtu@gmail.com>

[ Upstream commit e38f89af6a13e895805febd3a329a13ab7e66fa4 ]

When a pending event exists and growth is less than the threshold, the
current logic is to skip this trigger without generating event. However,
from e6df4ead85d9 ("psi: fix possible trigger missing in the window"),
our purpose is to generate event as long as pending event exists and the
rate meets the limit, no matter what growth is.
This patch handles this case properly.

Fixes: e6df4ead85d9 ("psi: fix possible trigger missing in the window")
Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Link: https://lore.kernel.org/r/20220919072356.GA29069@haolee.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index ee2ecc081422..7f40d87e8f50 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -539,10 +539,12 @@ static u64 update_triggers(struct psi_group *group, u64 now)
 
 			/* Calculate growth since last update */
 			growth = window_update(&t->win, now, total[t->state]);
-			if (growth < t->threshold)
-				continue;
+			if (!t->pending_event) {
+				if (growth < t->threshold)
+					continue;
 
-			t->pending_event = true;
+				t->pending_event = true;
+			}
 		}
 		/* Limit event signaling to once per window */
 		if (now < t->last_event_time + t->win.size)
-- 
2.35.1



