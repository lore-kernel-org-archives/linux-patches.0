Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5601AD41F;
	Mon, 23 Dec 2024 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970304; cv=none; b=Z1kYLP09abaPo3lmh7AHl9ZyTfcBw7CU5UhDvFUwC2cQr4l6qFOM3S0Vx0WPApFqNNfbg9+wcywEVRsrshpQt9HiSoMjLSQTTM4eNNQGgjhkd5/5OjBnI6A+4FNeAidSYFhXehitgAk++DjjygR/khCIk8J+Xq0cXly33m3JuRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970304; c=relaxed/simple;
	bh=XvM3gJoZ89KJWZL2TqJ04P6R0WN6Rfyb2wSCSyroIRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYKIzsvlD+gMG1r20SG3Uu0DZZmsWFZi7aA8zul8MWM+ov321LSIj6w9xZg2eGVXT1vAP2mShgKRuD4azCSEukCOFA4JJBp2t4l5B0hL8OSl4WRz9071tYyvbMeGa6jH6/IoErt5/tJhqHc+6rHF8MKXzOkOuSqF6bQsrCP3n4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHXR2xeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHXR2xeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75889C4CED3;
	Mon, 23 Dec 2024 16:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970303;
	bh=XvM3gJoZ89KJWZL2TqJ04P6R0WN6Rfyb2wSCSyroIRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHXR2xeEV8DKzW+Zv0F+bFLpNmIaqsEHM+jI2ACIYxXlaYFoSvXijpRvlFKUIeu9w
	 g4/+zrkD57UrHdyv7dy1GS398N6XoTufKxUihN9tUK2+7MxNW1IRpGmGWf6+CH+H0w
	 aCZEhyz7aZ60z4w21la5WvW5mH2ZFIA+srDeVwzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/116] net/smc: check return value of sock_recvmsg when draining clc data
Date: Mon, 23 Dec 2024 16:58:34 +0100
Message-ID: <20241223155401.273591550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 286d6b19a1f1..dbce904c03cf 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -773,6 +773,11 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
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



