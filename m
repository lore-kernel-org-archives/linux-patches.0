Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB417484888;
	Thu, 17 Sep 2026 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660031; cv=none; b=fUMx0+2OTy5GT645U4EBBRtVerv/ZskkKkBeAA8qf+bDdQw7d8Zcb1gyKMdhvhjqsBDig2t/AYjQfJRUkRHwjjlUEaejbVENqD00Hib2EieyMdf2B023Hsbxf4eOhMeNFhwI783TRFaL4X+8+FNFtH1Ndb0Y1012DnnrRQ1FmIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660031; c=relaxed/simple;
	bh=oRI76PfWLmWHiTzNDo1SFPfqNduy/roILFgS22uYgfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBhcEGtGxpeofa5B3E10++E1BegGdj1/ooi8wKgkeiN6G4fEK1wo0/tKItH1bgEP26Dbtq4dJDPsRqavtiazVkmVmZFDlfaZb+7xQMHA7y31JGx28Xmn341dIAFnYUOdGQRzDKDSWawJEhqX1Oiri8TdXwhpp0EHAhLTkOvQu7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBTjW2Pm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBTjW2Pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EBA1F00893;
	Thu, 17 Sep 2026 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660026;
	bh=rLMHGlntcXW8iOPoFA9bSWGaTAYskE1+cNb5lE3sSXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBTjW2PmquO1Oc3zdyb2yOAH+2L7tkI8VvqR/9LqUai+Vx62JzUziGsJ4pov7N4g3
	 +llR7cT54m2mksYGp8bHmhYCmwYVyn3oQ3FRW5KerMRu3Bk3QRMGLnuQY4yBnXKBlq
	 b0G/6y82RKZsqRsMPJ+ZlmGkqiPf0qTi1wNRg6NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 416/733] sched/eevdf: Fix augmented max_slice
Date: Thu, 17 Sep 2026 16:12:04 +0100
Message-ID: <20260917151402.155076506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 9a8bc9bb4c3fb3218b4f151f98a722fbeb5b5c34 ]

Similarly to se->min_slice, init se->max_slice with se->slice before
enqueueing the entity so the augmented callback computes it correctly
at parent level.

Fixes: 6e3c0a4e1ad1 ("sched/fair: Fix lag clamp")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://patch.msgid.link/20260907123855.1297976-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4c7bb4b7018e2..83fe5319e2ccd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1042,6 +1042,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	sum_w_vruntime_add(cfs_rq, se);
 	se->min_vruntime = se->vruntime;
 	se->min_slice = se->slice;
+	se->max_slice = se->slice;
+
 	rb_add_augmented_cached(&se->run_node, &cfs_rq->tasks_timeline,
 				__entity_less, &min_vruntime_cb);
 }
-- 
2.53.0



