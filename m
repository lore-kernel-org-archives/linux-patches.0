Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C4046AA77;
	Tue, 21 Jul 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648003; cv=none; b=fokb3rjns3gL8410hgtNpByMlA1GZdG5hoSBLVYYaaGUDPK/iFmaek1Pey1pUunLpPWgH/V8YwG2PZBPT34nrj7AHTBhuFNrZB2jr6R2faIjZp/9DOoEgBhaR5oOM1e8OML07bfmdnEEMMpHN2pLmBopAmmG6d5oRTfxAD+biyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648003; c=relaxed/simple;
	bh=h3Oi+8UbIlqOwWeeLo1BxkSMy696DzLN3vEaBjb961k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hihi97DGjS7fTC5gsPFS4z0EE4VR0tv0NVvT6pfpm8lkC/w7BiHr5gLE+aoEWVHCtTQ74cWC9HWN096MH23EIOm/TAXF/m5ngb6JNdH6yd9zQK38i7PuO5a/TvZoy14OSmJuhj1+HJNi0PGFDe4lxhGNrK0O5zD+JaMFRGWmQQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdGgGsLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdGgGsLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59661F000E9;
	Tue, 21 Jul 2026 15:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648002;
	bh=7IOuhvsZF4yAjzA63/66OTWaUgp8K58pZ28Li/6qqVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdGgGsLgV/6aEMcbFSrj8PFbA2iacl7rd4g5DPNrxR9vS+nzHeW96SklWvJcIO0iv
	 fgwgNH0eLGwveerrjYlU9SpzBuIYJrjCUP9cyVZp1S3aZ8w/Uj+M3lYK1jBLIeE7O+
	 BgnkwVAgP1WtyOTArpkZkXBzb/hftr0RBbdNpA2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Li Daming <d4n.for.sec@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 0034/2077] afs: Fix netns teardown to cancel the preallocation charger
Date: Tue, 21 Jul 2026 16:55:07 +0200
Message-ID: <20260721152553.484686875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 47694fbc9d24ab6bf210f91e8efe06a10a478064 upstream.

Fix the teardown of an afs network namespace to make sure it cancels the
work item that keeps the preallocated rxrpc call/conn/peer queue charged
before incoming calls are disabled (i.e. listen 0).

Also, if net->live is false because the afs netns is being deleted, make
afs_charge_preallocation() skip charging and make afs_rx_new_call() avoid
requeuing the charger.

(This was found by AI review).

Fixes: 00e907127e6f ("rxrpc: Preallocate peers, conns and calls for incoming service requests")
Reported-by: Simon Horman <horms@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Li Daming <d4n.for.sec@gmail.com>
cc: Ren Wei <n05ec@lzu.edu.cn>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260609140911.838677-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/rxrpc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -127,6 +127,7 @@ void afs_close_socket(struct afs_net *ne
 {
 	_enter("");
 
+	cancel_work_sync(&net->charge_preallocation_work);
 	kernel_listen(net->socket, 0);
 	flush_workqueue(afs_async_calls);
 
@@ -742,7 +743,7 @@ void afs_charge_preallocation(struct wor
 		container_of(work, struct afs_net, charge_preallocation_work);
 	struct afs_call *call = net->spare_incoming_call;
 
-	for (;;) {
+	while (READ_ONCE(net->live)) {
 		if (!call) {
 			call = afs_alloc_call(net, &afs_RXCMxxxx, GFP_KERNEL);
 			if (!call)
@@ -792,7 +793,8 @@ static void afs_rx_new_call(struct sock
 	if (!call->server)
 		trace_afs_cm_no_server(call, rxrpc_kernel_remote_srx(call->peer));
 
-	queue_work(afs_wq, &net->charge_preallocation_work);
+	if (net->live)
+		queue_work(afs_wq, &net->charge_preallocation_work);
 }
 
 /*


