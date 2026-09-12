Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460693A6F09;
	Sat, 12 Sep 2026 19:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240374; cv=none; b=qzYcMYlheGyzAgdHrzXQyZes7dmA5zf2I1DhOeqhQCcESyfLxxv//2i2jVeOVl6YwoeDZeZd/puAL5PqgrL+wrKj1FuJVT48+jJ7PdmBIB40nF6Hiv/JtTTudVSvWScvjH99tYM44VHMGTjqscUzw76AzNfdcqh3jlYKocr5NMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240374; c=relaxed/simple;
	bh=5LhX1iMnNjiAv/w96ETSUA1Ia24RxSBvx35prPTU1as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk3LVdZUUas6zjARApq/Bdc5AJn6dvGruwYXeRZJNEpPxiWZibgPSZWjFuyNtnIsL/YyLY2MxavEaezKk0MZHcA5pQgf0v900ApcxHbsHTSgxZtzp5vY3M5h1JI2gIiA6kvb+dStleo3PI2LlL7hA1p5aEm+nSTO83SzCLB3SJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QaGF/L3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QaGF/L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0741F1F000FF;
	Sat, 12 Sep 2026 19:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240372;
	bh=SlmVcO11Qr9sq+FHj6vfu7tZBugzHFwcR8b01FtTaD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QaGF/L348lhICyjRbvP1eycqTvDul4QXFZtPGu9XCqF8d6K3XOb0yp6FiTC4DjDu
	 07n7+odwRs8ZOUdgz+gDU/dbJiweZW572K6BkQBTuHxKC6gB1qlY8IoH33befQvaKQ
	 dWy5yhJntrluXRJDPfdOFwsZIcobUsbVbTgz5XlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 853/935] vsock: use sock_error() to consume sk_err after a failed connect
Date: Sat, 12 Sep 2026 09:04:43 +0200
Message-ID: <20260912065546.391530587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cf9bf589d454a..972e00d987a0f 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1533,12 +1533,10 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
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



