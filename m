Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496CD221DA8;
	Mon, 23 Jun 2025 21:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714409; cv=none; b=JcNGXvpve2wb3Ngou+9CEz8+C7B92+iY3h32LG0pLc7Vn1ixn5oDRXMMprnpUoemMRUtLFdtg3AtrPP7yPEvPN+hkO26ft34VLAAIHhmRfn5b47JLP8Z7xwhrqTAhRWbRNVMlW9/HpM4eFjHEZ0/rNxJ5CwtRIE8oaAj8Y3pWnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714409; c=relaxed/simple;
	bh=fN5WhomNSM5cVeVT5hHvLJ4aEbsvkoBOazHyB3eU2fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOWFnEEryc2v2Qm6+Sh4h1/Birll8Z8QKKcWoarCqTUXLikN9WN/N7pAoZTlpm/bPtaqGKYBqRIGhnB+EVLW3OqRlaBlive3TaVvc9z/5C9ZJuH1OEpmR7Akcrk46E9SNYSGyAMlrq/CXMW1e8mxBuZq+YP+ZPUHl0VL/JVnpUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcXJcf7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcXJcf7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C7EC4CEEA;
	Mon, 23 Jun 2025 21:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714409;
	bh=fN5WhomNSM5cVeVT5hHvLJ4aEbsvkoBOazHyB3eU2fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcXJcf7WOLR0i+6M3OQgrC5606ja5rGPdIbWkXh3huR+6/4CO0baNCM0fkkiPYhdS
	 glil8EHLCBC3Iejsdj4KaVLCuHql27jNt01nG8AAE8iu0kViSYSvFLacSTc9AIWMyX
	 554j59Elz4uHbu2juHZsOt6tpX694nrAPrXsHlcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 186/411] calipso: unlock rcu before returning -EAFNOSUPPORT
Date: Mon, 23 Jun 2025 15:05:30 +0200
Message-ID: <20250623130638.363960975@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


