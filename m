Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2681318ED6;
	Tue, 21 Jul 2026 20:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665579; cv=none; b=EaD+qtpcsn+qlhua+rzc3NALGTPCBLlaFPorOfFP+zRL7572NFOGOHNGkV/hz3KDhcFUDMdO42mRNyJe05JMeHHVY6w9d29Sd36qE516jm4RGPhWJUo0Q/ySyKJceGR3ydBZyx8i7IAJRIr2r9+YIGxQa/Ylt98zeC2Lcj2cuhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665579; c=relaxed/simple;
	bh=9Jf2XecW/HmB3Rz8kdr8TiiWMrNJcVZULCTBuVFe5ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlQ4pu5HdlnOeCn2NHifv9QnvavZqZ0qwy4WdFwz7i5/yNwQP+ZgAS6GSfc6vASckwLMPWBqaAe12uum7KQXwCR86z9kewV8Fc8AgHxgvWHShNAjyrTKzyJihuPVRDMVgsPURVruDlDs4/cPaA+jx5yFy16ThA9Tp5PNk2Tb/Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vb/CFFN6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vb/CFFN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D377F1F000E9;
	Tue, 21 Jul 2026 20:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665578;
	bh=gp3LDmT0e9SKLKn3R3cteFggPS+F+wh3sp/gxfnHGmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vb/CFFN6QIAG0S7DRnoHzbLSko6cAqDQJ/6ZH+xiROmEfRUfLjGo/gsjJCKdiUb43
	 5i4OHGbwwtYCgu25VwECwUz4LK/UqI6MOWTQ8uDapu4jvdIVgR0YTPJ34MhFzVI2I2
	 aOTXafzh1f7ae5VVKs61ryTPkmTpo6OR+AzU62PU=
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
Subject: [PATCH 6.6 0356/1266] afs: Fix further netns teardown to cancel the preallocation charger
Date: Tue, 21 Jul 2026 17:13:13 +0200
Message-ID: <20260721152449.796566520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -110,8 +110,13 @@ void afs_close_socket(struct afs_net *ne
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


