Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE6080C02;
	Mon, 23 Dec 2024 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969724; cv=none; b=ODxVRMEnDM8vgS+zWVUJi1PpBlrluBxoAHBmwOagz9uGtmX6CNbRxKMKdkUEtrTmGIvY88lQHvHPieSCem1ZC3QS4LGnoZqkYHQwtCFm0Md6nsC061PwfePANsqf1X3YakPq4aCaDDj6VlvZBPWoUc2VZ69IP7ED7Ipl6/D7rS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969724; c=relaxed/simple;
	bh=OFsZt0sOpbOOLc+7NSDYSnr/6djRvx5B3Y4kSqfvCrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcQi5uAmNXkGRAgzoQLdTMsc1fqnXAg+8FQFQY3Fzw3XJGv7RgLgOqxZhNai3LmGvrVGCs8Mz06JAWzlmv7ku2D6egyC1Qrp3sbh3Ciaw8eqhvRbfph7M7mp12HBW4uW1dmyIEp0KdT9bIPRzsd5lqDndOMMCstwO6VW3nbJg7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7+GK8Ww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7+GK8Ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FCDC4CED3;
	Mon, 23 Dec 2024 16:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969723;
	bh=OFsZt0sOpbOOLc+7NSDYSnr/6djRvx5B3Y4kSqfvCrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7+GK8Ww7CX6T4+1jqfzjwdJ33i/3hvmzTOEHjjVMyIYoemfivILhNJDBszUrxvuI
	 No26D6xPYvvIn3/ane7+JTmQGwG0YHlLQl++Mbq06IE+rkv1jCy4KDoxlV1wJXfUkr
	 vpuXT1DHFV3XEImN696a8hq+AKLomjX5MWhVRA/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/160] net/smc: check return value of sock_recvmsg when draining clc data
Date: Mon, 23 Dec 2024 16:57:27 +0100
Message-ID: <20241223155410.071647841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f721d03efcbd..521f5df80e10 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -774,6 +774,11 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
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



