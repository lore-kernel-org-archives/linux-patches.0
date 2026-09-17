Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1468D35E953;
	Thu, 17 Sep 2026 18:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668133; cv=none; b=qDJtK6unL1QnkFwi2p7gClNeZe8X04z8qiJ7VRbw3Pk+3mBO3GxOSGmtS2ahbmnMzPGWBtkbWTGkSkygj389K0LRh5UoyYcXsmPQ6pwnPHkO+X6BBaFdsh+fPo+YuEa4HYNCj0aXyPfg3mqw9YaJKFDLNDLgCXug6GVqTVhrHp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668133; c=relaxed/simple;
	bh=RNHJoSUto3sYsoWjgCuJ2jKGyvgqjzkSOWLqazq9npo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwkqpBFtPiLv7D6lG6q/r5gAjKw3/esa5IYZqQmllKTvU+sz6kNIvARAHS0uB9lGm7sDo6y/Tm0ywa1a8KQ4CbFiykNhTvXcfxNUy91yXLGgIVmQ1Sc26FxK+OVxqhc3Vf9ropKdf8DQ3YV90hdsYlKuNVRTkUgNgLQ3R+wkqsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dv3AO0xg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dv3AO0xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306101F000FF;
	Thu, 17 Sep 2026 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668131;
	bh=dSYbvSey7jsSOkmtQ+DWde3AwplXycI9rQnNcHPMU4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dv3AO0xgcKZZUDoD452L4+auejOIpcW/ZrHISOrK5tpnH8+IfEf1hOFmdUe88Ojva
	 oBi5LDlbYNz5+l3S+Z/+Mnu1LZMxtODUudZ2EVlGuqKk8wxU8PGlWyo+VQDXYwCWx0
	 NGZjYqfxP860rhuY3q3tjARiNoQt5vwZh7lNm0Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0322/1102] tls: reject the combination of TLS and sockmap
Date: Thu, 17 Sep 2026 16:04:25 +0100
Message-ID: <20260917151547.714990473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e52e4c91c9091..a8dfee9a17e58 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -617,6 +617,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
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



