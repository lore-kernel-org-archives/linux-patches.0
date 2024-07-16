Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC61E19DF71;
	Tue, 16 Jul 2024 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145348; cv=none; b=ge3ux3CGxNJ7FEqlNNTZFKnD8UJ2TY8jvqGoD9yeCS90LBkGIh13dha/3TMIbaRbDCuGjYpxwOXOdtz+cVKwfXmJfAEoqcUHFoK8vg8GVkYH+VwdCRVEcchYLHNtpte1BxpMpBlPru/fkcYjR6b5D5ukdlfG3lHAnHXk92Xgl0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145348; c=relaxed/simple;
	bh=+CP1Nkp1R9UJCS96faFpx3NU+PgbJLruAKx6MFXR7Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxNKdi/i//UTZIOclD8Hr4W8wMfsdL0VtxvHxgtmabRMUYKwQSux9mmS4WR9S/bFHxX1G1CEGXJMZg7+JaXjbFQ3FlxWkjLfhgzMY/0tO2a9VcdGSptmJKA5YWIjiDJEIWPBWDIednHuv4gGjQy9Ah/LmdLmD8fqkEmUAfjJov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Tr0RDuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Tr0RDuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1521C4AF0B;
	Tue, 16 Jul 2024 15:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145348;
	bh=+CP1Nkp1R9UJCS96faFpx3NU+PgbJLruAKx6MFXR7Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Tr0RDuGBRSys5XREcm1HmP8GkpwJ3CW/0SJPjllw5f8CCrqRA+MlNt0GbjyShqfI
	 Ly2FLSpSQg4Gdxm35xtMoa+RJJ1H4y+jjnJEcHuEs/yGUKKj+qV4Uccb71Q7SItTt5
	 Z/caiQJn56e8xMSRx8eGXGA9QmDNgtZTI5bzO2c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/96] cachefiles: add missing lock protection when polling
Date: Tue, 16 Jul 2024 17:31:19 +0200
Message-ID: <20240716152746.840275932@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit cf5bb09e742a9cf6349127e868329a8f69b7a014 ]

Add missing lock protection in poll routine when iterating xarray,
otherwise:

Even with RCU read lock held, only the slot of the radix tree is
ensured to be pinned there, while the data structure (e.g. struct
cachefiles_req) stored in the slot has no such guarantee.  The poll
routine will iterate the radix tree and dereference cachefiles_req
accordingly.  Thus RCU read lock is not adequate in this case and
spinlock is needed here.

Fixes: b817e22b2e91 ("cachefiles: narrow the scope of triggering EPOLLIN events in ondemand mode")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-10-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/daemon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 06cdf1a8a16f6..89b11336a8369 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -366,14 +366,14 @@ static __poll_t cachefiles_daemon_poll(struct file *file,
 
 	if (cachefiles_in_ondemand_mode(cache)) {
 		if (!xa_empty(&cache->reqs)) {
-			rcu_read_lock();
+			xas_lock(&xas);
 			xas_for_each_marked(&xas, req, ULONG_MAX, CACHEFILES_REQ_NEW) {
 				if (!cachefiles_ondemand_is_reopening_read(req)) {
 					mask |= EPOLLIN;
 					break;
 				}
 			}
-			rcu_read_unlock();
+			xas_unlock(&xas);
 		}
 	} else {
 		if (test_bit(CACHEFILES_STATE_CHANGED, &cache->flags))
-- 
2.43.0



