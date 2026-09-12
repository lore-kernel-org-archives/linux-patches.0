Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28A0299920;
	Sat, 12 Sep 2026 09:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204143; cv=none; b=LhEGt6tBootGHaa1OQKcEKOng6tJLEFCIImbYRLL2C53TKCM5u4UOnNYcqW1ECWuYuHtDi8Q8n8oiK/AeqkN5BSehRqo5pgFv84OlubcPKawlpFZRxY7fYzQvGGRWrN173hoDHhrqy+v/XqU2Ue1/TRgtLJ2z9QtrxjrVEshe5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204143; c=relaxed/simple;
	bh=4DZu+tvFJtvRlOzJWR4n9TxW33XMY1os2xF03uC5Bj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw9mCkWXeaJZA32JxknhkuuK7N4kFvPObpX2ggeL9L2YsKdRV+Fbv/fS6pkr/ZnBlVIGkx+UEtHZTcgfQesRWgbGVOFOkgMp7qq7HDql2q9cS5/zH8zMpzOUewmwL5PfPJkLwC8WKfL1Z9ic/OQVGojokDrAh52XrjvttPffhxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adwZX0nI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adwZX0nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBB01F000FF;
	Sat, 12 Sep 2026 09:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204142;
	bh=ygQVHivMhIRzfBKqNkpoa2F4rP26RfV986PjiiEyi40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adwZX0nIOTFcHXNRmDHW0nf65YhVvWA79L2kuKFEivE8R7TkgkCmpWFlz2dzeFn+m
	 eFHs2b7cGfdH1XPCtyVJYyuTyv80eOlnhc3BJUkK1HKJA/e7YRUY3SMQ71UZhoQdgZ
	 y5O7Ae5GZrTlrsHWd9ywcGefmrdpdM0Bkd5vGKhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1550/1815] NFS: Fix delayed delegation return list handling
Date: Sat, 12 Sep 2026 08:55:00 +0200
Message-ID: <20260912065725.388943067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 68c03755577ac90e31e38c7ec787301cf6be5331 ]

The delayed delegation return handling added a separate
delegations_delayed list to keep delegations whose return needs to be
retried later. The delayed list is then spliced back to
delegations_return by nfs_server_clear_delayed_delegations(), which also
causes the state manager to retry the delegation return.

However, nfs_end_delegation_return() still moves delayed delegations to
delegations_return instead of delegations_delayed. As a result, the new
delayed list is never populated, nfs_server_clear_delayed_delegations()
always returns false, and NFS4CLNT_DELEGRETURN is not set again to drive
a retry.

Move delayed delegations to delegations_delayed so that the delayed
return path can splice them back to delegations_return and schedule the
retry as intended.

Fixes: 4039fbedcbcb ("NFS: fix delayed delegation return handling")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 284437fa3f872..ab3e441464a66 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -604,7 +604,7 @@ static int nfs_end_delegation_return(struct inode *inode,
 	spin_lock(&server->delegations_lock);
 	if (list_empty(&delegation->entry))
 		refcount_inc(&delegation->refcount);
-	list_move_tail(&delegation->entry, &server->delegations_return);
+	list_move_tail(&delegation->entry, &server->delegations_delayed);
 	spin_unlock(&server->delegations_lock);
 	set_bit(NFS4CLNT_DELEGRETURN_DELAYED, &server->nfs_client->cl_state);
 abort:
-- 
2.53.0



