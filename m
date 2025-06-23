Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B951AD3FA;
	Mon, 23 Jun 2025 21:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715829; cv=none; b=QD4YGKaycGX/4zn6MkSIN20qysQ4PX3Xfery1lzPw12I3jghKOiAjz3fs78aHNQXR/1rHoCWx/PdDOaNksvyClES4N1jdAoXUeSCnLmBJ7R6SNU9j7C0RbE5bNSY4wtc/oNHO9aYSQ2HSACpOtBwrqaThyU+G09o8jnWV4EnMv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715829; c=relaxed/simple;
	bh=HS7TSJbP6bNxLQTFw6qaXx2mIC0NOQ74Z4uC3ki1MHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkkBmEnIzQfq0czh7MBxX1COwubXoQYfIhD7KE7qQRATc6BHTKD9n1sAb4ppXh9UJDdSrBcqDEhdFyJyHlEgIY6qWiQfwOJ0hyq7tsfNcSbkAOm7Gah55essCVxG3AkxEyTJAnSaedXC2ZyyTURTy0Qo1Q6O4opREawwgoCnRE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SltVMFSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SltVMFSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C9EC4CEEA;
	Mon, 23 Jun 2025 21:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715829;
	bh=HS7TSJbP6bNxLQTFw6qaXx2mIC0NOQ74Z4uC3ki1MHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SltVMFSGJnOn0T1tZnJch2V+TvlQCJQYtRoV7CZQ6N8eAlgC9VsviRPVd8XHLaLA/
	 sESv1RE+1DlDOcLgCpQnENeFgZ8Njl85qxdtzjhEDhvUy+VyCMxScsk/EOE7rN7hFr
	 J+enj6k/H+C+gAH8yL6u10xao+Vtwl9UzcdUboMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 284/508] calipso: unlock rcu before returning -EAFNOSUPPORT
Date: Mon, 23 Jun 2025 15:05:29 +0200
Message-ID: <20250623130652.251122834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


