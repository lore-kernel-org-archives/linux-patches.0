Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA8408624;
	Tue, 21 Jul 2026 19:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661404; cv=none; b=gJsftqhhIeW9z5PeHCpG2Bluard2gKqGvsKZ4XTW6Sff2VFjEzEKWjM+rmHl3q/j5fMmQl6VgU526GjllEwaQDwvKVDJCT8MUbmTzdOjAw48g9V2npqvrRi8Xul7cYYEkvbCJhzYdMjpM9uUhvmmaujfL5KAVPX9bdDeeChDOJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661404; c=relaxed/simple;
	bh=zQvyFDmjbzYneh/ZwWFUSLgdV5Y/Pcs1Vzu0C75nmWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzhMbtPJaNVn9uKLYxtlO8rJffxwXU1qHISXT9P8EtwlWaSadMvwC4yh6wF0/5uA2NJt42Zrsa6hdABOL8Yn1Y3m7NiGR4jXIa6lK0T5KxAgSxF/MVR3qS58XK1SPjsCLRmKNMI1pnWYIGHZCCmGxY32I6PriQJwj9l2+6zTzdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNr6PoZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNr6PoZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5E51F000E9;
	Tue, 21 Jul 2026 19:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661401;
	bh=RDO968hsZ4WJyEOTRCyUBDUgWnhTViUvaQg087uwCj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNr6PoZ7tm6FPEDpfdbTHzHnvU/DQLlyX6W/uut0Iy6QMqPEsS2zwyyBqaSxv6pSZ
	 zEDKFfBxdMrQLpT80JOJJC+tVeX2TBufCSuwyXAAvnVPNZaLga/OsvtRJtbB2u3Q4x
	 LtMm/tWTk8JIW6j2oDs2nke9Pt1aDh4fs7qAlEtw=
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
Subject: [PATCH 6.12 0054/1276] afs: Fix netns teardown to cancel the preallocation charger
Date: Tue, 21 Jul 2026 17:08:17 +0200
Message-ID: <20260721152447.293277831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -110,6 +110,7 @@ void afs_close_socket(struct afs_net *ne
 {
 	_enter("");
 
+	cancel_work_sync(&net->charge_preallocation_work);
 	kernel_listen(net->socket, 0);
 	flush_workqueue(afs_async_calls);
 
@@ -737,7 +738,7 @@ void afs_charge_preallocation(struct wor
 		container_of(work, struct afs_net, charge_preallocation_work);
 	struct afs_call *call = net->spare_incoming_call;
 
-	for (;;) {
+	while (READ_ONCE(net->live)) {
 		if (!call) {
 			call = afs_alloc_call(net, &afs_RXCMxxxx, GFP_KERNEL);
 			if (!call)
@@ -782,7 +783,8 @@ static void afs_rx_new_call(struct sock
 {
 	struct afs_net *net = afs_sock2net(sk);
 
-	queue_work(afs_wq, &net->charge_preallocation_work);
+	if (net->live)
+		queue_work(afs_wq, &net->charge_preallocation_work);
 }
 
 /*


