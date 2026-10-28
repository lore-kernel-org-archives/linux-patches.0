Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216757;
	b=FPqgV9FztTQxwUE6ELfjFZD7YsIOxnmH4TjDMOSHH3ZF9Uk2mhPcBbffnZ9Q1t4kZu0P
	 GO1DL1zqWEHH2Svw8/mWhIq3cAOzOlX6EFidE+6ye8v9ucMDBCsU/ia0I0A9Z7C7/8XUu
	 8EPFmQKhxplzV3JttTlHNtj+TlYMKpnMsK5G9B5qY9mnjgpPqAmciDibLkozCfRmpFwiC
	 FczwUZA98BbUCgOh59UiPmbX2MtXT6y+Wwlp/CsxuqDzr1l61c9Xaik4OUA/40XAZF4+o
	 LrNP/vq/nWDcAyZ79fcHVGv61X/g/r4OKQK2/n5EZIFT2IkPUwaGqJeok3GVH7pBJ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oncArZlTzDPmsdtAhlAKjvGfh5Tsas3r2mzUt6BHPrU=;
	b=HVf9AzxQiA/+aJE6A2H3da7QsNOJ8YSg3X+kP3GmTK67Tvvb3Tq+dka3mA1tvH8lMyDQ
	 LGKpHKlzOIJoG5mjYM/H5U5qzFWvRxbAvRCN1EHoytrmHKdiuvG71OlrXxZpSoXx7bwTH
	 HXoYoUFjD2VMviuVcHFZaM85rA15cqkLgXWIuapdplaW45dRoZB2nbITTz3jk9h5NVTHy
	 YzVXPD3Pih3PgxVonGGHKQk7rOefWfG3ZDy4UZKLa2qjqC8s7yr5iK7rh8RpjjH+tBi4T
	 ItsmjT4YYKHI44C80uZLlaL/TS2XCNCriTFQVKvOWOZaOGODpyBYAi1LydUpVwZL55A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSsIRGTT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D5C606A31A;
	Wed, 28 Oct 2026 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSsIRGTT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CE21F01825;
	Wed, 28 Oct 2026 19:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216756;
	bh=oncArZlTzDPmsdtAhlAKjvGfh5Tsas3r2mzUt6BHPrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSsIRGTTcc2/r/UBkwlktPeDuDVAnPYdoNxTFbmxF4e1JOXr5jr74l3cqcOrSFCGf
	 JTl5D/Lj+6UPncBgc2L4lm3ZfislHWfDWqoEo4QkdWmzJqDo7TWTkGz7TIO/ba0Lq3
	 lNfXv5k4VDwcqHm+Rys99l3gOv9Xi+1ymubwExgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1668/1887] smb: client: fix races in cifsd thread creation
Date: Wed, 28 Oct 2026 18:02:44 +0100
Message-ID: <20261028170537.415321881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 10f0009fc7a16..52cd09c25bdb4 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1817,23 +1817,13 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
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
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this update of tcpStatus
 	 */
-	spin_lock(&tcp_ses->srv_lock);
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
-	spin_unlock(&tcp_ses->srv_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
 		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
@@ -1842,7 +1832,16 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 
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
@@ -1850,6 +1849,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
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



