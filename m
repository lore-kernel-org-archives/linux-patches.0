Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041342;
	b=UibrQdwHCfU9MGEEW6GPnkfUfS2HerS9F4oQAQE7ycbvN27edYCB01HSQYjGDzSRvS9v
	 y6X9Y6hlLUi2PGb43zeIW06uUm1ju0m681IPd7wXwvDn0TTli/Jn4Py266tW+TwPcsKH+
	 jeE518up2zRnOD08iEa1eg7w4Q6UyXjQFOHiKRSJDeRIL+pn6xGn94tLk99SvOnxo2au7
	 03EWwgoUrisK9uH12vF9kZNDTat59iFL+9PlIQgvlpsVQ5czTle4JZOhct10nN5X0uu5c
	 F+50K6F4KwYsAeEmbZprE+aO9OteRFlSV+hElToOEDLjL4k95OX/d9bIg3vvimMO6sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yfzUk5/wVYgDNe4VQ5IOOyMFA8uxcw/N1mLEpH+LgcQ=;
	b=V/5KkuSz5RwuIWp+M3h+JZTMyw58uhZyCeZtsJjDUbgpvyQ18IxMzzuwK5hYxex0jAh0
	 OGSMsfQgqyXSZITvSTgFx4m4/XH/mLM9QzPvfpZxSC4xlrK77ZzW4DqBFNTjmcInPQEnF
	 oxdFCupUtP5IaDEKMIh5yIbcDgjvbnAFeYM8srorSTmJCeusb6fZH+BEQBKC6mFwYFKU0
	 2TX4iyWOUNXGD9pv8oyETala+95oZnulsYuRkjzmCQnWZd9TTcuYzq7YnewCyztrlA21u
	 nKWbW9rgF5+jDePH02Bnipko5Q9bmR12EVue259Asj98hLq44bhUKFd42c+tQwHO2hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7uQckbo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042E9606A335;
	Wed, 18 Nov 2026 22:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7uQckbo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EBB1F000C4;
	Wed, 18 Nov 2026 22:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041341;
	bh=yfzUk5/wVYgDNe4VQ5IOOyMFA8uxcw/N1mLEpH+LgcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7uQckbouqfTZ7PoRKHpVuQCctCShKfZ3iyE2uHFtdY/za6/gCZrB3Bx/t92kThE9
	 bj5eHB9H9VMry1CcGYJ0+j9qoij9xzYYPSogDsOXGqjHZIlk9b7GNh1UU+0OhqfCAy
	 UxNLpygRSEcBgUnPPEegoD4dcKBuzYVsgNCFPdRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2779/3318] tcp_bic: fix divide by zero on max_increment == 0
Date: Wed, 18 Nov 2026 15:56:41 +0100
Message-ID: <20261118150444.072462819@linuxfoundation.org>
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



