Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10F3239E63;
	Mon, 23 Jun 2025 13:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685371; cv=none; b=OBojDIWWWAVIncBObDQ0AWc8ZQD616wCHEYwYhF8t4SamnPiyp/+qpnmPU6dsEz3WdHE+qs5Ec1vcy+6N6DEqOG+cmFA0uybsvrxULn32lMBcacauyzf7ZQZgBrmATth0DAib+o/BcpgROW6XzshMwhaUthnNux1P3Bgzc5VDuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685371; c=relaxed/simple;
	bh=uVbibeV5FulFDxj7aQdxPSemB5df6w+A0pd6Tq62yjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwSO+wbD4/oUJKU/MqhppoOXbpheliOMkwQiBom7rFXOhThEjVZvqVVG9oFZAA9IaHXVO8E5/WUUdDuGhuIUghE7HmSCqR+dWx4IUWDwP56aD1DV0tRJPf8q1nmZWTiwW9aObRTaFB4MDh+Mji/7RHy9FcIrVcJ8qhH14MaGimQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIsWLx2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIsWLx2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D8FC4CEEA;
	Mon, 23 Jun 2025 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685371;
	bh=uVbibeV5FulFDxj7aQdxPSemB5df6w+A0pd6Tq62yjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIsWLx2I9ji5MWxuPwJsAVsk8MIsh+z77pMTVGzoEcIWiVCaYaIiOUckwW13a5Chp
	 BYaKDuwITGdHVRH8jejGH4/Z07fiAyRN1L2yFRbMXEeZKxAu5Gof7tGdI/edNPteWJ
	 YnHfeMSOcIA/FGkhsp2C8cX7pJnCd4Ez/ajaE8eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/411] ktls, sockmap: Fix missing uncharge operation
Date: Mon, 23 Jun 2025 15:03:19 +0200
Message-ID: <20250623130634.645468491@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0f93b0ba72df1..6648008f5da73 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -893,6 +893,13 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
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



