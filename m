Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656D41DF98B;
	Mon, 23 Jun 2025 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713285; cv=none; b=hjSjzO6PZUKDprlyEwDKrg8OdHnLaTkMG7GS/q2Z30JTAUbOUofKFO+vKdpGZ5UzR1lVTYyDtGETfQx3MjLHcakZjWTgL8WikNFO7tIrYGttoX/2eP3Hats+yMkxfm/OAYI3ztUlDnsxC52LBwXUzfDLVrKNlCh4mCgBOIoH+Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713285; c=relaxed/simple;
	bh=fmv1/WROGjvSvxvlwBkkW2i5dL06c6JNnKPH43Gy9mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcZfLLTRnWTg2Hy+ZGzUJ9dEZxi/UbnP7JCwMhs1O2pnDgXGRO8oP44tNPmsYsafJMpv2ADeo3lHsLYdJGISyiJvyy7EfDsKPyLU1WF3y5rpLX14OwbQ4Fs9gL7hiB68hfZXh4NkqKR9WE2dOle2zNnlQ2bAsyvTauoA80bDOCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7sGM9/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7sGM9/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D38C4CEEA;
	Mon, 23 Jun 2025 21:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713285;
	bh=fmv1/WROGjvSvxvlwBkkW2i5dL06c6JNnKPH43Gy9mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7sGM9/pX5c+2luKNQv14eXCTJLWvTWCcb0jFdUtk6pvPh4LJteqG7L6qi8OUaWbb
	 SssxbHtPUBWfOl9qrMVvsgB/sjo3kAGGxff7kof6HxDvnwh/+p+7TGClE1M/qM0/rZ
	 IVSEuuOpHcN3+td/zz9MYxNh8yseB/stNkvku6qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/508] ktls, sockmap: Fix missing uncharge operation
Date: Mon, 23 Jun 2025 15:02:04 +0200
Message-ID: <20250623130647.181217813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index af820ae9b1a52..5f95f837dfc7f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -904,6 +904,13 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
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



