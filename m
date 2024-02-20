Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE81509AC;
	Tue, 20 Feb 2024 21:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465132; cv=none; b=oe0W6AHNYzqAs2xJk4L3mg3IOQXrS8KFQKmLBhzLJuRmdcHrXPLp0mPLfiS5P9+kX6KqUcOwYU8MzjwGbO1xrrcWzDpMKvfLCczDKPhD6JkyAtpQbfDMeoZ3YoMf+rxOTBU3+PXCadfPmSq7H6lMvPR1LOZ2+gX3lJFs0bFY1rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465132; c=relaxed/simple;
	bh=UER6QKED5RtPkYLiYLyjdG5gzs4QGX6SS8f6NHIFuJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu7LXJYN3b06hsRzyyJhbED2U+rEzhp1E7kktTjnAtLv+7o0HlV02yGr/d/2qe/TB1fP/p/xUiOE+aSN6durCwiWXml8fz6seQAXKaNrbHFatYZ/dZMdFbm7D7UtUki7jpYzJkZJInWNeAoAySzPNXxZNEXLiUCpzQUuVc2K8+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG4Z5Ify; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG4Z5Ify"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59756C433F1;
	Tue, 20 Feb 2024 21:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465132;
	bh=UER6QKED5RtPkYLiYLyjdG5gzs4QGX6SS8f6NHIFuJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RG4Z5IfyN9gu+dQe4Ijk1dS3QQML3kk+3o4MJwKj7FgOzebntnooQpl8/Obdg/cfb
	 2qc5ikPPvIc/R8fRq2BLsPo2uoDLgKJBiMsxg/t1Ovl8531hdX1v7s4teZdfgKygTn
	 GiFoppLOfb04mi3KaRZjJd7QDZpMBXxa3yYcdt9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	xingwei lee <xrivendell7@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+3266db0c26d1fbbe3abb@syzkaller.appspotmail.com
Subject: [PATCH 6.7 246/309] crypto: algif_hash - Remove bogus SGL free on zero-length error path
Date: Tue, 20 Feb 2024 21:56:45 +0100
Message-ID: <20240220205640.860635622@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 crypto/algif_hash.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -91,13 +91,13 @@ static int hash_sendmsg(struct socket *s
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
@@ -170,6 +170,7 @@ unlock:
 
 unlock_free:
 	af_alg_free_sg(&ctx->sgl);
+unlock_free_result:
 	hash_free_result(sk, ctx);
 	ctx->more = false;
 	goto unlock;


