Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43CE3C1F2B;
	Tue, 21 Jul 2026 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655750; cv=none; b=neETnR1zbctC0m3WOpigSbVSA1tHyLlYVX17kvdutPPYo2FVi2m92R3j1AKY+FGsbqyUv6m+lqETAueeM7HX25n7RpL+dJbdgaEnUFgyrWSfI8l9AgBHT02TeZ32hQN+T4nHIAmTMQMekJq6b4dPEh/fKV1phIO7fdli4RNleag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655750; c=relaxed/simple;
	bh=tCdOtRhnGpdDgeuky+D1OTuPVSpcwhkQoOGREhd/Mfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJYSz7mVPLHCNnWAsO4CsP/THnNK54yFAoYLZY7Spzi9amn9e6rNaQtxjuH7m/K+A0HuvVhFuON98bIe8qDKEpgrwJWs7em4/Xdk+4W9ZazC1kFUnbOcFgndI1F6+HaRmS/NIjFK24qDsC7f1ywsZvGGdnToKEvp+F4zyolQSPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1CI97xy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1CI97xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ED21F000E9;
	Tue, 21 Jul 2026 17:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655749;
	bh=oYTVAUCiW3nGPUz2+axZERv6cdZDOAoQAs7ij1MnhCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1CI97xyihQw+CmWbq40D4BMV38Lr0F6/RydlgIxahoEDvJAzeXvaU0iT0jpztkkc
	 er6ZFE7LhZutYofcM42Vvr8zPckgEpviN/VCXbM3DnNENLsdSryR8R7bNHCjFYq5lz
	 PLJv0L4eSsKZ6tUmEhA0QUMIRFUEuMPbjNV9a4jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0126/1611] dlm: fix add msg handle in send_queue ordered
Date: Tue, 21 Jul 2026 17:04:02 +0200
Message-ID: <20260721152517.702628851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



