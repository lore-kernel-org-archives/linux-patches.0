Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7B73A6B7F;
	Wed, 30 Sep 2026 18:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794632; cv=none; b=QzA7l7VZFz0vcbzs7ktBKwNA5OYNUJ5XgbfkMUCYubiPmu6cuzd7Z/4GuQuvtY6hbw0B8Q4KIzqG8q20ZncSPkHVCw+XGWGNFpsOKcmqDggkD0wzwMXWjcDXVr6DvvhtWsqyVBZ3FLzeI6JvaOhP0ek8f89EhFkwal1it1W+ciY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794632; c=relaxed/simple;
	bh=hoIDAKNjBFCC9Vln4rZHCR77heY2GGnlaQTa943lMhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMvkZ+ZFIOOOJB5yRXlRvf2c3FW8jaEkTDc8YMyS7llKwXPwcJQwDUweCaBAfuzjWLDSdkttbtNR4JCkh8aJWRP0S+KPXOyrTczuDNuietDBKrspIqygtApDIPKaVpLPIP1T/QUEPq9BqPUNbfL5qQrtURG0jrpyYnyvv+Wsg+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szk99kYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szk99kYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9A31F000FF;
	Wed, 30 Sep 2026 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794631;
	bh=z/nv5lNJbhKyfyBQcRWgReb5P/nryYNC5T234wsYfPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szk99kYcur8FfDUkB1RdJGhpeMs3gxbK2jn1ouPihKwgx/jpg+2kah/O0jWCEbgOk
	 IYmjKajLu6yqHoRElTs+8/ShZVTlwmiwQ1A5Zad3V5YfwNiI87eE+Fsr06qS4H1kzn
	 BBG55R/Pz33nujt6+fr8ghB0BV2nDsY2Uj/m9Y84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0234/1193] tls: reject the combination of TLS and sockmap
Date: Wed, 30 Sep 2026 17:15:18 +0200
Message-ID: <20260930152439.393259437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c7ee44bd32064..d57336820ef0b 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -592,6 +592,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
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



