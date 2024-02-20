Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F8414AD15;
	Tue, 20 Feb 2024 21:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463698; cv=none; b=NMgELB+NUBPTNpmRv4ZVRSTW7BfTMYB7IalD8ZCkSa8/iv0x0uDYqSzPeFbYhaJg3o9aYghpUa/472JoceNUAJ82YPRHWmLXyqEewX/TuTkJhrPgZ1fw3nFGbBPL8jP8qWxRRNSbJd/idOWU8RJBHHpEhiIl4aUpmkIGQtvZpJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463698; c=relaxed/simple;
	bh=vHxFMDc6IVQ1ZIPZB5ei0MPEQstQjILcuShouq2Lc1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTktCpCMVoOW2Usz0uR65IZwWroPQTAiCF0eVwjmJN93970btqaFs88m4Sm8TcBHZDJVas2nqOjr4ZXvEGOVHWyUJDRNCO/ucPBJ9rqQida6JjDa3fbj3EDS6zbYO4lDdc5pNyBQP3X1vlkEnB7ujwVHeWsnB2AsEvfU6qkCArQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n02JWrKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n02JWrKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBB1C433C7;
	Tue, 20 Feb 2024 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463698;
	bh=vHxFMDc6IVQ1ZIPZB5ei0MPEQstQjILcuShouq2Lc1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n02JWrKjQ8LIqS6cM7xdjIXbZ3HYIswFOqeKbOWuETbVwfBA5/1CrEQ1OEALq1EE5
	 mXlZglblFErL0JN9/z6KLxKw0XRMORKD9iPkNLtm7BWTd1vTyFN9Vo3a71vpyPNM+l
	 eqNIBWXgjavUYPrDqMAmBgm4re7JhvXd1DGDIX9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 125/331] lsm: fix default return value of the socket_getpeersec_*() hooks
Date: Tue, 20 Feb 2024 21:54:01 +0100
Message-ID: <20240220205641.522237528@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 5a287d3d2b9de2b3e747132c615599907ba5c3c1 upstream.

For these hooks the true "neutral" value is -EOPNOTSUPP, which is
currently what is returned when no LSM provides this hook and what LSMs
return when there is no security context set on the socket. Correct the
value in <linux/lsm_hooks.h> and adjust the dispatch functions in
security/security.c to avoid issues when the BPF LSM is enabled.

Cc: stable@vger.kernel.org
Fixes: 98e828a0650f ("security: Refactor declaration of LSM hooks")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
[PM: subject line tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/lsm_hook_defs.h |    4 ++--
 security/security.c           |   31 +++++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 6 deletions(-)

--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -311,9 +311,9 @@ LSM_HOOK(int, 0, socket_getsockopt, stru
 LSM_HOOK(int, 0, socket_setsockopt, struct socket *sock, int level, int optname)
 LSM_HOOK(int, 0, socket_shutdown, struct socket *sock, int how)
 LSM_HOOK(int, 0, socket_sock_rcv_skb, struct sock *sk, struct sk_buff *skb)
-LSM_HOOK(int, 0, socket_getpeersec_stream, struct socket *sock,
+LSM_HOOK(int, -ENOPROTOOPT, socket_getpeersec_stream, struct socket *sock,
 	 sockptr_t optval, sockptr_t optlen, unsigned int len)
-LSM_HOOK(int, 0, socket_getpeersec_dgram, struct socket *sock,
+LSM_HOOK(int, -ENOPROTOOPT, socket_getpeersec_dgram, struct socket *sock,
 	 struct sk_buff *skb, u32 *secid)
 LSM_HOOK(int, 0, sk_alloc_security, struct sock *sk, int family, gfp_t priority)
 LSM_HOOK(void, LSM_RET_VOID, sk_free_security, struct sock *sk)
--- a/security/security.c
+++ b/security/security.c
@@ -4387,8 +4387,20 @@ EXPORT_SYMBOL(security_sock_rcv_skb);
 int security_socket_getpeersec_stream(struct socket *sock, sockptr_t optval,
 				      sockptr_t optlen, unsigned int len)
 {
-	return call_int_hook(socket_getpeersec_stream, -ENOPROTOOPT, sock,
-			     optval, optlen, len);
+	struct security_hook_list *hp;
+	int rc;
+
+	/*
+	 * Only one module will provide a security context.
+	 */
+	hlist_for_each_entry(hp, &security_hook_heads.socket_getpeersec_stream,
+			     list) {
+		rc = hp->hook.socket_getpeersec_stream(sock, optval, optlen,
+						       len);
+		if (rc != LSM_RET_DEFAULT(socket_getpeersec_stream))
+			return rc;
+	}
+	return LSM_RET_DEFAULT(socket_getpeersec_stream);
 }
 
 /**
@@ -4408,8 +4420,19 @@ int security_socket_getpeersec_stream(st
 int security_socket_getpeersec_dgram(struct socket *sock,
 				     struct sk_buff *skb, u32 *secid)
 {
-	return call_int_hook(socket_getpeersec_dgram, -ENOPROTOOPT, sock,
-			     skb, secid);
+	struct security_hook_list *hp;
+	int rc;
+
+	/*
+	 * Only one module will provide a security context.
+	 */
+	hlist_for_each_entry(hp, &security_hook_heads.socket_getpeersec_dgram,
+			     list) {
+		rc = hp->hook.socket_getpeersec_dgram(sock, skb, secid);
+		if (rc != LSM_RET_DEFAULT(socket_getpeersec_dgram))
+			return rc;
+	}
+	return LSM_RET_DEFAULT(socket_getpeersec_dgram);
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 


