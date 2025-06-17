Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6502EA14E;
	Tue, 17 Jun 2025 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177142; cv=none; b=p2BrOzfMGPgzPjHysjqoLYkET+IHp03teyH5P5CN5GV7hVc5BFrgtqkI+F8RMKArqSLugxNsWkhFkBdWzsQVKPK84o7GARynyr70bD36L2aMEbs4qgdHYb6q6Fl7AQlUNHqevDDPelgxjnAZcW+o0YkJEyjztIeD0J5e6juewbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177142; c=relaxed/simple;
	bh=ZR2fujcdIMtUNdtqYCiMHk+gqfyXSP+Pjx8ZymjO3f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeAZmqPBOAntFH6GaqdxEO83xfiXAhGgQ2fLEw7qqATJgN7mpnmunx5RmNDyXNgwmxtelB+3Xx+l82vAQkGpjA5QuUjqQLeShtl2FwJrtTQf2gH2diCOwDkShEIoiFDs6TxJhwg/szLuwz0BhibyTRspm1vwjsLJAL72k16pCQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVAbmTcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVAbmTcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F3BC4CEE3;
	Tue, 17 Jun 2025 16:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177142;
	bh=ZR2fujcdIMtUNdtqYCiMHk+gqfyXSP+Pjx8ZymjO3f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVAbmTcWp2Ww+btRUR24Ps1vZvUQsztee+9/QW8Mj0wZ8cAeQrZG0XdIyDxhvUPA1
	 FRgqHHycPAvqBjIcDXcY9JRgTFVwS3T0WcXKybh3MgOvPEycOQZnVB2oI7Ib3gncK5
	 XLv1yGKnQxNqBfkFgsTGJPBnGiN0pQOav6kCuHo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 258/780] ktls, sockmap: Fix missing uncharge operation
Date: Tue, 17 Jun 2025 17:19:26 +0200
Message-ID: <20250617152501.962744596@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 79f0c39ae7d3dc628c01b02f23ca5d01f9875040 ]

When we specify apply_bytes, we divide the msg into multiple segments,
each with a length of 'send', and every time we send this part of the data
using tcp_bpf_sendmsg_redir(), we use sk_msg_return_zero() to uncharge the
memory of the specified 'send' size.

However, if the first segment of data fails to send, for example, the
peer's buffer is full, we need to release all of the msg. When releasing
the msg, we haven't uncharged the memory of the subsequent segments.

This modification does not make significant logical changes, but only
fills in the missing uncharge places.

This issue has existed all along, until it was exposed after we added the
apply test in test_sockmap:
commit 3448ad23b34e ("selftests/bpf: Add apply_bytes test to test_txmsg_redir_wait_sndmem in test_sockmap")

Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Closes: https://lore.kernel.org/bpf/aAmIi0vlycHtbXeb@pop-os.localdomain/T/#t
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://lore.kernel.org/r/20250425060015.6968-2-jiayuan.chen@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f3d7d19482da9..fc88e34b7f33f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -908,6 +908,13 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 					    &msg_redir, send, flags);
 		lock_sock(sk);
 		if (err < 0) {
+			/* Regardless of whether the data represented by
+			 * msg_redir is sent successfully, we have already
+			 * uncharged it via sk_msg_return_zero(). The
+			 * msg->sg.size represents the remaining unprocessed
+			 * data, which needs to be uncharged here.
+			 */
+			sk_mem_uncharge(sk, msg->sg.size);
 			*copied -= sk_msg_free_nocharge(sk, &msg_redir);
 			msg->sg.size = 0;
 		}
-- 
2.39.5



