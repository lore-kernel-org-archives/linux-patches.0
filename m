Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B77C31DD97;
	Thu, 28 May 2026 20:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000336; cv=none; b=kVQnqXs2pKu695Z6+gPeMRBe40/vnkwk1HssGbKnwTiRjmfqVuSTyN4FZFdADOif81/dxHG4PECM7YItF/SN5+hfKoNAKWpou/Z+l0YcSzwoYofqz6/JV8v8/tuAXnfIZuGZfswronuIJ55a8UMyyj4rUQkWyOp7diOMqIxx4kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000336; c=relaxed/simple;
	bh=w+4jS/jMibBXLT7ttX7tHGhIn4/GQEmt3fbT66dcuy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWRE8314F9u/gMog0b2IyaHOhOL4rx3MvbnkI/BeQgkOKhDRGIngOopwY776K7IZYyJ48As1qQD2Rq5TU7ye52XUhmR401YBL+oibaav7uFe8a1erc0llPZ1Vivtkd4I0bIw6+2bxcXg3tpDWmP043+Hh50CwYAuhB4h+ZO38a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boh/8yLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boh/8yLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01191F000E9;
	Thu, 28 May 2026 20:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000335;
	bh=MytMPCtuN7JtdyzMKKKxS8w7RyE/6HM3IiCZ8riOIMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boh/8yLxDMhfG7nd8H8OtmV4c8rtDqYEc8aK679qJSTAT3v0MyN9K+OV0lMZBgJ+8
	 BazYJ3KXN8uIh2UZxdifg418y38mCnpTDCziWjj42Ol6mzfQs1OyBtbFWAKIUBa37v
	 ffT/s2KQY0VlRRFGdwcXu6QhEtjSBWRGQsLPLoOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/272] mptcp: sync the msk->sndbuf at accept() time
Date: Thu, 28 May 2026 21:46:15 +0200
Message-ID: <20260528194629.424529211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
[ No conflicts, but move __mptcp_propagate_sndbuf() above the for-loop
  (mptcp_for_each_subflow()) present in this version, which will modify
  'subflow' used by __mptcp_propagate_sndbuf() in this new patch. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7dbb666c72c30..c1b1fb0fe8bcb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3493,7 +3493,6 @@ struct sock *mptcp_sk_clone_init(const struct sock *sk,
 	 * uses the correct data
 	 */
 	mptcp_copy_inaddrs(nsk, ssk);
-	__mptcp_propagate_sndbuf(nsk, ssk);
 
 	mptcp_rcv_space_init(msk, ssk);
 	msk->rcvq_space.time = mptcp_stamp();
@@ -4101,6 +4100,8 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		msk = mptcp_sk(newsk);
 		msk->in_accept_queue = 0;
 
+		__mptcp_propagate_sndbuf(newsk, mptcp_subflow_tcp_sock(subflow));
+
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
 		 */
-- 
2.53.0



