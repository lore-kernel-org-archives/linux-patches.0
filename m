Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F5141A503;
	Sat, 12 Sep 2026 13:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218794; cv=none; b=B8lJ7GsN/fjTWljmZ8mjPPPq+9pOytGlY3vrNiSJFB/6FbXe3EIn75bVcz3WSn9FEbW6YopA2UcXrsN514clatjnOILzxRVelmhtGwJxLiYuZSBkreLP7W5nopEb3nfpCrjTHGmS4FLWeqW+SYTpudRDP5pHXPxIOEXpTN30Px4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218794; c=relaxed/simple;
	bh=D2mjVTYfH5O1M7cE7kA/M60LO0nYKzyWTLPBa4uhme4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQu3PtL2SXwXXbQmO1+87dpcYNP32LRupT2leDZjQIf5YZ71RdcInobAUoUZ0dTIsZ4YiNt9y3yKsm6jdkJuII9Iq0ZZawOXst4OMnNk9xC7UNaT8loYOXgIzYA0XcJQAIxPIjNLWHrczUfJLzHqAvt6wQn8G5G574N+ejWJW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MO4FEWaw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MO4FEWaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AD21F000FF;
	Sat, 12 Sep 2026 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218792;
	bh=aX+t85g9r+EddtjQ0809hdGHi3dqPNCaHlQ0EIGu46U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MO4FEWawByYFQqgjDU9Ms1XuF6dcXDmhjGAceMbipflW8HQ/1hHiROc3m838fjt7v
	 vwT81GRjOikyrDtusXjGEqVmP8ZTF0F23D5NE0WS+NUkNYKlCtGYP/ifjCS6dO7nFG
	 521UpmkSOzM+2w5fUjeMtczWAagYeO/nNf04Px0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1219/1376] vsock: use sock_error() to consume sk_err after a failed connect
Date: Sat, 12 Sep 2026 09:00:45 +0200
Message-ID: <20260912065634.719397104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Nguyen Dinh Phi <phind.uet@gmail.com>

[ Upstream commit 96cbf89993091a163bfedec52a3bd683dc94b3b4 ]

vsock_connect() returns sk_err to userspace but does not clear it:
  if (sk->sk_err) {
            err = -sk->sk_err;

For a blocking connect() the error has already been delivered as
connect()'s return value, so leaving it set causes subsequent operations
like poll()/epoll() to keep reporting POLLERR even though the connect
failure was already delivered.

The error should be consumed once it has been returned to userspace.
Switch to sock_error(), which reads and clears sk_err atomically,
matching the behavior of other protocol implementations such as
__inet_stream_connect().

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Tested-by: Wupeng Ma <mawupeng1@huawei.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Link: https://patch.msgid.link/20260813173024.2362935-4-phind.uet@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 33928aee05aca..0cbe5a1a40d33 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1671,12 +1671,10 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
 
-	if (sk->sk_err) {
-		err = -sk->sk_err;
+	err = sock_error(sk);
+	if (err) {
 		sk->sk_state = TCP_CLOSE;
 		sock->state = SS_UNCONNECTED;
-	} else {
-		err = 0;
 	}
 
 out_wait:
-- 
2.53.0



