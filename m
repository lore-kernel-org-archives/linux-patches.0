Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE47F2DC792;
	Sat, 12 Sep 2026 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211737; cv=none; b=b87He5JQvC2WwqNjp/roaPtkZo3Jds+ahhEDukt+RjiNIjHmMKCxON63UZYubrCXZuZqfr7qRob9CHZ9239Ra09zcvzE5xbaO/89dS18aytTpSNeJQEyfk0Mg61bzhbKKA4J9DAqB3JKDJHxGjFEdZ/7TJ/U601lFIuwPAGpeeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211737; c=relaxed/simple;
	bh=wfvsTxseZnNwyeiW50fGC9no5F5BSxiupUUH+sBtYbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IetczH5KvOus55J3HpFopcn+79OugSzFUjXT5VZ3dxTgKAH6hW3976OJlE9vnNNlAw4sZLJAcg5BICsMm9/v2gWdnSlolkVvsUF/lc9IQi5Kru6F4kCWzAYWJpsXLqUgVJJWhIjuFxgMO+AkPpQk2o62po9a3NzQ75E0cBNaRfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr57suQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr57suQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C501F000FF;
	Sat, 12 Sep 2026 11:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211735;
	bh=TYd6LI8ya+jIwArH7dg6RZpIs75X8rraMvtuJ6qwuDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fr57suQxSWVgGatNRf1ZuhGLrZA4n/LQNDT9o6h3zFndB8E0cOeOEn5Ti91RxTT8M
	 u0v5fSJ1DUU9UjSY5QuAE2K8jMpG8f50ualIpwe+OEgkwPc0myDaSLpWgtLqercaBV
	 dD8h7LrflFShi0LrVcrYBUhcLYWeD/Eaqkh0cvd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1285/1518] vsock: use sock_error() to consume sk_err after a failed connect
Date: Sat, 12 Sep 2026 08:57:34 +0200
Message-ID: <20260912065652.583174756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 2f8b1e16caa8f..4ebf1cab2d971 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1716,12 +1716,10 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
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



