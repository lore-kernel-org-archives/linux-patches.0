Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624764;
	b=BPA1yjSvatKbsIuBnpUro2MK0uGTHga5o2DiBYDj6poiSin+8b9mVNMUzNdIW5MgySmO
	 SASxkB/R+sYyoBYDsm4eub54YD9IQ5PwFztn2ADIpOsOvy+6WUx8DxolQudH419x1v47o
	 lW9+wZV/wavQysbRTZZkMmuia+YobVPWn4cssLlPhi+wyBdn2/2vuMEcFFb4AO3WtVK5Z
	 /2vwtMEmkAAEO7bzLKylNRJ3NhYMVB3yVw/jlyw/sFgFuUBxrWMuGSfYaqdeDnWqy9c8Y
	 D75f5aLp203XEjKOpQB4q5uDHdcWOMZydf8QxNkXGVWN5gTQch7Q+XVxo+hyslGhs5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mACXhQUsSYqfrQXVh4pzu/D5MWqDa6fT4byMmSIOAc4=;
	b=Tjyp3W+28nSrH2sUnWwPikQ/yHZ9u+JLI6fxvBEBSz7S3O5OU1NY7Hco80mRxoPQv89q
	 2WzYt8QXPH7OfTXDPYzIsIobI+63ggfUu6mwf4KaDvMBBoSUEHEAt0ZteL9upsZtgHlei
	 M4OBw7wIvCIgd0+jp6VuBuQpfeBijNz7bXuBVPngd8FFeFyTCprw1CuKibLtlTXivDd29
	 N8aA4PM/cd/h2aXVq8iEOes5ojMjLJ9M3twLHrKUg7vzsCG5f2gPCOjUAUeJh0P++FlXj
	 mSrVYB5pSa/tJ15dIxWVGOyZe4y9Gcc0gEK2X1DxU55byJHSFjCX5vMfV4z4iT8QWww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sw+xha+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD380606A32E;
	Wed, 25 Nov 2026 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sw+xha+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED88F1F000D4;
	Wed, 25 Nov 2026 16:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624764;
	bh=mACXhQUsSYqfrQXVh4pzu/D5MWqDa6fT4byMmSIOAc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sw+xha+WS+5QqHN6dobCZBH8zpcyHlHiO3KhXhHVPKd4tiJRkfvM/vZ8CIiO9ldrH
	 IXtCUW0AyzIdY8SpK7PAY+UreRG4LNL+RXd5972VNt6wvtuDx6Y6Cd7hSHYuK1JwgZ
	 vRSmvq5iTIwDLuy+N4NRA7fxN95xiu03AwkkO7tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/816] SUNRPC: wake poll waiters when an empty pipe is unlinked
Date: Wed, 25 Nov 2026 15:30:48 +0100
Message-ID: <20261125143856.149527190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 702d55edc017632a0c39c1d4bdd579bdbadfd730 ]

When an empty rpc_pipefs pipe is unlinked, rpc_purge_list() returns
without waking the pipe wait queue. An existing epoll waiter can
remain blocked even though rpc_pipe_poll() reports EPOLLHUP and
EPOLLERR for the disconnected pipe.

Wake the wait queue after clearing RPC_I(inode)->pipe so existing
poll waiters are notified regardless of whether messages were purged.

Fixes: 9842ef3557ab ("SUNRPC: rpc_timeout_upcall_queue should not sleep")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/rpc_pipe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 76a9d86ab8ac7..45926b8798862 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -190,6 +190,7 @@ rpc_close_pipes(struct inode *inode)
 	cancel_delayed_work_sync(&pipe->queue_timeout);
 	rpc_inode_setowner(inode, NULL);
 	RPC_I(inode)->pipe = NULL;
+	wake_up(&RPC_I(inode)->waitq);
 	inode_unlock(inode);
 }
 
-- 
2.53.0



