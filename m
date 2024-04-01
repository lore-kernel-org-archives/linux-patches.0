Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A313D961;
	Mon,  1 Apr 2024 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988451; cv=none; b=aTc6b6VdmqG5wy9lU28t4p/qkvf0MezHY4IBoRuOyryNvZ+EcK7x3o4hMtz2LxxXUl6vRxlf6/UhSmOqotkdWn6Y2Cs+XMP2WC3VJ7TNSQ2bqkliD7zeY2TyctVtPAPdjAaqaQUbBp41FdeuO2azH4Br6WSnROItWI8tfqNqhqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988451; c=relaxed/simple;
	bh=O9DsyFeNTSEjt1ovcjgT7xRp7lYWszFigJMWskjspic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt7jCyD1kDgqtJMxCYcnneZK+tTZXvTb+UK95IpXK7xp1LUB6UQQgAo7X0ri0pHMfV8pefv47xTEzaq6h7B3ZZ0LHIVB/f3fsic8k/PuUlZLCMWv/SPn86opgHt9BIyiW/Bqd6g6ulWlly4aP85m/G/ghdmWb7y7ADRTJeTMLkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFsAdir9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFsAdir9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3293DC433F1;
	Mon,  1 Apr 2024 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988451;
	bh=O9DsyFeNTSEjt1ovcjgT7xRp7lYWszFigJMWskjspic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFsAdir9CpHQfNKOcpQa2uyP9RxrsdOKXqLot60oI7yE01vK7dr0dS1PBgPk25wUW
	 pMZ+WX6NHUfW5S9pXYOUwq+0Ip7zbGFM8pw9hwAK8MhVvhylT7XwemwCbOqJnWO05j
	 mKDJ1TDGzNypaO4A2MVAW0z2KJQWVha9f8cc3KXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 188/432] io_uring/waitid: always remove waitid entry for cancel all
Date: Mon,  1 Apr 2024 17:42:55 +0200
Message-ID: <20240401152558.749067258@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 2b35b8b43e07b1a6f06fdd84cf4b9eb24785896d ]

We know the request is either being removed, or already in the process of
being removed through task_work, so we can delete it from our waitid list
upfront. This is important for remove all conditions, as we otherwise
will find it multiple times and prevent cancelation progress.

Remove the dead check in cancelation as well for the hash_node being
empty or not. We already have a waitid reference check for ownership,
so we don't need to check the list too.

Cc: stable@vger.kernel.org
Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/waitid.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 6f851978606d9..77d340666cb95 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -125,12 +125,6 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	/*
-	 * Did cancel find it meanwhile?
-	 */
-	if (hlist_unhashed(&req->hash_node))
-		return;
-
 	hlist_del_init(&req->hash_node);
 
 	ret = io_waitid_finish(req, ret);
@@ -202,6 +196,7 @@ bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
 		if (!io_match_task_safe(req, task, cancel_all))
 			continue;
+		hlist_del_init(&req->hash_node);
 		__io_waitid_cancel(ctx, req);
 		found = true;
 	}
-- 
2.43.0



