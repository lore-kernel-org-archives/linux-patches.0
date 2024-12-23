Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A7C1B413F;
	Mon, 23 Dec 2024 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970634; cv=none; b=OnFP3aSgAHmHIdBC6gBp+/1p76p9SaAlUF6iSej7VsIUBT5Mgw7+9UDAVaDjrpAv6J+dbnu4mXJ9d1VgtyZa8tz1ibefLsA/6yjiLaO2oF05ZMqdhK91r/WQqbRlNOMAKJ46EXtwTkMKYvE8SAZmSH8iqxXu1/FZTiy/UUTZItE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970634; c=relaxed/simple;
	bh=AHpdnK9J1kHNsVCLEywQN7EvkM28opalb/LuzjLbPNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk6GoVUizzXYGjjRHWLE/aum6tHJG0wwdnem3LbNy60uliC0ynW66IdN4sSsYYNIR7fjZSNIDoPzXBto8isU1ilBiD/zWEr17kh8IAEXroOTXDChw7cgSYRbwqzrTi/xWf5hkUvI36VtcVZvIvR+wkHiNP6hANLM8puQFr8TnbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4QBUxeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4QBUxeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BD5C4CED4;
	Mon, 23 Dec 2024 16:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970634;
	bh=AHpdnK9J1kHNsVCLEywQN7EvkM28opalb/LuzjLbPNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4QBUxeAASISZ7fbs3AcXO6DVf1kdLTOQRGBFJMqWeSu2ShdrhQ0il9LCUf+50VB5
	 AxRPbM21gtiknfyz6tvewgx40EKao08YWPpfu+Zb3s/kn50MCWS5Fh8CYmcX8STpO8
	 QvNl5hnl163PCFUFloWxXuM0pe2ydeunhG3zhZ7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/83] net/smc: check return value of sock_recvmsg when draining clc data
Date: Mon, 23 Dec 2024 16:59:02 +0100
Message-ID: <20241223155354.530452168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
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
index f734fdd90c81..a48fdc83fe6b 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -753,6 +753,11 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 						SMC_CLC_RECV_BUF_LEN : datlen;
 		iov_iter_kvec(&msg.msg_iter, ITER_DEST, &vec, 1, recvlen);
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



