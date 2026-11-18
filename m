Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041347;
	b=wXry3HOB29bGT147QVxezqGLLCqxZqiJVrWTSOgQ7pyejw4yU77RRwq4KouJQOyhecIL
	 heh5mbFAnE/AY9GE8JDzjUfGKSn6D5XAJsrxgqRjBTyCr59aV9Of9D621Fp+BqvX32an6
	 vDJ3ghFo1YijMz0zy41JdRPMZRrqFFbXo8RrLiLVZ9hXupU71Fd4jDHniBy8DpaKr7Pnl
	 zNSQbrneOk84/pgxFcMgX4M9HHhQxcXkioFKQbkygNoZ1FZ9MbTOHc2warZiVRvkXslCN
	 9udVSTV9nor9PZIlz+7hkF9Ls4mDISgENH5YQTVHcokBo9le3zcfwHboMPkNFqN1Bug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nQKGzf4u+ZcxIkOjlaHS5XocWfiQStzwR6GYRjRbcs4=;
	b=EphjOlHdBpNuQJ8WoRbby1FAQ49k4bE6QmLa/KPIwth9Y9v1gjxAU6MZAC4CgSBK8xFP
	 N50L4DzudD/PBIGN+ddYJb1Smn+SdkQXdmyFseSjrTArIyCZBV2QkO1pt9ZH7aQboLQRa
	 wG+derPMQxYP6fBxQr1Epn2D28fInOoiHXMTJ+/nsbR045VcnadXA1HCWhTwDrS+BkYbf
	 12B5dv6Bqg6OmzAFqwmz0z2zYF8PVGiZcR63fBhNpxk8O/j3P3gfVFl2edKsBEKaHlzBV
	 MNDFR/XWquPNWKJ+i8FXo1ecUecyXvaVNDDetWytN2sEQUE+ZjePvUJwx5PJTH8tqyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F92L/wsO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49217606A325;
	Wed, 18 Nov 2026 22:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F92L/wsO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08BF1F000C4;
	Wed, 18 Nov 2026 22:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041347;
	bh=nQKGzf4u+ZcxIkOjlaHS5XocWfiQStzwR6GYRjRbcs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F92L/wsOEOXQJcHO7E5g+Brj0fCD2sAtyAsb2VD4gXH5FeVgwjiGRaBio/2KHUjn3
	 SDQ5u7OVwspB9yFVJquI0I7VZZy/mIcVdbpduio7TQd42l8z7Lc7tSpd0FtiSzjPbI
	 IjEc3gbXnSro3swZXO+QRtwuXZXpOV73Y0XkY0bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2781/3318] tcp_cubic: fix divide by zero and endless loop on bad module params
Date: Wed, 18 Nov 2026 15:56:43 +0100
Message-ID: <20261118150444.131379029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5ff7be13deb6b..64910dd2ba9bf 100644
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



