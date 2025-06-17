Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB572F235C;
	Tue, 17 Jun 2025 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177160; cv=none; b=FhifsYrypCEZu2+9F6nNIgx1aSMzCM2iPG5CZNOEp+Lgxj/MHhmh+dUa4Ww4SMWKdizQDyQZAX2BgxOryJ6b4OwMlj+CtBDKFvpobH+nZt6b19LCR4KCwuYzx4xUvggqas5Gxciv31ivfwyReFX5dKl1thRxUk7hPR7oNkUYGTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177160; c=relaxed/simple;
	bh=yESWEhmf0Uawvd972r8fKzTDw8EgnsN9LZaEFGQXo/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZPMC5kkC0ijLOlx/UQym4HVAOvCAU9wSOiAseyIHdRJu0Cqvk0qTL27EFwz8E2KwOduzmWRVLy5eftxMPt1vJRe95CztqmAsT4jmzPtDoaH1dWGNaHjgJJEppzIq7EiySY8M8jxRjBoW67pgSnNAkJYc5D3A4Hwl17Z5zDOvPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h72R6FBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h72R6FBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33638C4CEE3;
	Tue, 17 Jun 2025 16:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177158;
	bh=yESWEhmf0Uawvd972r8fKzTDw8EgnsN9LZaEFGQXo/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h72R6FBH+4MvMjqx/tfexAYyXU7YC+gF0DfsQJny/IwnzKw5PT1EqXEYbtoNzRRwJ
	 hvmv5thxOSr2iA/FaTxdXt4+zGQTZVf3uusTJfigR7RUu+GSB13IEN2Gng+M2OJMkz
	 ViYJfuQ8QqpAyaBmbblN3vrl6S158tgr2VNtFEFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 353/356] calipso: unlock rcu before returning -EAFNOSUPPORT
Date: Tue, 17 Jun 2025 17:27:48 +0200
Message-ID: <20250617152352.345822501@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

commit 3cae906e1a6184cdc9e4d260e4dbdf9a118d94ad upstream.

syzbot reported that a recent patch forgot to unlock rcu
in the error path.

Adopt the convention that netlbl_conn_setattr() is already using.

Fixes: 6e9f2df1c550 ("calipso: Don't call calipso functions for AF_INET sk.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20250604133826.1667664-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlabel/netlabel_kapi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -1140,8 +1140,10 @@ int netlbl_conn_setattr(struct sock *sk,
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		if (sk->sk_family != AF_INET6)
-			return -EAFNOSUPPORT;
+		if (sk->sk_family != AF_INET6) {
+			ret_val = -EAFNOSUPPORT;
+			goto conn_setattr_return;
+		}
 
 		addr6 = (struct sockaddr_in6 *)addr;
 		entry = netlbl_domhsh_getentry_af6(secattr->domain,


