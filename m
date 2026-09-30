Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2725050E5B0;
	Wed, 30 Sep 2026 16:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784579; cv=none; b=ZJsz+sZly+O4OBsUxIKfo698g7i8fxTu/Vg/CgGsPpTdG14NrxebmgEqCiWQlzd8dV1GUB5YbK2YQ+7VtLFXD5hBt9nZIb+R2GqnbOgEXEuOLf5ALHPkGRm6+065x0GQPkDzgAV0BTlZZ46uxhwjiW5hPhM315luLaui9jz1kWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784579; c=relaxed/simple;
	bh=4V02PAk6YRaHB/TcY9x6XNOihod/3WkGxgzZSE8DAug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3BtI3+Dl1Qw6UTVXuK8ZCveP6Nfv86WA7eqaDv8YDtIOE489XY1DJfldFB/hDSnjRX4MlPb8vW/yWaYN0++FUacfGhquZPTgmq7fgjXzElWRYrYm8BWAng33VfYcYkDnzEaHzREDqoCkHQMv+5chrSYmgJ7yWWPlZ8vcYpx5So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3wprDWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3wprDWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EB71F008A6;
	Wed, 30 Sep 2026 16:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784575;
	bh=rqbPY88sTEJBYlsxLO2gjFOpOtkxhibo1u9varOlrfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3wprDWsFs3jti8t3qFhwPXRY9rN5Ng4kb3fecIrmSFPlvDvj1e2ExNB6zCY0wD4E
	 VTboDxTOUjaidJaXwV2mni6RgNw1SmWGmngR2upG8tCWvDh8FnC41Lq7vOTxwnC2Hd
	 N80gTIx5+1uqHrejbxY3oMQ/J8YvQJP9E5HLWVTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/982] tls: reject the combination of TLS and sockmap
Date: Wed, 30 Sep 2026 17:15:39 +0200
Message-ID: <20260930152421.171961871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 460e6486617c17dd19abe8f3fc67d9a6fa25f8ca ]

TLS and sockmap (BPF psock) integration hides a lot of latent bugs.
Bugs which may be more or less relevant for real users but they
are definitely exploitable.

We could not find anyone actively using this integration so let's
reject this config. Adding a TLS socket to a sockmap was already
rejected by sk_psock_init() through the inet_csk_has_ulp() check.
We need to reject the attempts to configure the TLS keys (rather
than adding the ULP itself) because checking prior to the ULP
installation is tricky without risking a race with sockmap getting
added in parallel (sockmap does not hold the socket lock).

This patch is a minimal rejection of the feature. Subsequent patch
in the series will do a light dead code removal. Full cleanup would
require a major rewrite of the Tx path, we don't need skmsg any more.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 4797f68b9ec80..42c61cd1359c6 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -665,6 +665,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	int rc = 0;
 	int conf;
 
+	/* TLS and sockmap are mutually exclusive. A socket already in a
+	 * sockmap (i.e. with a psock attached) cannot be upgraded to TLS.
+	 * sockmap rejects TLS sockets already (see sk_psock_init()).
+	 */
+	rcu_read_lock();
+	if (sk_psock(sk)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	rcu_read_unlock();
+
 	if (sockptr_is_null(optval) || (optlen < sizeof(*crypto_info)))
 		return -EINVAL;
 
-- 
2.53.0



