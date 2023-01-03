Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704B820E4
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC23C433D2;
	Tue,  3 Jan 2023 08:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733874;
	bh=hDVLikRaD+dYEicU/B9QP3lVJLW68K9IQ9ghQ28tZN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aM8A6CevlJ5+Ddu71hRgJc5BG0pBFo4OxXPMQafxqXbJRiSkkEB9oOmwY+CRB/14D
	 kplXdA4wmxBflD5dh+nCmjXQICe7TGrh4tGQ+NJgteckEQJUAJvssaqOJl68LbZgF/
	 aWliWjucgF9WOFVwmObogr1zHXNWO6qIJXLpUWS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 59/63] Revert "proc: dont allow async path resolution of /proc/thread-self components"
Date: Tue,  3 Jan 2023 09:14:29 +0100
Message-Id: <20230103081312.165846780@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 2587890b5e2892dfecaa5e5126bdac8076a4e6f7 ]

This reverts commit 0d4370cfe36b7f1719123b621a4ec4d9c7a25f89.

No longer needed, as the io-wq worker threads have the right identity.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/self.c        |    2 +-
 fs/proc/thread_self.c |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -20,7 +20,7 @@ static const char *proc_self_get_link(st
 	 * Not currently supported. Once we can inherit all of struct pid,
 	 * we can allow this.
 	 */
-	if (current->flags & PF_IO_WORKER)
+	if (current->flags & PF_KTHREAD)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (!tgid)
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -17,13 +17,6 @@ static const char *proc_thread_self_get_
 	pid_t pid = task_pid_nr_ns(current, ns);
 	char *name;
 
-	/*
-	 * Not currently supported. Once we can inherit all of struct pid,
-	 * we can allow this.
-	 */
-	if (current->flags & PF_IO_WORKER)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	if (!pid)
 		return ERR_PTR(-ENOENT);
 	name = kmalloc(10 + 6 + 10 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);


