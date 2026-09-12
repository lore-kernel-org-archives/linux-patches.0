Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D46135AC3E;
	Sat, 12 Sep 2026 09:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204343; cv=none; b=mcRMuOEKkIZtdux4bHsirRivvNu6SUkrZfW7svQu8GZ/bdkhbUnmlwH9fvsZbXreimlRA359Ytkj/Mg4vMgACeuRBOzRHzGokknOTf1blfLLUxgOpbyOxmUMqkXrBNWoJWs+b5lTZwSRBjC3AKZc9VJ8VWcYsseBkMnOulJBYFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204343; c=relaxed/simple;
	bh=GCO0WHPMLADQd4wSYNAQMNDuk/HaIomEW/ff372Y96w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRFA0TEPTITj9fJRPPYtsXKpzWjx9EAafNIpE9ROokCoags3U82pZn+Tp2aXd5kUT+DZgL/ZsyjhneTipIVRmjbWt8XCk/FVSYpI4IUZpzvqUaB096K5ipZo35wJhuRQ+/OGDuuuJiyz1Z8Cg9bkzRDNO4amGFTujC9cjjthbwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC4vFi0Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC4vFi0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7571F000FF;
	Sat, 12 Sep 2026 09:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204341;
	bh=q938hlCiaVS7zJ1Znsjd8Wo0pbxPYB//vDl/Idn4VCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PC4vFi0ZYG8DeelT+Cruud0Nwqx/th7AwIpIY4kAKqySG2fcetAzuqtRKs2p0gaXC
	 ICiw0ZinFaUznzQJ0B7bwGoipCSMLuF12FHEw0fe8GdQr1JfHOyJX0BROb7/226Gv/
	 BzffNBRXASzREv6Y+nDBk5b9VCAPoGSJikZip0rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1592/1815] vsock: use sock_error() to consume sk_err after a failed connect
Date: Sat, 12 Sep 2026 08:55:42 +0200
Message-ID: <20260912065726.364215186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3cd5c3561be33..78e60ad043633 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1847,12 +1847,10 @@ static int vsock_connect(struct socket *sock, struct sockaddr_unsized *addr,
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



