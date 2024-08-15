Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C4A1A705B;
	Thu, 15 Aug 2024 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728830; cv=none; b=HTxj+0bl0GbOUnHvyjswXOcc8joyCbFDE1Ev/SaWP3tV+9pY7L//wWjiIAqsRJbYI6V/S9n7Lq0KszYy3l++95UqbBpAk4WnlP+IPkWbG4LG4Lg082Q7HyboxXQaq4ZAx/Jbzddaug/RZZ6WBE5/kv8GrgCYWX69Rymd5fuvvqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728830; c=relaxed/simple;
	bh=1V78jLOaWm/uhyGu5tUqDbtM9RxLYQ63VLnP/xML01w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW2NRBB+uGji7d4d3VrJljfosOGIBAAOJ50TGADiLHXGtUex4hNjn+WG5GzCKEnmONnaWPhqgJjNYujmioYF6XtwXq5n/6E9LbKSd6UjNSuGM9vqP5jAcG/QX8ChDPjumU2R5Q+IY4SLcAokWUeJJkLy0EH+a+c36ynh+5igPvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr4r9vl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr4r9vl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A659BC32786;
	Thu, 15 Aug 2024 13:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728830;
	bh=1V78jLOaWm/uhyGu5tUqDbtM9RxLYQ63VLnP/xML01w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr4r9vl6xBCyyV1ZhJwjPKYTtYFgsdS94dykoqEMI7bRmNchA5Y4pBN24roNwegtg
	 GFuQ2s64Z/oIB9jmT4GVLT7zwAJVlYnAjbbRIfMabxYp4QeVrnO2hjXk9ZPFfrPEs3
	 MS4hI7J30BUdlydEUEygeOdBck7DxtTIRPZaVukU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/196] net/iucv: fix use after free in iucv_sock_close()
Date: Thu, 15 Aug 2024 15:24:01 +0200
Message-ID: <20240815131856.820244386@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1ff2860dd3ffe..50725e2198f4c 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -456,8 +456,8 @@ static void iucv_sever_path(struct sock *sk, int with_user_data)
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



