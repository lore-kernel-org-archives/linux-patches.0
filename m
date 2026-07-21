Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8842B3CF1E0;
	Tue, 21 Jul 2026 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655592; cv=none; b=WfK2VXtg0sZPLxiGTevNHsFqfL0gPIF6rqCrfPyA76Kh59o6qfDeVEODamaF9YUMdf3UGmet9QM6eZHVly9X20FlHABBdJ/9/DdNmuijfMmAr9QatPTrK/SSFZ2UTYTrbbvWAdlqxEa4TSqWxhfQkdvzgB1EfCoWiibI/4JMOOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655592; c=relaxed/simple;
	bh=CgT0cGvmuoQ/sghJyr8j0zm9f2OCPZDzgKrMjd2EN1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/gQul2reR3nDAkwdRLdQ00wZoqE/R0yf13zH3b8Nhy3+obblSF8idVt8p2IlQD88IM4K03lLvdHfzgUiCM40jnxKMiOsTpvriiNn29SBg5VIME3RH9XFJys+F0o+JMoUbBOaORYz1XESl9zZkgRa4xW02arTVt8ATtYP1l1W4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3RB8IZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3RB8IZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30BA1F000E9;
	Tue, 21 Jul 2026 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655591;
	bh=fJp87ObnRJ5X7X4xMYKS1QVYqcL28nEXKaWyQLDCcz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3RB8IZsYX1t4HYUVouOB8MNfCiC7+8r+VaORB4w34Nr19DYkWD+3XtDRGFW9qauI
	 sM9q7+we6IyJvNuyo8BQDlHnagNzDg+/Z1QQrJmI+mtk/GRjjObzc8/ZN8luqAwzhX
	 OZSoYtn16gkwY/Fb30yKGrrK7AUZrCkxbnZukoq0=
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
Subject: [PATCH 6.18 0050/1611] afs: Fix netns teardown to cancel the preallocation charger
Date: Tue, 21 Jul 2026 17:02:46 +0200
Message-ID: <20260721152515.949878100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


