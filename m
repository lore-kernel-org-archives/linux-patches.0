Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF2168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212ACC433EF;
	Mon,  8 May 2023 09:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539703;
	bh=bGnXy37wj+1zZwVkd//dszMleNfsUbjCbVnwQOr/H10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gx3LtoN+r2SL3tQ0scC/qVi/72Q0oynUwROQZ4eHZWMyLabom1MDgFRpa/VP9Q+xX
	 c/a8M0m82fPYfXVStotiC75xwuabHNWK9/0Huq9aHalRx/e83WJBNWsl5awsA1hsoI
	 wYssqeVBM6SiOvSWJ7DE3VjBOElqN0gpS2bBeQIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 069/611] crypto: api - Demote BUG_ON() in crypto_unregister_alg() to a WARN_ON()
Date: Mon,  8 May 2023 11:38:31 +0200
Message-Id: <20230508094424.236772771@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit a543ada7db729514ddd3ba4efa45f4c7b802ad85 upstream.

The crypto_unregister_alg() function expects callers to ensure that any
algorithm that is unregistered has a refcnt of exactly 1, and issues a
BUG_ON() if this is not the case. However, there are in fact drivers that
will call crypto_unregister_alg() without ensuring that the refcnt has been
lowered first, most notably on system shutdown. This causes the BUG_ON() to
trigger, which prevents a clean shutdown and hangs the system.

To avoid such hangs on shutdown, demote the BUG_ON() in
crypto_unregister_alg() to a WARN_ON() with early return. Cc stable because
this problem was observed on a 6.2 kernel, cf the link below.

Link: https://lore.kernel.org/r/87r0tyq8ph.fsf@toke.dk
Cc: stable@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algapi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -472,7 +472,9 @@ void crypto_unregister_alg(struct crypto
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
+	if (WARN_ON(refcount_read(&alg->cra_refcnt) != 1))
+		return;
+
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);
 


