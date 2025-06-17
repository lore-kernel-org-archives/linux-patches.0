Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17F12FA644;
	Tue, 17 Jun 2025 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178488; cv=none; b=MgeFEpnKd4RmfoszgteZI8pSJrNB41iTzNhA/4vH7aQxcO/aUv6XXmhwnOBJ/zNoghBsyFmHW2AUcfhFxQk9luxcglcm5NnhvVAPJTbKWqr0rRcdVjuXzYv/vN7SNGN+Wba/FJN5vgxRHIPuZ80nRWyk2nBT/VwW7ohs6ao7o6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178488; c=relaxed/simple;
	bh=CImLcTAq6QUwCAvoTVu9PkIKBrvybzHnpzwFneSp2Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaTroxbFH9tWjh4DFX6n0Kbfe/ZlUFOAI0w4rdhs84iJhSVBeUEgcjSIyOwFyyDWGyj1osp0gI4QlFJMNQnSZOu6hZRNfFnZxm4NRvHg1zcwsdWkzgo5oNpHfAJGvIei7iUVBVlkv0EYPybyYZmKF5IrWko1yczH2pPOy3QgflM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsA7RMjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsA7RMjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DA2C4CEE3;
	Tue, 17 Jun 2025 16:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178488;
	bh=CImLcTAq6QUwCAvoTVu9PkIKBrvybzHnpzwFneSp2Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsA7RMjFwuSagkSKB+E6e3Zs0P60g1+pVKNhkSsbKCohJVPW7cVAjwqw7qV61gWXF
	 q9XpePh3jYbpVPh0uvCAIt2zsuEzOUFEiIrYc9sPizLrA5m+OaVzwmqj11PoBuU32T
	 KlyZKCgvaBBwimJ2WIIucHkFvfnm2PUckxIM4HzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 506/512] calipso: unlock rcu before returning -EAFNOSUPPORT
Date: Tue, 17 Jun 2025 17:27:52 +0200
Message-ID: <20250617152440.119832516@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1165,8 +1165,10 @@ int netlbl_conn_setattr(struct sock *sk,
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


