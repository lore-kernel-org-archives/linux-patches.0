Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF551EF363;
	Wed, 17 Sep 2025 12:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112593; cv=none; b=oRDHm9QSbjnVQEwHzkWhLy3SRH+gV15y/kDEiNkfAsTatOirPF/BXdyqPMJEkXYRHMDPqWR/MazH7sAkx+x/9ie99wezgOlv3coZrB1Mr7Lh/XPRXn/+Bui8BrRHnQmD+wbhcEtJYrXBJv/ArHUM6fYjpR8OpR62orDt7MSMgig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112593; c=relaxed/simple;
	bh=5ohiv6wy9HEVaunM7cDb77K48+WbF4HbKOeL3S6tVV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUR2k9iXffxn8dqY1cJPdfZUC0nUZUzfcIh2A0SmfJUWshPAkLa/b7CJrdImQfm7qpsoLyZszMRzVa5ifWZq48d2kUayVmfjEF1xRb/eG5y6sCgOZ7SXAzVqK0kp4O5tRSUFOdtrBcN5wYGEuNJdZqkEnqF0DRh0Tlum3L3axxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gm6cBd7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gm6cBd7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BE8C4CEF0;
	Wed, 17 Sep 2025 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112593;
	bh=5ohiv6wy9HEVaunM7cDb77K48+WbF4HbKOeL3S6tVV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gm6cBd7fiigwM3Ay/t13igwsXMWhgws2d4fmx2RFg+JiUISK33wiMQqinmBxDC7/r
	 DVbI8+VBqoiQIgbE8p1FUcrtTnyI6ZIq4A7VGpStsh5uWsw/Jnr+iOM1DhUgKch3hZ
	 0Kn5FET/nF/PeLqwj+pLnf1kKdj9FsU3OQiCxWss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Worrell <jworrell@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>,
	Scott Mayhew <smayhew@redhat.com>
Subject: [PATCH 6.16 018/189] SUNRPC: call xs_sock_process_cmsg for all cmsg
Date: Wed, 17 Sep 2025 14:32:08 +0200
Message-ID: <20250917123352.296768948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Worrell <jworrell@gmail.com>

[ Upstream commit 9559d2fffd4f9b892165eed48198a0e5cb8504e6 ]

xs_sock_recv_cmsg was failing to call xs_sock_process_cmsg for any cmsg
type other than TLS_RECORD_TYPE_ALERT (TLS_RECORD_TYPE_DATA, and other
values not handled.) Based on my reading of the previous commit
(cc5d5908: sunrpc: fix client side handling of tls alerts), it looks
like only iov_iter_revert should be conditional on TLS_RECORD_TYPE_ALERT
(but that other cmsg types should still call xs_sock_process_cmsg). On
my machine, I was unable to connect (over mtls) to an NFS share hosted
on FreeBSD. With this patch applied, I am able to mount the share again.

Fixes: cc5d59081fa2 ("sunrpc: fix client side handling of tls alerts")
Signed-off-by: Justin Worrell <jworrell@gmail.com>
Reviewed-and-tested-by: Scott Mayhew <smayhew@redhat.com>
Link: https://lore.kernel.org/r/20250904211038.12874-3-jworrell@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index c5f7bbf5775ff..3aa987e7f0724 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -407,9 +407,9 @@ xs_sock_recv_cmsg(struct socket *sock, unsigned int *msg_flags, int flags)
 	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &alert_kvec, 1,
 		      alert_kvec.iov_len);
 	ret = sock_recvmsg(sock, &msg, flags);
-	if (ret > 0 &&
-	    tls_get_record_type(sock->sk, &u.cmsg) == TLS_RECORD_TYPE_ALERT) {
-		iov_iter_revert(&msg.msg_iter, ret);
+	if (ret > 0) {
+		if (tls_get_record_type(sock->sk, &u.cmsg) == TLS_RECORD_TYPE_ALERT)
+			iov_iter_revert(&msg.msg_iter, ret);
 		ret = xs_sock_process_cmsg(sock, &msg, msg_flags, &u.cmsg,
 					   -EAGAIN);
 	}
-- 
2.51.0



