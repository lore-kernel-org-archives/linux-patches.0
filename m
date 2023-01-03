Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48371186E
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC58BC433EF;
	Tue,  3 Jan 2023 08:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733812;
	bh=kYk+CyHTvusWeRE6FLerTNoyU3SGGs/7IyQp6NFH9i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiXwxyHwsamHXCHVyz4rNLdsYyptQMl/zvVUqXhfZgboL+aZvLJFJzEcSQJxYkhlP
	 0d3Wr1zajgnW/7IGcJq6qsrPRGhuLPNO6hnRnHto7vcYsN1QsFikWrNlKzbPS5+/Fj
	 7O05/O+NB3dk0XkTyRXpQwkjtJDXVZGqvLgqZUrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 52/63] kernel: stop masking signals in create_io_thread()
Date: Tue,  3 Jan 2023 09:14:22 +0100
Message-Id: <20230103081311.715297433@linuxfoundation.org>
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

[ Upstream commit b16b3855d89fba640996fefdd3a113c0aa0e380d ]

This is racy - move the blocking into when the task is created and
we're marking it as PF_IO_WORKER anyway. The IO threads are now
prepared to handle signals like SIGSTOP as well, so clear that from
the mask to allow proper stopping of IO threads.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1949,8 +1949,14 @@ static __latent_entropy struct task_stru
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
-	if (args->io_thread)
+	if (args->io_thread) {
+		/*
+		 * Mark us an IO worker, and block any signal that isn't
+		 * fatal or STOP
+		 */
 		p->flags |= PF_IO_WORKER;
+		siginitsetinv(&p->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
+	}
 
 	/*
 	 * This _must_ happen before we call free_task(), i.e. before we jump
@@ -2435,14 +2441,8 @@ struct task_struct *create_io_thread(int
 		.stack_size	= (unsigned long)arg,
 		.io_thread	= 1,
 	};
-	struct task_struct *tsk;
 
-	tsk = copy_process(NULL, 0, node, &args);
-	if (!IS_ERR(tsk)) {
-		sigfillset(&tsk->blocked);
-		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
-	}
-	return tsk;
+	return copy_process(NULL, 0, node, &args);
 }
 
 /*


