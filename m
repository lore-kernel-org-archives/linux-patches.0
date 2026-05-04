Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8F03D9029;
	Mon,  4 May 2026 14:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903478; cv=none; b=DXUlqGJPZBkTp1sVu1/Lo91/u0xSaqgeIqnJuQZUTiSLtCWMjGJ3NY2zLPbrgB1QjX+DpDzCrsikkp9jA3q9DJmdKHSKmmKsrftH3+Oh6VVteojBGALVYS2jcdREpIDqXyZFWkfeAA06FkWs3R3qjVmFSZf9uZ+jnKSM/0WpmFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903478; c=relaxed/simple;
	bh=YV6F/BOiZon3BW+Uy8shInW+EqzD04Mc0T8QrBmz/W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px46TKBQ6ANOKh+nwr5pYK6ir+lxb5yX4FrAwOOH9RiweXSw6GXbYErMIKqK6+ODzg/WZ1xg9907aUyrT8YhrkcegtcWLI4vu+q4KhPyGm6pYjf/5utxWpoybv6++e1wk6MhzI9Wl3/ODWtOz+ksdZhb/5QhBDMSN+bntmg4Mp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7FDmo9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7FDmo9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806C2C2BCB8;
	Mon,  4 May 2026 14:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903477;
	bh=YV6F/BOiZon3BW+Uy8shInW+EqzD04Mc0T8QrBmz/W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7FDmo9DlWJUAl3ueEWNQEqebM0SH9usrY/7Y9rquq7KVDrnP8cHAp1+aG/WnqUBH
	 txZ6zi5aJybit2DwXqVEbHOfWKnn+oUXzb50AyoainQWv7eIGG+CPNmfeRvX4AbYRW
	 HQBpubzbUxIuuf4tOPL1dE5uW+SH0c56SxQkNRgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 7.0 250/307] mptcp: sync the msk->sndbuf at accept() time
Date: Mon,  4 May 2026 15:52:15 +0200
Message-ID: <20260504135152.228179782@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Yan <yangang@kylinos.cn>

commit fcf04b14334641f4b0b8647824480935e9416d52 upstream.

On passive MPTCP connections, the msk sndbuf is not updated correctly.

The root cause is an order issue in the accept path:

- tcp_check_req() -> subflow_syn_recv_sock() -> mptcp_sk_clone_init()
  calls __mptcp_propagate_sndbuf() to copy the ssk sndbuf into msk

- Later, tcp_child_process() -> tcp_init_transfer() ->
  tcp_sndbuf_expand() grows the ssk sndbuf.

So __mptcp_propagate_sndbuf() runs before the ssk sndbuf has been
expanded and the msk ends up with a much smaller sndbuf than the
subflow:

  MPTCP: msk->sndbuf:20480, msk->first->sndbuf:2626560

Fix this by moving the __mptcp_propagate_sndbuf() call from
mptcp_sk_clone_init() -- the ssk sndbuf is not yet finalized there -- to
__mptcp_propagate_sndbuf() at accept() time, when the ssk sndbuf has
been fully expanded by tcp_sndbuf_expand().

Fixes: 8005184fd1ca ("mptcp: refactor sndbuf auto-tuning")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/602
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260420-net-mptcp-sync-sndbuf-accept-v1-1-e3523e3aeb44@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3570,7 +3570,6 @@ struct sock *mptcp_sk_clone_init(const s
 	 * uses the correct data
 	 */
 	mptcp_copy_inaddrs(nsk, ssk);
-	__mptcp_propagate_sndbuf(nsk, ssk);
 
 	mptcp_rcv_space_init(msk, ssk);
 	msk->rcvq_space.time = mptcp_stamp();
@@ -4228,6 +4227,7 @@ static int mptcp_stream_accept(struct so
 
 		mptcp_graft_subflows(newsk);
 		mptcp_rps_record_subflows(msk);
+		__mptcp_propagate_sndbuf(newsk, mptcp_subflow_tcp_sock(subflow));
 
 		/* Do late cleanup for the first subflow as necessary. Also
 		 * deal with bad peers not doing a complete shutdown.


