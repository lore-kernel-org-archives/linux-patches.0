Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADA615CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021A8C433D7;
	Tue,  8 Nov 2022 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915500;
	bh=Dq79fqTxpTRURbIJ4XdjngXkz7bksTkEYAMlmCyKEe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHkE6ZVBBFV/vyQ8B8BouJPieNhHMYWqliC8G/9ONdk5xc1WGtQ/0Z6Kq6C4xrd1q
	 WJDm4RoBBbEo0YQ78A5MJHDNfsE+X8mhLyCLtwAANNIMxsACcKqCCbUcdKisw+7Zdu
	 i8c2CocsrkeAt/CjypDzvUWUOESN3P6SpoCiuSzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeelb@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 74/74] ipc: remove memcg accounting for sops objects in do_semtimedop()
Date: Tue,  8 Nov 2022 14:39:42 +0100
Message-Id: <20221108133336.799447364@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
@@ -1984,8 +1984,7 @@ static long do_semtimedop(int semid, str
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops),
-				      GFP_KERNEL_ACCOUNT);
+		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
 		if (sops == NULL)
 			return -ENOMEM;
 	}


