Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049582;
	b=Z2z473CBCNekcS88FTrsgcqAzBnEq94S4qXZ+aFXspBX9TTe2LACIfBc2NMc56IX7WAK
	 U7Qx2dVrrg87OvGYxNGV+EM1Eo2GeApltYGbNCID5Kx/boSrtGJ7Ybu5C/e1EJ5WtI9Qw
	 HJQj6KPoBdtNuPRJbSkQuqvemzDj4RitIJz/QLJC7AI7ljHJbT26LKpxHbbBhbiuQpz44
	 nG6dR3Ur1SwackGfUvFxYwl+Y9Zrtbd9XAoQp0r4IGf2wslg27bMe2G884nDvHY8ZlMVI
	 D+cv254p5I5SKxg0foqLQHCmbqf9fsarxAIEys0PHjyvQmHe6MhSviWgaByqHSr8PXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zhLWrqcrMAW9eMBJpEWzxCRkSXuvEQloMHOeAWjl3dM=;
	b=IqBfXM2OAhQLMyXr5G9cpiBId1Vc+dBjCWDOBSsZd1fzZLu6jJriYF4tPA67vU5G3vzj
	 r24mDk+L3t3kBd6QDMRq9oUQ1pRG/Xu6tsZ9UqBqFDw3sLX9fSLTPk5rtSxTo6zPh56wy
	 UctMcWANxch9AXaKWUNtRRjPf9/O6bo3IFZyZAl4TXc41bGeAXasDVL5ePr7mtcguZZa/
	 88sDQiymaGlBpvbxcVZuiwp0j7hibp0ytSUCDkxtlfy5Qd9L4m8p0uscSkt1gs/OqRjtv
	 mknxOdJwYRn2LjP7wZlIT9e8R/YDE2iJ8mjXtAQhJKs8NidsEBdw2S1OUaz/X/kHXUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gLw9nzpr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D46606A320;
	Thu, 19 Nov 2026 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gLw9nzpr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE461F000C4;
	Thu, 19 Nov 2026 00:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049582;
	bh=zhLWrqcrMAW9eMBJpEWzxCRkSXuvEQloMHOeAWjl3dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLw9nzprhfF0bKzbeCmdoCKgJJ9+tLWYFVclQz7fR8vQ7lWxWoViGmYLojAJk34pI
	 /e9/xGiDtt5nh1aGfRgu8F+iMtKLY0hGUL4MV5jdImUZcbj+GGfsvZo3P6PADad2uF
	 ti6qSgBF6WCwPrQ6FRZbgEOB1MpBYzd1ZoRRZpnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2401/2857] tcp_cubic: fix divide by zero and endless loop on bad module params
Date: Wed, 18 Nov 2026 15:57:15 +0100
Message-ID: <20261118150327.972348411@linuxfoundation.org>
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

[ Upstream commit 7d52b5d16afc1cf8484ae321658e217a80e3ff4d ]

beta_scale and cube_factor are computed once at module init, and
beta == 1024 or bic_scale == 0 is a divide by zero right there. Other
out of range values give garbage: negative beta can make beta_scale 0,
and bic_scale * 10 can overflow. Reject them. Read beta once, as it
can be written through sysfs before the init function runs.

A small beta also gives a small beta_scale, and (cwnd * beta_scale) >> 3
truncates to 0 for a tiny cwnd, so the TCP friendliness loop never
ends. Rather than testing delta on every ACK, make sure beta_scale is
at least 8 at init, so delta is >= 1 within the cwnd < 1 million
packets limit this code is designed for. This slows the TCP friendly
estimate for beta < 512, a backoff harder than Reno's 0.5, which is
not a setting anyone should use.

Fixes: df3271f3361b ("[TCP] BIC: CUBIC window growth (2.0)")
Suggested-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261008092641.140777-4-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_cubic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index b7c140874d97e..dfa9228a934c7 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -507,16 +507,26 @@ static const struct btf_kfunc_id_set tcp_cubic_kfunc_set = {
 
 static int __init cubictcp_register(void)
 {
+	int b = READ_ONCE(beta);
 	int ret;
 
 	BUILD_BUG_ON(sizeof(struct bictcp) > ICSK_CA_PRIV_SIZE);
 
+	if (b < 0 || b >= BICTCP_BETA_SCALE ||
+	    bic_scale <= 0 || bic_scale > INT_MAX / 10) {
+		pr_err("tcp_cubic: invalid beta %d or bic_scale %d\n",
+		       b, bic_scale);
+		return -EINVAL;
+	}
+
 	/* Precompute a bunch of the scaling factors that are used per-packet
 	 * based on SRTT of 100ms
 	 */
 
-	beta_scale = 8*(BICTCP_BETA_SCALE+beta) / 3
-		/ (BICTCP_BETA_SCALE - beta);
+	beta_scale = 8 * (BICTCP_BETA_SCALE + b) / 3
+		/ (BICTCP_BETA_SCALE - b);
+	/* bictcp_update() needs (cwnd * beta_scale) >> 3 to be >= 1 */
+	beta_scale = max(beta_scale, 8U);
 
 	cube_rtt_scale = (bic_scale * 10);	/* 1024*c/rtt */
 
-- 
2.53.0



