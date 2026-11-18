Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031703;
	b=GlU9t1E6Uc0524lVjHVm3bvuxf4RBQkZ+I271yCpIfy/wqwdy9EZ4F7fvFWmB90Qlj7a
	 DdrPhnL30RDt4sVu/k+CX/vV0h9U2FowpcAqYWQO4PILYxvF3/QGVWRsG/Liowy7ZEliL
	 1vldanqwxJBjgjz84QQVe37AQSu3s0ewS/mCypVqW92XLDVTpO8N5u4NY30avGo6J1hMw
	 9zPrbSez/phNqk8XHBETWORE87PMhnt5WcXy1NP1i1L2pO377gvo8041AMmi8j4obuNjl
	 dhS1pYSdF4E96vgsWdy/Hvew6OEDDX9qxOAnY7FXcnbsDfn2eyQBXlwKycT1Jb47o4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BMV4BuB3HFZIiOSUiPtRKwHJ/I9UYF69MS5aYBN6Naw=;
	b=FxEiARCr/TG2+Xco2LUci3SlvVZendKKIwJXuphFLRCPUCiq+mQtkRWUc5bgtn4EgxrW
	 Lg7F86ovsHCGZSezN/5P0gg3Ug/BRWEK4vZ0YcSF85Wuh016Oe+io24nMrNJYX36B34Qd
	 UMqNRCiOVvGfgevYQUMyaZ1cZiW9PyfJz3z5KI3Lab8PtzHdRFIi/HxQ76Q/mN5eehGj6
	 1l4wzJS0VtZvP7FUWrroBCevjuTlBZ/LX60FnEMmZJnhMooQ0gGlHk6SRLtR95PgWBYC5
	 FJirarVbfg6gtMAPTl5VctMal95D71DNK6dEix13E5RN9c35VU17NVowx8XeWrjtDdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9G8fMuq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113E3606A31C;
	Wed, 18 Nov 2026 19:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9G8fMuq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FC21F000C4;
	Wed, 18 Nov 2026 19:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031702;
	bh=BMV4BuB3HFZIiOSUiPtRKwHJ/I9UYF69MS5aYBN6Naw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9G8fMuqTXO9XtZMxDksU2U8roaiGd0upBcVWbXlj7PUBTrWUMG/0hxx/O0RGJrKL
	 UJuX4gKiiuG59ur+6vvIAT5Y+uAw5qm54nizlII7MSjrokZ4i4Vr5GyOFs3qa3rJsQ
	 NINiIQLSoW+g9Jm/Q1SXaTDSceHasOsmlAuQpzLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1110/1756] tcp_bic: fix divide by zero on max_increment == 0
Date: Wed, 18 Nov 2026 15:53:57 +0100
Message-ID: <20261118150054.343966586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



