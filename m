Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3ED1AC896;
	Thu, 15 Aug 2024 14:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731581; cv=none; b=Ak17jO6Cgc9emgYejJUWTNZ/v3A/A3CwwETDmWnbN4FOfQzUISSKt+/kWSWLbA/GU7E6I7NlPZ8XbXEPpimwufg7dlCBoA3K64Nc7MoYjbfuQnIBkUJlKtzE0RXa8S3eunsdZDn/bpS5zX5dSvWCty4m4GZpAh+7tniLkkrZhFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731581; c=relaxed/simple;
	bh=T3mPAjS5e7rXAFVwFpLHlpyHqLbef4233vPicsckW3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJsIQMH5Nctz83xDWrxm0l+gTp1UAUamDE+lNH7tz6el40XQeWaG7Q1wTstHAxm8Yct+AqONf0wXIuAubFGZYiOmLWLYivPj/gzoSooWT/7SxcoE7fyd2bMdi5IVtzmljP+M8E2Cn7GcL/+olZSWojCLHzCkQmN9ETaNG01P2Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/2xpYKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/2xpYKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8776C32786;
	Thu, 15 Aug 2024 14:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731581;
	bh=T3mPAjS5e7rXAFVwFpLHlpyHqLbef4233vPicsckW3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/2xpYKKJgh78e1MLMKQziJ0RPjlDfJlJYPP9aHK9d5NgO4vY+PoK9MSSENu6QXlo
	 v0GtO7O2MTNnCXdcTR0H5LrKoPMPzyLaHQCoOHZwVnFkE0RKzd1tCVV31vJUaCrz/Q
	 Rz3jewn7HuG+w1vKh6xJq8WXCJ5ZBG22nIRietqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/259] net/iucv: fix use after free in iucv_sock_close()
Date: Thu, 15 Aug 2024 15:25:08 +0200
Message-ID: <20240815131909.535441661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 652285191da1e..74cf37f17ea90 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -453,8 +453,8 @@ static void iucv_sever_path(struct sock *sk, int with_user_data)
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



