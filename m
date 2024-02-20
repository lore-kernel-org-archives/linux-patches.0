Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FEF612D7;
	Tue, 20 Feb 2024 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463943; cv=none; b=AJYI+GGMHguZY14cwf0T2zA+IdgArhO9bI8FPnIhLIaAUwNBT/bPl1imN05p5Ti/wRVJwLIw9tvQhoMktsgqvfyxqRIYY+3SQr1IQ+I+swFBNxwAW5FpGU4nGd20mzVgJRShI78Qc2Gtflk3WCxu10y9v/aK/WDH1oO7ZpGutMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463943; c=relaxed/simple;
	bh=b9xL94zkT98y9LgNjMbUuTyGg1HFlk+0LzdL9IBsEx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvyPDnpYrW/+3/XlQZkfOlS/nhMEDL8YFGtePyNVdjusm3c4Mb7n/07QZKw2mJpj36De9nyfZa56lWgF44sJMQ0CbY9iTyEbZLkNiLofaU2JQMsApCajhe95Qdh/9jrCq+fPOFsirNS/9LQLZVf5zDmVK7fGLHVJaf0ou7GZMyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFTcqjK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFTcqjK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E92C433C7;
	Tue, 20 Feb 2024 21:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463943;
	bh=b9xL94zkT98y9LgNjMbUuTyGg1HFlk+0LzdL9IBsEx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFTcqjK5KU/gPyshjV0T4JIw6MNmXepxub+t2ZcQxOx1gqc/MEWZs+O5ERceOx8/V
	 KTGQhBxUtuJH9cCNhyPN7sB1cBzJ9r14ggX+kL9viT5KVN8D71EBsQvcqmzagSOwH7
	 nMxJRMmPbBzkML1eBFk9qab5ntppfh8pIzcXiat0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	xingwei lee <xrivendell7@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+3266db0c26d1fbbe3abb@syzkaller.appspotmail.com
Subject: [PATCH 6.6 202/331] crypto: algif_hash - Remove bogus SGL free on zero-length error path
Date: Tue, 20 Feb 2024 21:55:18 +0100
Message-ID: <20240220205643.988201992@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 24c890dd712f6345e382256cae8c97abb0406b70 upstream.

When a zero-length message is hashed by algif_hash, and an error
is triggered, it tries to free an SG list that was never allocated
in the first place.  Fix this by not freeing the SG list on the
zero-length error path.

Reported-by: Shigeru Yoshida <syoshida@redhat.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Fixes: b6d972f68983 ("crypto: af_alg/hash: Fix recvmsg() after sendmsg(MSG_MORE)")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: syzbot+3266db0c26d1fbbe3abb@syzkaller.appspotmail.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algif_hash.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 82c44d4899b9..e24c829d7a01 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -91,13 +91,13 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 		if (!(msg->msg_flags & MSG_MORE)) {
 			err = hash_alloc_result(sk, ctx);
 			if (err)
-				goto unlock_free;
+				goto unlock_free_result;
 			ahash_request_set_crypt(&ctx->req, NULL,
 						ctx->result, 0);
 			err = crypto_wait_req(crypto_ahash_final(&ctx->req),
 					      &ctx->wait);
 			if (err)
-				goto unlock_free;
+				goto unlock_free_result;
 		}
 		goto done_more;
 	}
@@ -170,6 +170,7 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 
 unlock_free:
 	af_alg_free_sg(&ctx->sgl);
+unlock_free_result:
 	hash_free_result(sk, ctx);
 	ctx->more = false;
 	goto unlock;
-- 
2.43.2



