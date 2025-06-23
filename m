Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884E2255F3C;
	Mon, 23 Jun 2025 13:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685516; cv=none; b=Aq3Ppgvbfw2h+O6aO9Mx2cPUVn3ECG/r05vl3rjqbS3yFlvk2Uc8ig/I00EnDO/Gshfy41l7mpwCYnstwlQwlevTqrT+5rb0rGA71qXc9ixCJrcf4MtUUluJ3ulnsAAivQBuJgXrk+zgNEcQ+sKfoUtZa2q1Ep1WZ1WlZ5GzpYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685516; c=relaxed/simple;
	bh=kDxbiKQfVDjwxJzN2yJ0dyk7lT/7rV4rZWVnO2qQ1zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiMNEN5Br+2UVPD0TJO1S4Cso0VmFsiSrF+YOMY8yaYn5A4WiTUoGfF4aI+lGkwbU/Mc4zmzYPyPynDkghGqmTbHgxthmH8PEGYKrUaVZy8VLXVwBJWi8u4olXs6QmcRaXzVXoxonbl8hoxMMrccvzlibjtYsdtpSKQTdHIhYBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mo+wYi0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mo+wYi0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB2AC4CEF0;
	Mon, 23 Jun 2025 13:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685516;
	bh=kDxbiKQfVDjwxJzN2yJ0dyk7lT/7rV4rZWVnO2qQ1zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mo+wYi0Rm1JiVMfeU1iM8NT4XWQuopAsDbeh71uXwKzJ2DVBjbehqw8q9TW/yi14W
	 hEXiNIF4Oi7b/oYlEY1lh8eIKkVdcZdSPTdwYpl3R1hwNct1HJ1Lc3CZxC00IIA2mA
	 KOYlPZk0eIxtR5u0A6FmwFgtzmYOmfiRMMU+WxYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 100/222] calipso: unlock rcu before returning -EAFNOSUPPORT
Date: Mon, 23 Jun 2025 15:07:15 +0200
Message-ID: <20250623130615.125592282@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


