Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E29044AB61;
	Tue, 21 Jul 2026 21:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668701; cv=none; b=iyfdRtjDv04BcyAjMHixaEGDNcs4U4o5PYyEl78a/CKgDUs6xMCicXbPEUZ7lB9nYGUPfZV5b1BIxqolDJdD+VPrqHRUVruXAMdw6D8RdWo9Hv/nbtFtv3odBRPC9ee9EUSHpXgK+IFCc7e24FArKBfYgUJMfJZO/89BbM6dmt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668701; c=relaxed/simple;
	bh=220NHWkcW6lp9xdwwRnYg0m6ac1reIu3FowEqL80+X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRvVOWZ/Uq0fUZGfY3cstYWQfXEDOyP61/7Lz1eHdILvpk/ZKINRvq28pTGWgbb+1paTmh4S2c6ZyatO2DY58Cb/31Q34Q9qpv8wr3lYNnVhooOly5E/u0ObGPdrUm2R4wX2YAvJ1f2UHHfV54rlcRQXI86V92KPznCwozWSVLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tS8UMwML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tS8UMwML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4E61F000E9;
	Tue, 21 Jul 2026 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668700;
	bh=Me5zRvgwrukIY3Ontssi995J6SijneP7aWZTKhH6bGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tS8UMwMLQdpRJ13Bc8SXQGsBtXvNwReeXLBtU/7pfV/kGuKLdRQjkb8xnTbJQaqKj
	 zgkf1792e0ubE0qmxVY3e/qw8EltSyIHlXVUPtnAIPYS+uRw74fm6gCV1nDY0bSDUf
	 mCZB7ByRK6tkf4pigvrGOj+2avLsoKYIkbZnc0mI=
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
Subject: [PATCH 6.1 0274/1067] afs: Fix netns teardown to cancel the preallocation charger
Date: Tue, 21 Jul 2026 17:14:35 +0200
Message-ID: <20260721152430.724086637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -107,6 +107,7 @@ void afs_close_socket(struct afs_net *ne
 {
 	_enter("");
 
+	cancel_work_sync(&net->charge_preallocation_work);
 	kernel_listen(net->socket, 0);
 	flush_workqueue(afs_async_calls);
 
@@ -717,7 +718,7 @@ void afs_charge_preallocation(struct wor
 		container_of(work, struct afs_net, charge_preallocation_work);
 	struct afs_call *call = net->spare_incoming_call;
 
-	for (;;) {
+	while (READ_ONCE(net->live)) {
 		if (!call) {
 			call = afs_alloc_call(net, &afs_RXCMxxxx, GFP_KERNEL);
 			if (!call)
@@ -762,7 +763,8 @@ static void afs_rx_new_call(struct sock
 {
 	struct afs_net *net = afs_sock2net(sk);
 
-	queue_work(afs_wq, &net->charge_preallocation_work);
+	if (net->live)
+		queue_work(afs_wq, &net->charge_preallocation_work);
 }
 
 /*


