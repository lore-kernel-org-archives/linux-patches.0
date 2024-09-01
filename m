Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE7F14290C;
	Sun,  1 Sep 2024 16:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207879; cv=none; b=Bbb1QtWlMocGQ+g+J8xut/GNhnpzF+kKWrOKldpqomBqsRj2dXpyvHJpodxwHcSdnSGEFK+30m0xhYG3Q3dhEMf1sl7OZhTisggJ9iC44srwet3B1rQmEi/6Ssv4vQb8NJQPHwnQ0TkyknFGeXNahd8FawJMmGs80uxhrtLbxaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207879; c=relaxed/simple;
	bh=z7UJu94i3e36Bymp926qgV2hkPsaIpVHob4ixixY190=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cxjh8wa0sVErIefMsAQNCHDC+JeopjTxJa449uAaAZGjrVj5tC7RFDcDx5Ie6VNwNi3fVUQE87TpFAfu1s70pY6MUJQPFSJrtG54bDDDl91fA9KUaWhEPI4pyUvuE6XzchKGCUOwsODZYIV5sQXLFpN7XAQfqKvjX/seN87jA84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEUaSY0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEUaSY0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753CCC4CEC3;
	Sun,  1 Sep 2024 16:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207878;
	bh=z7UJu94i3e36Bymp926qgV2hkPsaIpVHob4ixixY190=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEUaSY0F5goBPLQQ188/lVLueRdR9hfaP9VhGIn7j6B6GHugP0Gqouxt/WmbhBZMf
	 rg4GM7qAKKg2ERXUTwox3extU2c3OR0rUcnoPVRnfRmLSHGYnn4CXU/E55iWe+u9WO
	 JTPKAbPOkNxol8HXdiMQ77NdWFJiWcWUMXkHWsgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeelb@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 97/98] ipc: remove memcg accounting for sops objects in do_semtimedop()
Date: Sun,  1 Sep 2024 18:17:07 +0200
Message-ID: <20240901160807.356007930@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@virtuozzo.com>

commit 6a4746ba06191e23d30230738e94334b26590a8a upstream.

Linus proposes to revert an accounting for sops objects in
do_semtimedop() because it's really just a temporary buffer
for a single semtimedop() system call.

This object can consume up to 2 pages, syscall is sleeping
one, size and duration can be controlled by user, and this
allocation can be repeated by many thread at the same time.

However Shakeel Butt pointed that there are much more popular
objects with the same life time and similar memory
consumption, the accounting of which was decided to be
rejected for performance reasons.

Considering at least 2 pages for task_struct and 2 pages for
the kernel stack, a back of the envelope calculation gives a
footprint amplification of <1.5 so this temporal buffer can be
safely ignored.

The factor would IMO be interesting if it was >> 2 (from the
PoV of excessive (ab)use, fine-grained accounting seems to be
currently unfeasible due to performance impact).

Link: https://lore.kernel.org/lkml/90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com/
Fixes: 18319498fdd4 ("memcg: enable accounting of ipc resources")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/sem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1962,8 +1962,7 @@ static long do_semtimedop(int semid, str
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops),
-				      GFP_KERNEL_ACCOUNT);
+		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
 		if (sops == NULL)
 			return -ENOMEM;
 	}


