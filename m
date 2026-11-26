Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704416;
	b=It2dZc4M+KdmESn0UhOlcvo2NBRjb0HzAA71tALkrysFsyG/H/dYGCPf/MEMBMFL5A8B
	 mGbBKS6kfix3249vUTRMpgXIR7n4vAYQAXz5CweA43rmoVnH4IrNjtZ5KLrtnNBKY6D0J
	 YRZqsohQKqEpDO322LRxnOxEHVpCPQWrE0auidFYJE+feOwLXszdSPBJUS/Fxlfsn2EwY
	 wVVDmHvNzQ6Lso/0dvAwKCfODcsZ5fkbCSj5NKBcYnmZG7nbxKLmS24a3VVbJlh7OvXs9
	 wpvJMTmk/Da0gq/OzHwq4xubaY8dpHjbS1725KhnRtTiw0MJ12Jn/t+AVXIoPcRppzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zOdqmfHdicjlFXTScfgGfv6uwFEOwwBIMopse0vqgy0=;
	b=cFvU0YtOXtbaifXRkag5//Yzc/zwqk4heTJUTb7N5AWmC4969h5wwUj86V0kuTFwBPrS
	 UJjChnyPKVJ00OSjFrJ5WNePh0SnyW6VfqveEMRJzvL9MUQNFz4Yff/8TAGjNpBpn6MGh
	 dnt77Wj90yHFCcq/voZUZHv5Fi1NQupkMiiYDC37+qZ3LKETwMisgegOoLvFT263bQ/wE
	 qy6s9xgn6IUDk3SmG2Iodt+6PvUJN1RFJpJ56QMs4mPCaeuAj9z8Vs3ffxdKn7seA7vnl
	 hZMQB3b7hSIh8QsjVTAUZClVkrxQBR3NQGKU8yuL7F0NGRyY6pC9/9xsGZTgUbhdNhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLBLJTz4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA27E606A31C;
	Thu, 26 Nov 2026 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLBLJTz4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5948B1F000C4;
	Thu, 26 Nov 2026 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704415;
	bh=zOdqmfHdicjlFXTScfgGfv6uwFEOwwBIMopse0vqgy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLBLJTz4q+ClVNkxg5pCeg3iiOzGlPWsflhQhZljfL3jmr2zmzDtm270/CvP9c1uA
	 9/UwCFG0jk2ir4mcldyxku+B1wwlhAmvqhLCVvREaRmiNq89j/D0ydMDO5OB9TuQHH
	 PTy/Rs6lm+ALnhhPnQ4AXGYA3Wj4uFykpTOWjJY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/265] SUNRPC: wake poll waiters when an empty pipe is unlinked
Date: Thu, 26 Nov 2026 15:37:27 +0100
Message-ID: <20261126143613.199084625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a3545ecf9a6e5..9519aea4bc600 100644
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



