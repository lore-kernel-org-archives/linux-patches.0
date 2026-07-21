Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F5C326D44;
	Tue, 21 Jul 2026 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655671; cv=none; b=otCvj8+el8v3fYh1wchaK/yXEyCa/JFve0oymmVn7wKvIwdaFPTxjG3/FvA9eexbA4Hs7y64LdxN2/S1qoRzxwv+v56aJwX/3Ca13jtnuRcZS0SualNLTzLek9/Vz+8vIA9lWNh+q/tzRzjVuaqk9caN3BKZbCorX3e9+Zl3q+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655671; c=relaxed/simple;
	bh=mF2VwD4uwVWEwfLXhM10hiVnXam4VHu8tcbZgrH8u6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyJPEm5tuZIxL9S/IblGB6dS/gJ0Py3SQEU7DBTzmTBvKCa+Adq9uVBGIo0NG3dWmjlnZimKq5mz8d1BqWtBCA9XgseS+KnoeNwxJrHyhluCSpuwRqsQ0woGFKaHV3sXM/5pwrp120FydEBNJnqPAciqkP2BtnnA5lAhoWQF7U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2OjuVgZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2OjuVgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A23B1F000E9;
	Tue, 21 Jul 2026 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655670;
	bh=fRqPOMapEsvYfo4QnTTufHU9gFk6RoR46fs+9K8oXc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2OjuVgZqmzW9sfHdeiAWwW1YXzloO5ar+SUOTDpwySXkIGWl9wVKpjdk0X2y+95L
	 Ojmwf4EqXAzc4jwLHy1SpuT4l19btj6PPQGlu0tSxfoSJQcrHGQiKpizR0vHXZCbXf
	 3tdjCCLeNDF97J3W2ug86xPvrRZsxworFTaEKt/Y=
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
Subject: [PATCH 6.18 0053/1611] afs: Fix further netns teardown to cancel the preallocation charger
Date: Tue, 21 Jul 2026 17:02:49 +0200
Message-ID: <20260721152516.017760852@linuxfoundation.org>
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
@@ -128,8 +128,13 @@ void afs_close_socket(struct afs_net *ne
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


