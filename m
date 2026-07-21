Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B60146AA82;
	Tue, 21 Jul 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648366; cv=none; b=bwu8XKOK5hXcbb0RUUg5NhtQENLYYrneRwtDA1dpt7MUCOGxhC3ZiYqh/k2sPhYGKFMdTPKUqpXUZTQYfbE0YZjD0r2bUVVb2Kj7uTlzGX/nPwXXUouz1b19zPZ8vUIbnJmpJiY1gSdPuFEYmGQapthrRjtefCxAkNQAgL3aWLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648366; c=relaxed/simple;
	bh=UGQp7g+PpsS/XOGpP2NVapuA7BfVKrapPLvAlYBqjUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDKOhplT9HfW8XsMPt9cnflKXIOxTqSWhbuuX65i9bUkMjV3OmxiFgDIJDbDTWR1d7sbC+9SI1xnaqUzzOQ+GuVPqw6yuMVXTww876iGN4Eearba2AYMuDUVjxVBKIp6CIh0uo6VCYOCAsdIr3HAN/9ppPq3ZQfjpCHkpvLSIzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/TU0sUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/TU0sUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CAD1F000E9;
	Tue, 21 Jul 2026 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648365;
	bh=qI6mj0sXXTZR1OP9+bksxcUS47XY4tPXQhO7g3cGtQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/TU0sUXvAIlHROvHE7h0HWogPmRyL2FyY8OJEKfAA3PC1J7g2VBzsGatlbRoiTli
	 JQrQrU1Cmu6byrzAq1BigiDMz54af0//21TkLQswJCLJyWdzNshEdAlVkqA2UF5Iw1
	 h23waav7DtemtSiFtjfW4eBXshLAevkTTNQ8Bo6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0170/2077] dlm: fix add msg handle in send_queue ordered
Date: Tue, 21 Jul 2026 16:57:23 +0200
Message-ID: <20260721152556.699621895@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit d2248cb70c070f8f04762872772e155b59016f17 ]

In a benchmark scenario triggering a lot of requests that triggers a lot
of DLM messages on the network it can be that the mh->seq is not ordered
according the oldest seq number. This ordering is required by
dlm_receive_ack as "before(mh->seq, seq)" will stop to check for older
sequence numbers that are ordered in the tail of "node->send_queue".

The side effects of not having it correct ordered regarding
"before(mh->seq, seq)" are refcounting issues and use-after free.

I only was able to reproduce this issue in a experimental DLM branch
and a user space DLM benchmark that uses io_uring. After changing this I
don't experienced any refcounting with the sending buffer issues anymore.

Fixes: 489d8e559c659 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index d54bdd8fc4f2ed..64826a9b79a557 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -968,10 +968,10 @@ static void midcomms_new_msg_cb(void *data)
 	atomic_inc(&mh->node->send_queue_cnt);
 
 	spin_lock_bh(&mh->node->send_queue_lock);
+	/* need to be locked with list_add_tail_rcu() because list is ordered */
+	mh->seq = atomic_fetch_inc(&mh->node->seq_send);
 	list_add_tail_rcu(&mh->list, &mh->node->send_queue);
 	spin_unlock_bh(&mh->node->send_queue_lock);
-
-	mh->seq = atomic_fetch_inc(&mh->node->seq_send);
 }
 
 static struct dlm_msg *dlm_midcomms_get_msg_3_2(struct dlm_mhandle *mh, int nodeid,
-- 
2.53.0



