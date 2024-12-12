Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62202210DA;
	Thu, 12 Dec 2024 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021194; cv=none; b=bxCeQBBicsTID/nQcO1j2QWuyDKIUreboX3Nx6SZq9cT6se1PoMkYwNLWPHppqhJ4rS9zCeYv+IPHcDWTta4o9UnD4bpQYXoIk82275O0ziyT3fC6j9yca0x7wcbt/MRfhio3KRg9iVOcu86bzUbR2fuWYWXSV4+EX6XQfS5NT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021194; c=relaxed/simple;
	bh=UmHa6mRlTpACfJ2LJ2OohwO0GENuLVPHvchSa6Wo8o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l46dwpQMZYXI9EEplxUZ1EtTMWISUKFP8RLPiZ3CS5V/Bl1zidscda2TgipXeODi1o7WcC1qW/5RxihQ85wrtBGQ1srDfRudQgt2JtVDO/Lo4j7JKH7YwLJB0fks9zC+reZlDUEoOGtQywOrm+e8YkPmUAYIao4QEg9GYCFFS5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/k+6D+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/k+6D+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7C0C4CECE;
	Thu, 12 Dec 2024 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021194;
	bh=UmHa6mRlTpACfJ2LJ2OohwO0GENuLVPHvchSa6Wo8o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/k+6D+/zkpnbf0OaAJhYK0PLIfMdWoD9YP/Nlc+r5/FreJAG31oplCn9RYDi8EjO
	 lulPUeWViz7G4YIrjtFV3AP8ORUGaplYi7UP3mjfocBTHT333r96l0J118w7ClDXzb
	 PuIRyYuOZNwArO6z1sLWV2FzWijGHF63GApSp7w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 671/772] net: ieee802154: do not leave a dangling sk pointer in ieee802154_create()
Date: Thu, 12 Dec 2024 16:00:16 +0100
Message-ID: <20241212144417.641153738@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit b4fcd63f6ef79c73cafae8cf4a114def5fc3d80d ]

sock_init_data() attaches the allocated sk object to the provided sock
object. If ieee802154_create() fails later, the allocated sk object is
freed, but the dangling pointer remains in the provided sock object, which
may allow use-after-free.

Clear the sk pointer in the sock object on error.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014153808.51894-6-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/socket.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 1fa2fe041ec03..9f74be2aad000 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -1046,19 +1046,21 @@ static int ieee802154_create(struct net *net, struct socket *sock,
 
 	if (sk->sk_prot->hash) {
 		rc = sk->sk_prot->hash(sk);
-		if (rc) {
-			sk_common_release(sk);
-			goto out;
-		}
+		if (rc)
+			goto out_sk_release;
 	}
 
 	if (sk->sk_prot->init) {
 		rc = sk->sk_prot->init(sk);
 		if (rc)
-			sk_common_release(sk);
+			goto out_sk_release;
 	}
 out:
 	return rc;
+out_sk_release:
+	sk_common_release(sk);
+	sock->sk = NULL;
+	goto out;
 }
 
 static const struct net_proto_family ieee802154_family_ops = {
-- 
2.43.0



