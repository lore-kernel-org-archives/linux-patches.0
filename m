Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779A73C07A;
	Sat, 12 Sep 2026 16:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231955; cv=none; b=puDJPSHIUkBaQqk8FgC1pxe6qHCxttlADOLmXxrcJjYB9tTwNspekGsztsQi8jzR8WBc3Hfz02vCzS3P6djOw41+jXbHvZ3coxx1gKuVCDyarfscMYPH+kOQBPaIM93HK1F3TU6G/jS1SEedD0Dtvd+g1VjoyU/81k2C63FIfvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231955; c=relaxed/simple;
	bh=FXE6z1qv2JmCyHoVUFkdcBxtxYRV6kpOx2xTEeQ68Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieLQ4nOnXyCB9mYrJ6fSCQpouqSfe+WZsBYG2pMEb72bn5ozTapViLaz5yJlrFhr6oRSOK/05laP9Z0E4VlYPlQL+8C2N9INKbq3EXD84WOjAG3ml5H3gvxHWo2yEjpopAnFmVrHSNA5SqxkZMH+C+Ap5hCvfY/GyiMO3xe/i2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWneTP9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWneTP9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F32C1F000FF;
	Sat, 12 Sep 2026 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231954;
	bh=ZPcv6FXu6PPTD+yXnI0OU++uEhYluowHwTat4vCy+Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWneTP9lVsRnM5pQ4fPKgCdqhI7n9vZMwGSCNZUlwk2VjQhQRLSMRIYXZEgcovmGx
	 JvFFnKGC57TRh8FZT01vj4XdTAYu/zjZ0y0a1xC9aERobSTNOXM2nRL9GlSqNn2cW6
	 zxXlPVJyZpsuB4DXozRx1xUysYSRK/yi1KEtDUNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1061/1191] vsock: use sock_error() to consume sk_err after a failed connect
Date: Sat, 12 Sep 2026 09:03:09 +0200
Message-ID: <20260912065612.004366519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index daca9df5a24b9..92685d6da9ad1 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1542,12 +1542,10 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
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



