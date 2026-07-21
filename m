Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF3444AB61;
	Tue, 21 Jul 2026 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668706; cv=none; b=Ceclp+AVrOFjLXasZThKmUUvX7+CrlXpwPRNzqG2AfSMrLeo7vru4nFdUJ3ChiG5oiabuaCiyIlPIt+uHqs8Lq3mmdptkr8M+drtvUzHuaqtE0A6udedages+bN6LsyacgBXnHLhVslnqwgyjLmMwmPztIb6xaZN9G4ICeoC0SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668706; c=relaxed/simple;
	bh=3bv2OaV1+VaeA1bdyCGlh7QgEXhSjwvWm4HDV73BLf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtZ90szR5T2Rwi7BVGqoQ1EXPnUwtiVvaMJRmcTMt1ZHJCzEcm1Oxnf0Y54KZcLz0SZTnUcwrCExWCYi3pRInCi82MhJSDbVFS/WS+V/MmLQF36B13OtsX/709xOzxV7VnFNT7/p9v6JWm2dYw/gayk+bJnwyW40my9UQRzjlx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3HvbFr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3HvbFr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D763D1F000E9;
	Tue, 21 Jul 2026 21:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668705;
	bh=Q0e6P+51yV0nhapIwj0jqKanQTcqJZx0SlDVuclHnA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3HvbFr6qiaGUJMRp/hF2Qg849I+nocr1CYj0ekGkd79DeImAf2NdYY+VMj7ewe8W
	 23iUqp+OWBxFWKHLWZB/RMe26cbRGbxXaWt2a7l/n+2KzGjpKGT7O3rtS/cxd20U9C
	 DS8CM5TWGtVyalFHQQywwnjvVCIVEh9APkQxj5Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Li Daming <d4n.for.sec@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org
Subject: [PATCH 6.1 0276/1067] afs: Fix further netns teardown to cancel the preallocation charger
Date: Tue, 21 Jul 2026 17:14:37 +0200
Message-ID: <20260721152430.770638864@linuxfoundation.org>
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

commit 2daf8ac812c3d78c642fe7652f62e29df5e3da20 upstream.

When an afs network namespace is torn down, it cancels and waits for the
work item that keeps the preallocated rxrpc call/conn/peer queue charged
before disabling incoming (i.e. listen 0), but there's a small window in
which it can be requeued by an incoming call wending through the I/O
thread.

Fix this by cancelling the charger work item again after reducing the
listen backlog to zero.

Fixes: 47694fbc9d24 ("afs: Fix netns teardown to cancel the preallocation charger")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://sashiko.dev/#/patchset/20260609140911.838677-1-dhowells%40redhat.com
cc: Li Daming <d4n.for.sec@gmail.com>
cc: Ren Wei <n05ec@lzu.edu.cn>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/rxrpc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -108,8 +108,13 @@ void afs_close_socket(struct afs_net *ne
 	_enter("");
 
 	cancel_work_sync(&net->charge_preallocation_work);
+	/* Future work items should now see ->live is false. */
+
 	kernel_listen(net->socket, 0);
+
+	/* Make sure work items are no longer running. */
 	flush_workqueue(afs_async_calls);
+	cancel_work_sync(&net->charge_preallocation_work);
 
 	if (net->spare_incoming_call) {
 		afs_put_call(net->spare_incoming_call);


