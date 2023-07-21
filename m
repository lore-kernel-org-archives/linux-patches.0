Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2421D20
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7E5C433C8;
	Fri, 21 Jul 2023 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956426;
	bh=PYyTACxITCQYQJtm7I0D1U4MOuUk8AjpkpWfmqdLnEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UilzqtrX+kLB0n67env2C2617mJQDvxkXrwCM6G6TPnOrHgbvcp9Kz0do576Ik5tF
	 95LKO6BuWFVGLSKSnC3+bKz+eLWPoEYa8jv0wnLgq2LyFS8gEZhAChgRo6TyEQZxZe
	 LI6uqFT15JbrEc/tCe3YRPwT/EKVA6qK3rhVikcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.4 188/292] fs: dlm: interrupt posix locks only when process is killed
Date: Fri, 21 Jul 2023 18:04:57 +0200
Message-ID: <20230721160536.970189251@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit 59e45c758ca1b9893ac923dd63536da946ac333b upstream.

If a posix lock request is waiting for a result from user space
(dlm_controld), do not let it be interrupted unless the process
is killed. This reverts commit a6b1533e9a57 ("dlm: make posix locks
interruptible"). The problem with the interruptible change is
that all locks were cleared on any signal interrupt. If a signal
was received that did not terminate the process, the process
could continue running after all its dlm posix locks had been
cleared. A future patch will add cancelation to allow proper
interruption.

Cc: stable@vger.kernel.org
Fixes: a6b1533e9a57 ("dlm: make posix locks interruptible")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/plock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -155,7 +155,7 @@ int dlm_posix_lock(dlm_lockspace_t *lock
 
 	send_op(op);
 
-	rv = wait_event_interruptible(recv_wq, (op->done != 0));
+	rv = wait_event_killable(recv_wq, (op->done != 0));
 	if (rv == -ERESTARTSYS) {
 		spin_lock(&ops_lock);
 		/* recheck under ops_lock if we got a done != 0,


