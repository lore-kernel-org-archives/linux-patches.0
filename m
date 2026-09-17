Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2AD5383D6;
	Thu, 17 Sep 2026 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664567; cv=none; b=bof4qwE1biJpJVO+pTy+djCaFBztP81UvZz8qQC74zhpy9rObxpjXIDoi/z6xE48cahRqLtt8mQp5LeVIxfEZwELRKVN0W27nwmkSHhaWueO61s26evOklyVtfpcBOp6d9zHgkeLK2OBvthSz/neJfxxdsQ6LdDhpx/OTxO0xH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664567; c=relaxed/simple;
	bh=42ziB/O9my+wMfGQjA+KXGReZEmkK/w+7+k1SW3E0JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzLz7w6iefS/xn0z6aIRn8UiFsGnWDpIlXJW6WJpXmHoTEfBRppPvc08v8pozGwF0IeNgQ78apgWt4kdYly6XEYzhiP3rWyKnsp/BeVLi2/8J/TgyYcPwQU6hs5790rGC/JEKyZ/sWXkeD6AzRPaanN5+CrEH4DckkGjtAquvSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3sse8V1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3sse8V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF451F00893;
	Thu, 17 Sep 2026 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664564;
	bh=Itr5r1b/1HP9j0m9cUD+gPzVxk99ka6lyOGLVMCWrzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3sse8V1ZjW+HGypxwRcVljbRhXcrZNZTS0EVp0leuWXsfsjRC2OtpT4WMLFhENQ5
	 Fu4n11QvItXmTIG4iGb2lFuBcI8PdqF8CAQOwR7Uc3rih0u1xShtUn1XhNJxgik2Ki
	 IM8JnULZTpqYV9jZZKBvGNuN0UuM3rIJ8rNUuV7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0414/1250] smb: client: fix races in cifsd thread creation
Date: Thu, 17 Sep 2026 16:03:29 +0100
Message-ID: <20260917151603.247174816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

[ Upstream commit e8a5cf2ff5a13fefb228f2069e29dd7d8e37185d ]

The cifsd demultiplex thread can run and access tcp_ses before the parent
thread has finished populating tcp_ses, which the worker thread accesses
locklessly.

Also, the kthread_run macro may start the thread before returning the
thread pointer. Because the pointer is part of the structure that the
thread can access, if the kernel is preempted after the thread is spawned,
but before the thread pointer is populated and the thread attempts to exit,
it will sleep, waiting for a SIGKILL signal.

Fix this by moving creation of the thread to after all of tcp_ses'es
fields are populated, and spawning the thread last, using a split
kthread_create/wake_up_process logic.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 551acb7721239..89f56e3cd56c9 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1871,14 +1871,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 * this will succeed. No need for try_module_get().
 	 */
 	__module_get(THIS_MODULE);
-	tcp_ses->tsk = kthread_run(cifs_demultiplex_thread,
-				  tcp_ses, "cifsd");
-	if (IS_ERR(tcp_ses->tsk)) {
-		rc = PTR_ERR(tcp_ses->tsk);
-		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
-		module_put(THIS_MODULE);
-		goto out_err_crypto_release;
-	}
 	tcp_ses->min_offload = ctx->min_offload;
 	tcp_ses->retrans = ctx->retrans;
 	/*
@@ -1886,9 +1878,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this update of tcpStatus
 	 */
-	spin_lock(&tcp_ses->srv_lock);
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
-	spin_unlock(&tcp_ses->srv_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
 		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
@@ -1897,7 +1887,16 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 
 	tcp_ses->nr_targets = 1;
 	tcp_ses->ignore_signature = ctx->ignore_signature;
-	/* thread spawned, put it on the list */
+
+	tcp_ses->tsk = kthread_create(cifs_demultiplex_thread,
+				  tcp_ses, "cifsd");
+	if (IS_ERR(tcp_ses->tsk)) {
+		rc = PTR_ERR(tcp_ses->tsk);
+		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
+		module_put(THIS_MODULE);
+		goto out_err_crypto_release;
+	}
+	/* thread created, put it on the list */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -1905,6 +1904,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	/* queue echo request delayed work */
 	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
 
+	/*
+	 * Use split create/wake logic to ensure that tcp_ses is fully populated
+	 * and tcp_ses->tsk is valid
+	 */
+	wake_up_process(tcp_ses->tsk);
+
 	return tcp_ses;
 
 out_err_crypto_release:
-- 
2.53.0



