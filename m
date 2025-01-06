Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1233060890;
	Mon,  6 Jan 2025 15:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178127; cv=none; b=N3CQ94sVlHdKbkrYg6Z/HlXJgIICPbwuPlIad/8iEDJ/XONUA+z6zUeie5P+d3/sUIKLr3PyXxNyeyw2JdlzJ6RVDebr6zAPBK+BmUaN+uvLVUsz2JMmNk/8YX4JhcZ3dg4VUIfPVBdCiQFBvhi7PuV2Xpg5/DsSewfITVWLXj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178127; c=relaxed/simple;
	bh=pMg1fGS7f4UH7lJn/bRBHz4JABjaTkbmV+Zxf26TcPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiFuKYOa315IEJQPZ1tP6uOmgCZLiylUw4A2Rc4qbYiVa7g3jVglKB5tkb5DupvxD5mZZFciGq255LjkApp11k8JUewVwxex6J3BbyRASJNkNDY5BIJoE/hFY2PM0IWpna2bJ9KNuHFrgJwGaY8LqXvxMCZwXOzEeOUh5jyhMus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuzmeHTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuzmeHTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4634DC4CED2;
	Mon,  6 Jan 2025 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178126;
	bh=pMg1fGS7f4UH7lJn/bRBHz4JABjaTkbmV+Zxf26TcPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuzmeHTf4svypjdJmBBqdzIYMEuaBDQ4EZP7cGFQYos3YAJoLJwS+cO7zcy+Cojdq
	 zJKqko3enUKWdWRwLHQCbMMpsGC3ZTMshW5zyXxacxh7uCOcP6hfB4RDQ9EPNdXc69
	 SUMwTyY1zljlLMIM3gZbSH72IBUjq6/WxdQ5bipI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/138] net/smc: check return value of sock_recvmsg when draining clc data
Date: Mon,  6 Jan 2025 16:15:38 +0100
Message-ID: <20250106151133.758201499@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit c5b8ee5022a19464783058dc6042e8eefa34e8cd ]

When receiving clc msg, the field length in smc_clc_msg_hdr indicates the
length of msg should be received from network and the value should not be
fully trusted as it is from the network. Once the value of length exceeds
the value of buflen in function smc_clc_wait_msg it may run into deadloop
when trying to drain the remaining data exceeding buflen.

This patch checks the return value of sock_recvmsg when draining data in
case of deadloop in draining.

Fixes: fb4f79264c0f ("net/smc: tolerate future SMCD versions")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 32cbdc321aec..2aa69e29fa1d 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -427,6 +427,11 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 						SMC_CLC_RECV_BUF_LEN : datlen;
 		iov_iter_kvec(&msg.msg_iter, READ, &vec, 1, recvlen);
 		len = sock_recvmsg(smc->clcsock, &msg, krflags);
+		if (len < recvlen) {
+			smc->sk.sk_err = EPROTO;
+			reason_code = -EPROTO;
+			goto out;
+		}
 		datlen -= len;
 	}
 	if (clcm->type == SMC_CLC_DECLINE) {
-- 
2.39.5



