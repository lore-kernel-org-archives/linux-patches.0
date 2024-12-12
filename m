Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E4F2080D9;
	Thu, 12 Dec 2024 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025848; cv=none; b=Q/Mdl+eKJ9bP3GN/kR4SOM/5nE9feU4AQvG+M6DNu+D6zlXX2BasKAl4B/ovsoQJ1HVvcT2ZtohT/zvlIRcJQuH/60Ra6JWPNzQKN+HvDgZgnjjJdEtOqdalLedwPleZ0S7xyW1wY9IZaFoARwoscOboDuS50P0Diw4YlpsPqvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025848; c=relaxed/simple;
	bh=VPOn3M18wPIpmAQYuCz0+6Yir30HXfsemOpthLERoGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/IxEAZ6GkMPOeXRBmPEQrpkw/dDkScT0GJ4LPBCKRbATtWlqMWZsgLwNk+thBbYg17C/bV0kTvQJaIpU7K/iKonh47P0Z/m0GNz1tFWgo4GYYUU4rRw2VVRmTEJE+9L9+RPICN9l2jcwfyoVjdXbCRQVrDIi0RVkduIuTuZm1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sgytflqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sgytflqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3A0C4CECE;
	Thu, 12 Dec 2024 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025848;
	bh=VPOn3M18wPIpmAQYuCz0+6Yir30HXfsemOpthLERoGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgytflqrMXOhHoW9RdCOwL3kBXfxfucl/0htf2D8b6naSPoKBlP5p4onqBa8gA7Xf
	 Yhw2iV1toSLUV+g9jjvmwQhf+ES6dHcPEYTl9YtPok34YxLSTUWdtzy9x0Fevwv59k
	 PAmRu9kBnkNVCtDrp/+GizjWNipPpiLCAxHW4FJ8=
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
Subject: [PATCH 5.4 277/321] net: ieee802154: do not leave a dangling sk pointer in ieee802154_create()
Date: Thu, 12 Dec 2024 16:03:15 +0100
Message-ID: <20241212144240.921283053@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ce5f25c89dfaf..b5f8aaa428844 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -1055,19 +1055,21 @@ static int ieee802154_create(struct net *net, struct socket *sock,
 
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



