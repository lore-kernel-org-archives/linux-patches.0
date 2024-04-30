Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEDF129E89;
	Tue, 30 Apr 2024 10:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474644; cv=none; b=SSoLqruyoOnI/xPhG+V7fvfXaVCjeTkqQug/NE9ZpUG/Q7Pg/axpzayFhbBL15RfSXCgsBJnWflKhyekTfteGdltuHjmFJhga1AkVdHvPnp33qSrktCnu0j3F3WnpH3B4INcdXCUvoQ+0nP5ZyIw7L2A1utAUo+BDpMhVWQ7Ut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474644; c=relaxed/simple;
	bh=92nkpVf0d5g0Nr4I/uOGeSvr7tOvaLmD3U+lsRHZFqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbeMaDF79vRQnzG0jQdt6u4KeSxTZC6iduy+qFJ9rEiiccJp/r+vkvxrximPXp+myLzTzm3iDO1rLdChLSaF5Ry98lFXjRg/DtLMSjGIn3qwAnIGotYXONsBvB/UC/dnYe/q/bpltNpOnupJMMLfvGx+TksjGol/8X8+dYbdaTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/w3CIuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/w3CIuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E659C2BBFC;
	Tue, 30 Apr 2024 10:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474644;
	bh=92nkpVf0d5g0Nr4I/uOGeSvr7tOvaLmD3U+lsRHZFqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/w3CIuOo6Dvm63BHM+8QLmXRiMav8Cd3HZSKknanfzjUrLeUhs6pzjI9StrTlO6K
	 vJFw9aO+DuDJp+Io9vTaoTmgYaYTyK165CkXid1Z4EjqV/2XQCLAzD8UK9jgKj/kQt
	 lz4gnyzF2mh3QBCGrGerdZ57l9T1yM3TrvWufUpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 218/228] sched/eevdf: Always update V if se->on_rq when reweighting
Date: Tue, 30 Apr 2024 12:39:56 +0200
Message-ID: <20240430103110.095255652@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit 11b1b8bc2b98e21ddf47e08b56c21502c685b2c3 ]

reweight_eevdf() needs the latest V to do accurate calculation for new
ve and vd. So update V unconditionally when se is runnable.

Fixes: eab03c23c2a1 ("sched/eevdf: Fix vruntime adjustment on reweight")
Suggested-by: Abel Wu <wuyun.abel@bytedance.com>
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Abel Wu <wuyun.abel@bytedance.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Link: https://lore.kernel.org/r/20240306022133.81008-2-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e2b4e0396af84..69d2158873429 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3784,9 +3784,8 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 
 	if (se->on_rq) {
 		/* commit outstanding execution time */
-		if (curr)
-			update_curr(cfs_rq);
-		else
+		update_curr(cfs_rq);
+		if (!curr)
 			__dequeue_entity(cfs_rq, se);
 		update_load_sub(&cfs_rq->load, se->load.weight);
 	}
-- 
2.43.0



