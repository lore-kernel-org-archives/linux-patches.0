Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C942DF3C9;
	Tue, 17 Jun 2025 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174853; cv=none; b=gz8thjNOlkRnuKc8iG8cnOuQD2orksO7jKhc6S1mjkyHTrCCPL9S5yRYRianBEHkp2WDOSt+7SzbVEkO+wj9psDobSFA/pV6ssOEpTrix3P5ubVaqSI2qf7Q1tNNg1WOa4FchkQhbrPc9JSBpwH+/c2WU9sbdh+4Js4ajHRPrJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174853; c=relaxed/simple;
	bh=aF3+v6jO19X6CZiosVcHHegyhlY0joSrYz/UfjrXZfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfunDHXfSQfeDhplQD1NgTT1y1vkIjKknCVyTtIJDc6Imt82BHUvKbA+BKUjnFHCE0cWi9YZT5YiaY8KlNo4nppZX7LfOKssoR9NMIEkPkxh0NUtX+P+wFKsQFo6Ut+rB5jFat/3ieLY/xqaeb69gDWVRWIj9s+TZpZKNm/AT6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C77ypQA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C77ypQA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D85EC4CEE3;
	Tue, 17 Jun 2025 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174853;
	bh=aF3+v6jO19X6CZiosVcHHegyhlY0joSrYz/UfjrXZfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C77ypQA54a3EAB6YpzU3J3FqgvGDpMaOV/fLejf28mOwqu9vNjSv4rZWM+7GKq7+4
	 ucCxvNoTmGHzJGA2AyHL9sw61LckFLTySQl2aHi8IIC+1c26gOuUp1PAX088I7qrA7
	 Fs8WJZn2G9AxfjERiXSKdBfBuTRqNd9PmAN7y1Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/356] ktls, sockmap: Fix missing uncharge operation
Date: Tue, 17 Jun 2025 17:23:54 +0200
Message-ID: <20250617152343.015782308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf445a518883a..4a9a3aed5d6d4 100644
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



