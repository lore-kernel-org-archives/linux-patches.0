Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB65778C67;
	Wed,  7 Aug 2024 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043391; cv=none; b=mdsH269RZKKKikO8TIdLaP7M3gF1mBkuCN2DDPkp+9QH54JFFafkAi/JXyKB7WqDiwtrnXedsXHVBLe3bP4m+naCd+UJQVGYQeHMXKNPDvAjVICM8gzkfvSLzR9eZYg65i4NPKX+fw5f261G5Admz2L8J3MZ8p1/kT2SDE+9l5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043391; c=relaxed/simple;
	bh=+nnYFTf9K9KqEvFLT4RJBI+mxaxYBLKhdaTf5AFaKAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJ1pZbXOEml73KqHrBWRzMcPjoJuJHr8DFLZgNRkKnBH4yqyezMbHeJ3Lo7ibb5tRQ9j0L9VXkMMFJ1RpU2Q3WNV4VCP709c8Dmvsle+POvpi+NUBRxGT/Wa3Mf59FVe/+ckF10H+J9O1xencHcCFl1r6cabRWMvh7/g3wWYbSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Stk3DYMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Stk3DYMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C9FC32781;
	Wed,  7 Aug 2024 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043391;
	bh=+nnYFTf9K9KqEvFLT4RJBI+mxaxYBLKhdaTf5AFaKAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Stk3DYMSV8CfWxf2xpUDQNM/P9LqXpAcodFW3xpAmAUHS7gdbn22LB88hOcOcTxp3
	 NvFtUGxoD1UlbAWc2SD/QlCp7cpKiIZjdK6QO1ifMyHvd9IADr9s5FAWh3OTtaI2/Q
	 6Y8DqoEzqEVxHc05qiXYgasgV/hg9zKW+4B5sQgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/121] net/iucv: fix use after free in iucv_sock_close()
Date: Wed,  7 Aug 2024 17:00:05 +0200
Message-ID: <20240807150021.796980848@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit f558120cd709682b739207b48cf7479fd9568431 ]

iucv_sever_path() is called from process context and from bh context.
iucv->path is used as indicator whether somebody else is taking care of
severing the path (or it is already removed / never existed).
This needs to be done with atomic compare and swap, otherwise there is a
small window where iucv_sock_close() will try to work with a path that has
already been severed and freed by iucv_callback_connrej() called by
iucv_tasklet_fn().

Example:
[452744.123844] Call Trace:
[452744.123845] ([<0000001e87f03880>] 0x1e87f03880)
[452744.123966]  [<00000000d593001e>] iucv_path_sever+0x96/0x138
[452744.124330]  [<000003ff801ddbca>] iucv_sever_path+0xc2/0xd0 [af_iucv]
[452744.124336]  [<000003ff801e01b6>] iucv_sock_close+0xa6/0x310 [af_iucv]
[452744.124341]  [<000003ff801e08cc>] iucv_sock_release+0x3c/0xd0 [af_iucv]
[452744.124345]  [<00000000d574794e>] __sock_release+0x5e/0xe8
[452744.124815]  [<00000000d5747a0c>] sock_close+0x34/0x48
[452744.124820]  [<00000000d5421642>] __fput+0xba/0x268
[452744.124826]  [<00000000d51b382c>] task_work_run+0xbc/0xf0
[452744.124832]  [<00000000d5145710>] do_notify_resume+0x88/0x90
[452744.124841]  [<00000000d5978096>] system_call+0xe2/0x2c8
[452744.125319] Last Breaking-Event-Address:
[452744.125321]  [<00000000d5930018>] iucv_path_sever+0x90/0x138
[452744.125324]
[452744.125325] Kernel panic - not syncing: Fatal exception in interrupt

Note that bh_lock_sock() is not serializing the tasklet context against
process context, because the check for sock_owned_by_user() and
corresponding handling is missing.

Ideas for a future clean-up patch:
A) Correct usage of bh_lock_sock() in tasklet context, as described in
Link: https://lore.kernel.org/netdev/1280155406.2899.407.camel@edumazet-laptop/
Re-enqueue, if needed. This may require adding return values to the
tasklet functions and thus changes to all users of iucv.

B) Change iucv tasklet into worker and use only lock_sock() in af_iucv.

Fixes: 7d316b945352 ("af_iucv: remove IUCV-pathes completely")
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20240729122818.947756-1-wintera@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 498a0c35b7bb2..815b1df0b2d19 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -335,8 +335,8 @@ static void iucv_sever_path(struct sock *sk, int with_user_data)
 	struct iucv_sock *iucv = iucv_sk(sk);
 	struct iucv_path *path = iucv->path;
 
-	if (iucv->path) {
-		iucv->path = NULL;
+	/* Whoever resets the path pointer, must sever and free it. */
+	if (xchg(&iucv->path, NULL)) {
 		if (with_user_data) {
 			low_nmcpy(user_data, iucv->src_name);
 			high_nmcpy(user_data, iucv->dst_name);
-- 
2.43.0



