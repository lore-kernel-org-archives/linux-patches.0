Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD5F7FBB2;
	Mon,  8 Apr 2024 13:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582872; cv=none; b=dervgwzd6ng7sPLGOD8o8QjwYSCAg0Afh4Aa6ecNZpnNvTjNdDdl+GTFwJpeC6rBH0oyYYk+bITRblPQvUNGJf/fRKFR1bFT8yvCQFf+Xtq0d8cqVUS49lHK2yc2fKotdQ5gzhQ1RpgaGSALXmjDKEyawbJpbsMHyQmwLKSloC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582872; c=relaxed/simple;
	bh=sqD6pfYPeDyvHef/98gn5vtvLP/89OryUJrE+Q/CuEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAHaXAI/pBB7bmBbPiLmPsWUgR6tkATwpSsbXE3EsSliYe0ZyfR9xd5fw/w1h8RBG3luNiDb6rZqOuk5MlQtqFSg/QLstgj0T3df8eApTnrjr0Ix1TvlzRyX1fnQYR0ld9NqtrSRX+1y3wZbw8tpdoDfEhaoey/xN2mzoF4bhWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+FXGEKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+FXGEKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D34C433F1;
	Mon,  8 Apr 2024 13:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582871;
	bh=sqD6pfYPeDyvHef/98gn5vtvLP/89OryUJrE+Q/CuEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+FXGEKnASJh6pHRN2wswj4pnO5Z2eecOp0QH36o0dlGgZ68Lr7s1pUtfRkhtw3hj
	 uuNVE5VUwajt/LJgsoTSObjYA3/gq0X0MEkTcSXbgoaUDKDoPeouCfriUlMtV2xoVP
	 S8OCkxCC67W5GnghATZgmKkbOgOkNHyiSy240mA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 112/273] tcp: Fix bind() regression for v6-only wildcard and v4-mapped-v6 non-wildcard addresses.
Date: Mon,  8 Apr 2024 14:56:27 +0200
Message-ID: <20240408125312.779005573@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit ea111449501ea32bf6da82750de860243691efc7 upstream.

Commit 5e07e672412b ("tcp: Use bhash2 for v4-mapped-v6 non-wildcard
address.") introduced bind() regression for v4-mapped-v6 address.

When we bind() the following two addresses on the same port, the 2nd
bind() should succeed but fails now.

  1. [::] w/ IPV6_ONLY
  2. ::ffff:127.0.0.1

After the chagne, v4-mapped-v6 uses bhash2 instead of bhash to
detect conflict faster, but I forgot to add a necessary change.

During the 2nd bind(), inet_bind2_bucket_match_addr_any() returns
the tb2 bucket of [::], and inet_bhash2_conflict() finally calls
inet_bind_conflict(), which returns true, meaning conflict.

  inet_bhash2_addr_any_conflict
  |- inet_bind2_bucket_match_addr_any  <-- return [::] bucket
  `- inet_bhash2_conflict
     `- __inet_bhash2_conflict <-- checks IPV6_ONLY for AF_INET
        |                          but not for v4-mapped-v6 address
        `- inet_bind_conflict  <-- does not check address

inet_bind_conflict() does not check socket addresses because
__inet_bhash2_conflict() is expected to do so.

However, it checks IPV6_V6ONLY attribute only against AF_INET
socket, and not for v4-mapped-v6 address.

As a result, v4-mapped-v6 address conflicts with v6-only wildcard
address.

To avoid that, let's add the missing test to use bhash2 for
v4-mapped-v6 address.

Fixes: 5e07e672412b ("tcp: Use bhash2 for v4-mapped-v6 non-wildcard address.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240326204251.51301-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index c038e28e2f1e..4184d45f890c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -203,8 +203,15 @@ static bool __inet_bhash2_conflict(const struct sock *sk, struct sock *sk2,
 				   kuid_t sk_uid, bool relax,
 				   bool reuseport_cb_ok, bool reuseport_ok)
 {
-	if (sk->sk_family == AF_INET && ipv6_only_sock(sk2))
-		return false;
+	if (ipv6_only_sock(sk2)) {
+		if (sk->sk_family == AF_INET)
+			return false;
+
+#if IS_ENABLED(CONFIG_IPV6)
+		if (ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
+			return false;
+#endif
+	}
 
 	return inet_bind_conflict(sk, sk2, sk_uid, relax,
 				  reuseport_cb_ok, reuseport_ok);
-- 
2.44.0



