Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99514431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F373C433D2;
	Wed, 15 Mar 2023 12:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884170;
	bh=h+TTDdXicdLQPLFUfeqHsebXp13Ht6AUyEGzwYGY0T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JA7BsKkyEjwMK86lmgwYCcYvCCI7C5W3CyGzOWe5/Zlzub2XfSHNRrkSjoFxMI2At
	 2BWsXlw2jB3XmWnZziMRqDHQWmmhReydKdxDg4LjN06VHWEndU+QfDB0wKHLWN9vMS
	 o8ZHNnCW8cW2NqqQt18kHFT3MoOuyzD2P2GfV2xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 104/141] SUNRPC: Fix a server shutdown leak
Date: Wed, 15 Mar 2023 13:13:27 +0100
Message-Id: <20230315115743.160432913@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 9ca6705d9d609441d34f8b853e1e4a6369b3b171 ]

Fix a race where kthread_stop() may prevent the threadfn from ever getting
called.  If that happens the svc_rqst will not be cleaned up.

Fixes: ed6473ddc704 ("NFSv4: Fix callback server shutdown")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index f06622814a958..7f9807374b0fb 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -786,6 +786,7 @@ svc_start_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 static int
 svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 {
+	struct svc_rqst	*rqstp;
 	struct task_struct *task;
 	unsigned int state = serv->sv_nrthreads-1;
 
@@ -794,7 +795,10 @@ svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 		task = choose_victim(serv, pool, &state);
 		if (task == NULL)
 			break;
-		kthread_stop(task);
+		rqstp = kthread_data(task);
+		/* Did we lose a race to svo_function threadfn? */
+		if (kthread_stop(task) == -EINTR)
+			svc_exit_thread(rqstp);
 		nrservs++;
 	} while (nrservs < 0);
 	return 0;
-- 
2.39.2



