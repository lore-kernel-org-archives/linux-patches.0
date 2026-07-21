Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40AD46D549;
	Tue, 21 Jul 2026 19:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661409; cv=none; b=hys9zXgtiju2Olu3/Kw3JYnRV6WlTfl6muzwxlvPMxJW0HnOUAJtDxIrTeWlS4lfiVbGPm3Py93T+nXyrHwck+ESaHILIR2AhZwMdDla9RxbJ0wiAJmiW22gpQXWqB99nTSiQwZcXlGFtMbBMFf7mRgAPNVcEbKGxyXtSH/pOqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661409; c=relaxed/simple;
	bh=V88HTMjCFEAExkWsrAsB1sQbzfqNDfFU2aEoBDj3Yms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyAu5OntBIuclkM4x/id21SIC71b4iIZNE2Lhvwpw7vK3VRR5bCIJgE+wJnNtr8pN6TJDX7fzn5zzEWX8epBvSQxRG5075VzHSEOiRT6rVOjK/MzELJy+9Ky6af0YreWexDVo+fhj4Kz49nX989No1WMxnzTmxPaMq9KeeXihmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKX7E8Fs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKX7E8Fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CD91F000E9;
	Tue, 21 Jul 2026 19:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661407;
	bh=VYQJOg6QfbDrB/BFt4BaCIVCjeVT7Zz3mfReEfkewjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKX7E8FsNJzYzf6vlDdOvASVw88fGhu1b4yXAvwVv6zenx0IDkcu8R3yI8ahXVHsX
	 GmoGBgBnMVt2g4XzYJ37QnSy/2pVWpmza2p5yMRzfD6xksg8foDc5LT4fkqzaJYlWj
	 Ksj7PmvuNjlkn+KdLFhw/n+R6zsxMwYOlRKx/z6c=
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
Subject: [PATCH 6.12 0056/1276] afs: Fix further netns teardown to cancel the preallocation charger
Date: Tue, 21 Jul 2026 17:08:19 +0200
Message-ID: <20260721152447.337897539@linuxfoundation.org>
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
@@ -111,8 +111,13 @@ void afs_close_socket(struct afs_net *ne
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


