Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CC91EBFED;
	Tue, 15 Oct 2024 12:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994248; cv=none; b=XYZ1S/mK9DGZsec7RF2DZ+oeYJOEWxZfLdLYoWva6gSRPYax70PYfKXoMaMr8BQidXOB+HG/D5ujDlUK3244ESaHjyKMRd0CBvYlOsifDj+NSpPT6OV5+UCnk8Qr2MCBGvo/eZF/T8eyfmH4GqdSXR/EFMCzFM1Tp2IMk5zAxa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994248; c=relaxed/simple;
	bh=jTX3Od56k0KZz3vBiV+7zCXlbrrpVHZQwfHKNDmOO1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXlr+r/9+B79X1zpDiZCZtJX+SNNZmi060iiHORnhLSvRDr4C+jvbS66501Unm4GHb80DfYWLErj1L9/0FQNFg8dy+FVF3x8qPZ3yd/nW3TmWi49v+e5W1QTyvKcLfUH2W1RyesHhcHcPyk0aaf7j+8xuG+MiEWiBEAKSNZQkds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyLfOV+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyLfOV+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8593AC4CECE;
	Tue, 15 Oct 2024 12:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994247;
	bh=jTX3Od56k0KZz3vBiV+7zCXlbrrpVHZQwfHKNDmOO1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyLfOV+TIKndjOfW1uYTzS6OAQBprwATQaLMjKNAr17aY1ZRvnFbP0t5OWCsN4a3t
	 ToKzljxRA2nFkJVpbG+qugw0EW/3un0Ifi5LFN7DJ/48wlekU395NZEfohsnbV4zHt
	 fi1atgSQrv+jpY26SU3LYV76C/uyHP0JSxVn6qZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 648/691] sctp: ensure sk_state is set to CLOSED if hashing fails in sctp_listen_start
Date: Tue, 15 Oct 2024 13:29:56 +0200
Message-ID: <20241015112506.043426909@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 4d5c70e6155d5eae198bade4afeab3c1b15073b6 ]

If hashing fails in sctp_listen_start(), the socket remains in the
LISTENING state, even though it was not added to the hash table.
This can lead to a scenario where a socket appears to be listening
without actually being accessible.

This patch ensures that if the hashing operation fails, the sk_state
is set back to CLOSED before returning an error.

Note that there is no need to undo the autobind operation if hashing
fails, as the bind port can still be used for next listen() call on
the same socket.

Fixes: 76c6d988aeb3 ("sctp: add sock_reuseport for the sock in __sctp_hash_endpoint")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2818cf160f3a3..528d9ecf1dd86 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8516,6 +8516,7 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	struct sctp_endpoint *ep = sp->ep;
 	struct crypto_shash *tfm = NULL;
 	char alg[32];
+	int err;
 
 	/* Allocate HMAC for generating cookie. */
 	if (!sp->hmac && sp->sctp_hmac_alg) {
@@ -8543,18 +8544,25 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	inet_sk_set_state(sk, SCTP_SS_LISTENING);
 	if (!ep->base.bind_addr.port) {
 		if (sctp_autobind(sk)) {
-			inet_sk_set_state(sk, SCTP_SS_CLOSED);
-			return -EAGAIN;
+			err = -EAGAIN;
+			goto err;
 		}
 	} else {
 		if (sctp_get_port(sk, inet_sk(sk)->inet_num)) {
-			inet_sk_set_state(sk, SCTP_SS_CLOSED);
-			return -EADDRINUSE;
+			err = -EADDRINUSE;
+			goto err;
 		}
 	}
 
 	WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
-	return sctp_hash_endpoint(ep);
+	err = sctp_hash_endpoint(ep);
+	if (err)
+		goto err;
+
+	return 0;
+err:
+	inet_sk_set_state(sk, SCTP_SS_CLOSED);
+	return err;
 }
 
 /*
-- 
2.43.0



