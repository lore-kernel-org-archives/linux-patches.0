Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049577;
	b=SP3Bhn2hz+USjVj4ozeVu2ZaR29MTLjdbpYSsTNF97CP+ABvP1ey8LsCVv2TRmsS3UII
	 EPqrNxteBXse9UQTMgc98pvQzQwo1SJ9Ns+ime0vML6TrENvQxb8yHSXWUEStToBeRPBw
	 xBR6PnYVX+HqKHniLFYKVzq0Y9DfX1851QgOZkndwsg0gUJck6gp8pfB2W26BGAMRnPk6
	 hEeqwcS2hV5jlMRHlldDqsp0+zYwrWuS26GRTRFRAZw6bW71Uzv7NPrvs6OZMRlfsoFYi
	 7oFjWLRwgCUWHbOGTtZWRe1Ka0ZTgUCKByN/SM9+svPeWFa4aAmx8v8ui6HPyRidmmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UHBweowZy67Z4/yrO11ezipFk+ihGzCfDE1hDYfVVd4=;
	b=txvhbVc3IRAs5Xobcp5qSs7URyi6n2QhW1A6Ike3gMsg73tzLnXQqSJRiGIM84cpkA2F
	 Uk2T9ydynqh2+5ZL5Kj9HjsYm6K3NH5pDaHIjrFYDz8Pa+aTlTHIXsWJrn7hQnSMWankx
	 oFjJdsXfDLc1sVadk1LWxVOHTE599DnTC7rJ63e1k/yIbzCa1TWs7fKlDxOKRW0vlTAnH
	 HWA8uBexsykC2vJhnxjThqERyjMwc1cG3UGOrDqCF3GELWVWbRnuik99byDezsJtgkeQO
	 TBWdHdJRD46FZa9/R/e1tgYPs8/wVb7uj+vKBMK/tzw91DXmTSzFrl6t2kr6KxhDpdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XqdSfbkj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE77606A331;
	Thu, 19 Nov 2026 00:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XqdSfbkj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CA41F000C4;
	Thu, 19 Nov 2026 00:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049577;
	bh=UHBweowZy67Z4/yrO11ezipFk+ihGzCfDE1hDYfVVd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XqdSfbkj18AWDcJYdXZJWLxOJsDTY4aD+X2PDJS7Yf0crSVrDBrbqzOeYJjPZmgF4
	 /NOsX/9c9fVZtj495iVA82v6YESJ6jQ4t/lcwgKqwJ+equntAOV9SRLYCxSXecblDB
	 Do/clec6gKuzluRF6niCcSpRJL176cvhyw0r8iVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2399/2857] tcp_bic: fix divide by zero on max_increment == 0
Date: Wed, 18 Nov 2026 15:57:13 +0100
Message-ID: <20261118150327.899875659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 8edbf6c23363563e508a61f3f26f4e4b6eec9dd5 ]

max_increment is how many packets cwnd can grow per RTT, so 0 makes
no sense, and bictcp_update() divides by it.

Reject values below 1 when the parameter is written.

Fixes: 83803034f423 ("[TCP]: Add TCP BIC congestion control module.")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261008092641.140777-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
index 58358bf92e1b8..08f58cdeb7f80 100644
--- a/net/ipv4/tcp_bic.c
+++ b/net/ipv4/tcp_bic.c
@@ -27,15 +27,25 @@
 					  */
 
 static int fast_convergence = 1;
-static int max_increment = 16;
+static unsigned int max_increment = 16;
 static int low_window = 14;
 static int beta = 819;		/* = 819/1024 (BICTCP_BETA_SCALE) */
 static int initial_ssthresh;
 static int smooth_part = 20;
 
+static int max_increment_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 1, INT_MAX);
+}
+
+static const struct kernel_param_ops max_increment_ops = {
+	.set = max_increment_set,
+	.get = param_get_uint,
+};
+
 module_param(fast_convergence, int, 0644);
 MODULE_PARM_DESC(fast_convergence, "turn on/off fast convergence");
-module_param(max_increment, int, 0644);
+module_param_cb(max_increment, &max_increment_ops, &max_increment, 0644);
 MODULE_PARM_DESC(max_increment, "Limit on increment allowed during binary search");
 module_param(low_window, int, 0644);
 MODULE_PARM_DESC(low_window, "lower bound on congestion window (for TCP friendliness)");
-- 
2.53.0



