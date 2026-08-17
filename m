Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6F343DA4E;
	Mon, 17 Aug 2026 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978784; cv=none; b=bdwG2I8jTkqFKbA7w4JS1efqhIZG1+eENJxPsiRd1t/oEXveffDyho8I6cjlC8VrM1fjjhwYInCRtKW6OKiiGUlwh7iAzwTJUoEboUaGZOdJpe7R5eVs1K+Tq9Y2B0kQXO5rdbYRLtsJGG41WjP104hfu5xioYQ5nknpsqRIxko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978784; c=relaxed/simple;
	bh=eg9pSVC7E95cBqlZN4anwjtdJcIbjh6UsvkPw9Kg3lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfxqivVhUbsdH9Tj5b7XH1JsEd1ysOPpeIphweXOkzuUPIe7ruXfx/g3Z3jMjihLASIoH0OlNXHKHKogkXjbFhNg1iGSEH+C0U7KqvsK6Zr53GPSxc1VNf6RdKPh4kHGyh1UYDL1F3TZQgZ8fY9GvL2tOxmCvYQT44fqGfbTvEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHlOAmtV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHlOAmtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF92E1F000E9;
	Mon, 17 Aug 2026 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978783;
	bh=YESNHYVQlWzum0Jj9sQQEImPd1Zaw2mRi1TWuKLdMSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHlOAmtVzuiGlupHiqYNxdXu7jX6jnOJa6Tp32aJB+0jNJ3gIgmjtvJv3Gv9AXhlW
	 8PnL/AIjZ3lCYB/yKcKJRTtUAYc4PGp4hiX9DrTNAWQteSpfi/HsWf7ByR3b9cGhpu
	 wIu5+HNF9HAJOFpIo69g+PveoWZprxJHtD0HR+Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Dmitry Safonov <dima@arista.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	syzbot <syzkaller@googlegroups.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 155/156] net/tcp_sigpool: Use kref_get_unless_zero()
Date: Mon, 17 Aug 2026 15:34:49 +0200
Message-ID: <20260817132540.831006492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <dima@arista.com>

commit b901a4e276943f61e11ddb597a0abc1e7dfadf0f upstream.

The freeing and re-allocation of algorithm are protected by cpool_mutex,
so it doesn't fix an actual use-after-free, but avoids a deserved
refcount_warn_saturate() warning.

A trivial fix for the racy behavior.

Fixes: 8c73b26315aa ("net/tcp: Prepare tcp_md5sig_pool for TCP-AO")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_sigpool.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_sigpool.c
+++ b/net/ipv4/tcp_sigpool.c
@@ -162,9 +162,8 @@ int tcp_sigpool_alloc_ahash(const char *
 		if (strcmp(cpool[i].alg, alg))
 			continue;
 
-		if (kref_read(&cpool[i].kref) > 0)
-			kref_get(&cpool[i].kref);
-		else
+		/* pairs with tcp_sigpool_release() */
+		if (!kref_get_unless_zero(&cpool[i].kref))
 			kref_init(&cpool[i].kref);
 		ret = i;
 		goto out;


