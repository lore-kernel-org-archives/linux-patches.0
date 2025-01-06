Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEF51547F3;
	Mon,  6 Jan 2025 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178546; cv=none; b=DtW6cvs0cnfke7RFjSZqoTB1HDjXMg495zcWZW+vRgawzGCmt+oiufAXWXaqKg4OQmk1slBYjpJJ3Vt2JnFRAQUqQM/tW0Pd4jBVoXFsttx/qiESLpW+7YvgvTsbpB53c2QiT6FoaZlM8f2Js2VzZkqv7z0fjJQznHlY5ansS6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178546; c=relaxed/simple;
	bh=h66BB7ZzPPha3uLIcqgzc4Uuhlq7hzAoVsGOSUzmbTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3W8lVPFu577AjEuSb21rNlS65BgPAZzt/Vmpovpz7SEcTLplQ/sAliQkSUh3ETLGmMNomP6rWnQzKb/NQcggGfhVcbOJjLXPI+8ponrnANFd3eeR66TZnfB15qoiDnyplj+Oe18pfiK2fhbIyRRhldkIMr2H3bYF5pxk8Dhijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/T9xxHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/T9xxHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FD7C4CED2;
	Mon,  6 Jan 2025 15:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178546;
	bh=h66BB7ZzPPha3uLIcqgzc4Uuhlq7hzAoVsGOSUzmbTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/T9xxHlmZNVJtBpwUmcfkHb9QxUbkyhoq/iedp8oW6KoPBYgw2X42+v/A27vZOy7
	 ZoIEMtaqZ2PMCzIImZ9H13BuG9gdy9FH1uEflcW4AayH6sOwzZwQbG1cdAeHKASVnd
	 PkdFt36hp8IggWO1lxo/gK2C8RBMJU8QtyzeG6FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/168] net/smc: check return value of sock_recvmsg when draining clc data
Date: Mon,  6 Jan 2025 16:15:24 +0100
Message-ID: <20250106151139.076294983@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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
index 035e8135ea49..52a0ba939c91 100644
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



