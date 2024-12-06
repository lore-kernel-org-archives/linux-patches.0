Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C8817C208;
	Fri,  6 Dec 2024 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498470; cv=none; b=K/IUp5WJjPRIv1mT8sUMd+zDVsWFy7PfSGaImUaLdQ63GjL5SfHDfHbg30VsijSgca0hZJYkWun9rEJ3Z5B/FXjp+Xw6jJsmkRZq84chLYIoAdRk3ViFMGGpN5Y3cKghDgrQaAP7IaOsyXf5iDAh2wPUUPvdlsrj8ra51HlzQEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498470; c=relaxed/simple;
	bh=NDiH8rucRtLoPk2pt8x6AhlEl8QBEpo1MU/3wcddTT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIJbvzqVH8unE+bODZwc+tzndx71ddDY/fAlZUykVQGZB+rc2LHRLeLztEouZIfUz7cbOXOMcBBHugSlMwOFNECQR3vjoGb9x/1wum8Dru5D4VwdG5W4RaSSHcKNEoDd/oAIizK8MznkU7msAR28Mj5iqXBcVdV8q3mpgDaaWvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnZPovAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnZPovAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC71BC4CED1;
	Fri,  6 Dec 2024 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498470;
	bh=NDiH8rucRtLoPk2pt8x6AhlEl8QBEpo1MU/3wcddTT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnZPovAqwdkDb9eXoBKXRtZPJmHuJ44dL/iZl7haByZ/RZjCemCzAoltI31Q4e4NE
	 bOTa8IRWXLlfRR14XPDxD9J2nmFIT5x7SUPXz9Rr9wX0uqN0dJjRnEUrBgn5+oFscl
	 fYHujfakt4iuOwLLGVPBKNk/U3zUuQnBqd0eJAzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Liu Jian <liujian56@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 595/676] sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport
Date: Fri,  6 Dec 2024 15:36:54 +0100
Message-ID: <20241206143716.610828711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 4db9ad82a6c823094da27de4825af693a3475d51 ]

Since transport->sock has been set to NULL during reset transport,
XPRT_SOCK_UPD_TIMEOUT also needs to be cleared. Otherwise, the
xs_tcp_set_socket_timeouts() may be triggered in xs_tcp_send_request()
to dereference the transport->sock that has been set to NULL.

Fixes: 7196dbb02ea0 ("SUNRPC: Allow changing of the TCP timeout parameters on the fly")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 50490b1e8a0d0..714da627fba8e 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1186,6 +1186,7 @@ static void xs_sock_reset_state_flags(struct rpc_xprt *xprt)
 	clear_bit(XPRT_SOCK_WAKE_WRITE, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_DISCONNECT, &transport->sock_state);
 	clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
+	clear_bit(XPRT_SOCK_UPD_TIMEOUT, &transport->sock_state);
 }
 
 static void xs_run_error_worker(struct sock_xprt *transport, unsigned int nr)
-- 
2.43.0



