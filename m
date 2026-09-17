Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F03E40EF;
	Thu, 17 Sep 2026 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668088; cv=none; b=G35K564lBtOrTMdujpnTGJnBplGKdEyWaNOeiOIO9joIE2KO8u4mg44NG3nJO2svxoBD2/Y6RqVfcaR7EwxLXeMvrrA96qo3StElKguLQ5Fq9siDiw0Gg4DOnwtZUD9/0s2C+3RF5T4GOXB7W4sXU00TK7YfzkmXsrZ5D/V4D1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668088; c=relaxed/simple;
	bh=JkYL4+6Eu2Fqs2N7dBJO4G1GSpI/Rd8hFe7n7M43Vbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf3lxhhmKzwD3fVKMpBrejdXV+HdIZSVRYZYAC0G8RA7HSuAgrsYI3EI53/Mec/yYNyRXzfqbHQiIvshbA54y/rX0WvGR3sqSVL/0NKsAXhcyghMOjw1GV4yhd3HQlIQN/IRqSeWiBBgZPptmRYjWyh5x3pTMd9I3yaTQh7jUDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IONZ+cSL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IONZ+cSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B71B1F000FF;
	Thu, 17 Sep 2026 18:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668087;
	bh=NdQKO4sPvmSL795Jdo8PrSwy87vEGruWn3VaN3/9CxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IONZ+cSLrBCbxXatHXSMDhktW5Jq82uTGkxdmL4rMXN3Az5GwsCLVepZu6R+AOBwU
	 +7l8T0S0b8pAzT+QLtdPvmNeyS8uWSxqI4Z39NfM7lTSbTfwv1L6AGSfHbRmz/xPso
	 qGlBR6LSYEvNOGAeXyyMQ89bisALhVMy+o5RI97k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0309/1102] smb: client: fix races in cifsd thread creation
Date: Thu, 17 Sep 2026 16:04:12 +0100
Message-ID: <20260917151547.379071908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 52ac9b096a402..5e17462c8e372 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1823,14 +1823,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
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
@@ -1838,9 +1830,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this update of tcpStatus
 	 */
-	spin_lock(&tcp_ses->srv_lock);
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
-	spin_unlock(&tcp_ses->srv_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
 		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
@@ -1849,7 +1839,16 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 
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
@@ -1857,6 +1856,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
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



