Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47AF227BA4;
	Tue,  8 Apr 2025 12:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114119; cv=none; b=VIXkDtX9PLReribQMxBGFCeKKCqB/3yWIJi+X762p5wkQXyIo4bsihbiMAwzxab2RvRfjMNpaNxTlCO38JV7uQJqf1LyzWXh/wkLQl06Ni6exJWPS3eH3eLl/3iD+FZ15kabU9MgMKtrqXZcDU6+ByXsXBYyMhs/zNd9FQTrfGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114119; c=relaxed/simple;
	bh=1HzEKMxLyJj1MXfo8p6W778mH3arsg4V2RKX4xXIl8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxUth3bdJvXMqvWlHiZ+MrT+bH5POntrdOVhGCqOFdRYFmeC+8ax41wu7alFNZNTp8I4Hj6rGxoYVwVsE7sosoYKG0uKOiUFtLorQ0BfWA6PV/mU655XljMDKwE44zNYw126sua6olGJTW4HoOBdIJsBXC1O4uyfYg8Ya/y7ixs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loqssiTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loqssiTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7301DC4CEE5;
	Tue,  8 Apr 2025 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114118;
	bh=1HzEKMxLyJj1MXfo8p6W778mH3arsg4V2RKX4xXIl8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loqssiTp8QTqbNkl5E0sdJEBPtbZvqZ1IHhtBdeSpkVtOyKbtlqkcEWi5oFfSy/6a
	 96aNuA2is9/v/K4Gl8dSKRNk4M78QGr4wfbCyWPMBHv120IiUwiSCvHZ7HA7dAkswk
	 eYz0/LLAlRgqbtLuIFu+ugfSDYQIcAbME8i21WD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/154] vsock: avoid timeout during connect() if the socket is closing
Date: Tue,  8 Apr 2025 12:51:23 +0200
Message-ID: <20250408104819.863587602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit fccd2b711d9628c7ce0111d5e4938652101ee30a ]

When a peer attempts to establish a connection, vsock_connect() contains
a loop that waits for the state to be TCP_ESTABLISHED. However, the
other peer can be fast enough to accept the connection and close it
immediately, thus moving the state to TCP_CLOSING.

When this happens, the peer in the vsock_connect() is properly woken up,
but since the state is not TCP_ESTABLISHED, it goes back to sleep
until the timeout expires, returning -ETIMEDOUT.

If the socket state is TCP_CLOSING, waiting for the timeout is pointless.
vsock_connect() can return immediately without errors or delay since the
connection actually happened. The socket will be in a closing state,
but this is not an issue, and subsequent calls will fail as expected.

We discovered this issue while developing a test that accepts and
immediately closes connections to stress the transport switch between
two connect() calls, where the first one was interrupted by a signal
(see Closes link).

Reported-by: Luigi Leonardi <leonardi@redhat.com>
Closes: https://lore.kernel.org/virtualization/bq6hxrolno2vmtqwcvb5bljfpb7mvwb3kohrvaed6auz5vxrfv@ijmd2f3grobn/
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Luigi Leonardi <leonardi@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20250328141528.420719-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5d490633a7f11..7877515a6962e 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1204,7 +1204,11 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 	timeout = vsk->connect_timeout;
 	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 
-	while (sk->sk_state != TCP_ESTABLISHED && sk->sk_err == 0) {
+	/* If the socket is already closing or it is in an error state, there
+	 * is no point in waiting.
+	 */
+	while (sk->sk_state != TCP_ESTABLISHED &&
+	       sk->sk_state != TCP_CLOSING && sk->sk_err == 0) {
 		if (flags & O_NONBLOCK) {
 			/* If we're not going to block, we schedule a timeout
 			 * function to generate a timeout on the connection
-- 
2.39.5



