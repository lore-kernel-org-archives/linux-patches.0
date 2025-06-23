Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673E92550CA;
	Mon, 23 Jun 2025 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685298; cv=none; b=n+r3/bn0eVFZPLmqywItNt6jnDJEYlWjkhSd5JGvjiP22dmIcVknaLcO6Jo+qX1dstFx1yGhNEj88aWZ4M/VHJOvLlVZd+OtAd+mDuQn+1OzffJLXqZIX/pz2Cs/xX6+DN6bf6yK9oaVJxQw/MBjvsCnCqngMuUGHRW9YySQCh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685298; c=relaxed/simple;
	bh=c0nmHqqjqtyisT0DMS/PbAp5KhQt2refKqbqarku0Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwZ42Escx+bXb2Nvf64sggOOJHSUwY5cB429qwqtY+fAeLAU2XYypw+9LwIf0v6g5vyKsJS9oNmx4rhjXNvAoQAL7PXiVuYAvopLA2Nf4pSGue7pb3BLqlZftTbmioSqP/VIGOyBNiUtm+Uoc4fHek+ouaCgn/SmSxs9dSmnjig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvpEkC0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvpEkC0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A1EC4CEEA;
	Mon, 23 Jun 2025 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685298;
	bh=c0nmHqqjqtyisT0DMS/PbAp5KhQt2refKqbqarku0Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvpEkC0RONpJreybLA0Ub17fpxyxRwUiMDh9btw3OTlC+TT18z+Vz0s8n4WR/uL7i
	 jWUu3EEEiAQbkY6Bid48v7+EuCZYbSdqWE/5i2MXCBjKFzqN0OlF9Tgelq+0k8vd5x
	 /QQscwMrhb+NcCE7jFNnCEgl+l08Qmaa7XEGvuoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/355] ktls, sockmap: Fix missing uncharge operation
Date: Mon, 23 Jun 2025 15:04:04 +0200
Message-ID: <20250623130628.119047427@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ec57ca01b3c48..0723b3a4f6d91 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -859,6 +859,13 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		err = tcp_bpf_sendmsg_redir(sk_redir, &msg_redir, send, flags);
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



