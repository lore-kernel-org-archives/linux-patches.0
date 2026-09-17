Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E41D4D17A3;
	Thu, 17 Sep 2026 17:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664611; cv=none; b=WHk6BpqgJM2I6M0SZNx2zMm2/vFaD7HQtnsKsJjLZMfJ+lfbaTJCJTlzMQbXj1aY6Y1K4E1qway+dJ0Gv13sgUQDjGMyWT5V4hyXNA6nx/MJZUvepXkQtAA7qqr/3Pf9/GqpJzgKm4zxMx0GddvRGutsf8vM3rzZEYtpqBFVyvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664611; c=relaxed/simple;
	bh=7nEKSZsqvXl/eaQvXB1kWIbdy/bpEnxMNodKyo02P/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foaJ1EDT3ivV0X9nbWx3qFKQytbvg0I2OM6aRL2jbyEhP9X6F7PEBDan5CXi/FOfB/6JSrQCX54Ffk1By//pUD8IJnhxp+p48HONbzdOFXNzhfLyyvr5A5LP/JOVcYFSbziqEFLqOlM7so7R3FirwfCXso04+5WBspGh988zMSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0ZEP4yG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0ZEP4yG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AC21F000FF;
	Thu, 17 Sep 2026 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664609;
	bh=mpjC4B/0qV8THpcGwO6hITnKfzG4xdlaXLfVIdzKO3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0ZEP4yGAOfFlpTR10feJrT2Beb8/cFBQ9FG2QetcYB/lqISOlkkEQ2m9WRjw5pmT
	 l+30uiB5gM7fogJ2wKEHbDWyTcDjvd5i9GRL2RHKKQsOoZ+lMHSOPVssEv14uA0TuM
	 A0YSp6Wn6zmCwjcRozOBvu6WyCbaR5eBful/GkMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0427/1250] tls: reject the combination of TLS and sockmap
Date: Thu, 17 Sep 2026 16:03:42 +0100
Message-ID: <20260917151603.591657390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 39a2ab47fe720..ab30f5de2c658 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -620,6 +620,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
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



