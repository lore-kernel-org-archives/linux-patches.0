Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB313EEAC7;
	Tue, 21 Jul 2026 19:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661527; cv=none; b=TUTaTVrgXO5hfxHwNbEiUykkgKor2qHKT8twj/hmrRvj7UPUAUho4X2HmB7NsByqxx3nT1ElelQCjkM2g4Cf3hIv5Xh7zDli7/q6vvFEIGG7gYQsoR3hD2mccQfiltoH5stUjmZxAcI/FsGwxdxuyS1Gg8VLnp9y/ot/ucilJgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661527; c=relaxed/simple;
	bh=Tt6hGiENrzpWgyP0yRT0CYv+7ttJbJKGQjJ3OY2Znms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rux8Hsq55zvwkCzQhZp+egRcyDRuRwK+rjyB+D+skHEj4Jyuz8xqvzgKao9D8qx+TOiUi9+dTSIVOaG+4IXTV2spejM//MegkLbXJSTDBuGjjbMt9mmqKopTDQ+VfWxmoqlI90h7/Qco7ka9//3l6V0u0AS42hkyZ1dyaHShf9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ol8WSJ+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ol8WSJ+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3C21F000E9;
	Tue, 21 Jul 2026 19:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661526;
	bh=bcVrGpz/nJNvROlfFilLxAaHK+w6YBugUGDIP6/3ZTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ol8WSJ+WHudK7EiX3jc87yK8RblBV4qFeeCWSOuQ/7rsWMHr/peiHVpitC16eojzx
	 cHqadRcN/DrnbFjhcNTHl/4GJ1TXjNRmLBfIOEh5kEMIT3NSOkYKixKCL6w4HQLGHh
	 njDASPcg31Mvf56/duvUt8RHmKsIbnsVUQCqANW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0101/1276] dlm: fix add msg handle in send_queue ordered
Date: Tue, 21 Jul 2026 17:09:04 +0200
Message-ID: <20260721152448.355002601@linuxfoundation.org>
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
index 2c101bbe261a4b..2015a5f40a1426 100644
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



