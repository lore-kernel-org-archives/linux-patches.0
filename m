Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650F52AF0E;
	Thu, 12 Dec 2024 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016795; cv=none; b=agPcZ6Yvs7PcMtyyeybkK/79TMWsUOQmoX9BxqfxaQyc/Th5p5Mik2nMXRGBgwlg6yPG/fFNzvJdxjrGQm5zOBJiWkqR8DvdRFzanY1VTOHoE7k+Aqhm9LCjvW0sOlaa+CRbFLTlvexXjFitLA+TFQ4oHtrAPH4dWea1Z20N+pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016795; c=relaxed/simple;
	bh=ElIgnmesERrN/qD/0/4zFDiASQBZ/8vudOBHkqJ+qSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OToqXGFELoiZqPLImikmIW+2cYHdyucQsvBnfUCfYXugohKAXUaV1z1ETO2XNUC8RZyKlKEcEa/YNhAOBJdkwxBV8WbYMtPFEwnTmY/Z/lP+iy0GLpmTGjbQAfJhv6Gs7DyBxWZKw3TT4E5UK9riRWj2yJoIzQMSICCpF5gOEko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8YhrPMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8YhrPMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA73EC4CECE;
	Thu, 12 Dec 2024 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016795;
	bh=ElIgnmesERrN/qD/0/4zFDiASQBZ/8vudOBHkqJ+qSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8YhrPMNh0Gyt3J2ngJqNVlKSexXG4878DygR1DtQVOnt+2JbvZkpLBvUobwpfMuK
	 E3mL4sAFwWPM0jrOugREJnqnOa+e/PLL/gtBRK95tzMSY2bFHYa9KJmN51y0r/IizI
	 fS+db32nFygYZqgZ/GkfqsYY0R5Da5hV6olIgpm0=
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
Subject: [PATCH 6.12 291/466] net: ieee802154: do not leave a dangling sk pointer in ieee802154_create()
Date: Thu, 12 Dec 2024 15:57:40 +0100
Message-ID: <20241212144318.284324355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 990a83455dcfb..18d267921bb53 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -1043,19 +1043,21 @@ static int ieee802154_create(struct net *net, struct socket *sock,
 
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



