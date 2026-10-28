Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209588;
	b=l7tSGA+peNItH2im8FrGEYil3TpgR++15kz65uyo51pkW/3jcXON4pqPMG6B5Mg8r7eh
	 Sww2ZewEKLyv76umFC/FNZXTXWnNKn7H7zh25b61zNQBD8jxM8zSrVvJVM6yaZqX8en52
	 rodyh7IKjSVLYaLbTl/ioyHkbO94TouHTOiaJE6uATp08dNlQwRQXiSYEYeoL3HUSCS61
	 qmXHdvRp5YUeLJf4QazKEvI/lKUOXYH/0oEdNlbRe07Yy6+wHK58PaCz0czUWGSA3Vuf9
	 8sQnUBDc4CNiK64R6ScyMfsaaGxC78OTwjnbSfkGfbqKeImQWHumyadPjsFwn9ZwrXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lYUsWkYGlyw/WtHnZ6rmm6of0ywwJrSzgs+qRvwSPno=;
	b=JkJDzM2XOTsxVlW/fL84hLJuSHr6WQXbKErQhNtl3zocSAZbGlBpTp6DkAjNi/1k0wSz
	 PL+B3O2/QkjxyCX7O3SqnIYlNGiQMEetEUQ/3w9KhEpHL/v+H0tHeBK+Y5PtMXCTyWY7D
	 beYi/rFNPe/oexlD5L9BZuAI2hrj00jLVYFgc+vmhJx6L+CQltfH/YeFboAg/2NXG+5cJ
	 YPWDsBZEGy9wivpnsLZle+GClShDR7tWtid0FsVSjh1jJYrbijEcYc5x3IF9vWtpnlnyl
	 JjugRLoeuzdQXyGlpcd2k6g5kE219/b/189jXEbcgQUqJNAns70ahZzYJvTedPmvADQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojG5dpyr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B791606A31A;
	Wed, 28 Oct 2026 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojG5dpyr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6241F01825;
	Wed, 28 Oct 2026 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209588;
	bh=lYUsWkYGlyw/WtHnZ6rmm6of0ywwJrSzgs+qRvwSPno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojG5dpyrKxGFmGd5UHrMMCuG+R6lwWCm1YS2sviCqVCpMpg+1Kq4a7svl0McCfPDH
	 3Gy8etaAUp7ub6OeHQ10giI/Fq6ffOhUWchB6xctrMQFVECg+XI43P6qEqIGGyimpK
	 WwzkmRrkPidlxN3fpTRIHO5UqCn+OrR/ZxycLiv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 511/516] keys: Check the authorization payload in process keyring searches
Date: Wed, 28 Oct 2026 18:01:03 +0100
Message-ID: <20261028170015.581904921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

commit 0a0ec45bf577a9b4d4960567f20d3877ef480de9 upstream.

An authorization payload and its saved credentials must remain valid
while search_process_keyrings_rcu() searches the requestor's keyrings.
The function validates the authorization key, then separately loads
payload.data[0] and unconditionally reads rka->cred. Validation does
not prevent request_key_auth_revoke() from clearing the payload.

A request-key helper can assume authority and fork a descendant that
inherits the authorization key. If the descendant misses in its own
keyrings, it falls back to the saved requestor credentials. Successful
target instantiation invalidates the authorization key without clearing
the payload. After the helper exits, UMH_WAIT_PROC returns to the
requester, which calls complete_request_key() and revokes that key.

With the descendant paused after validation, the paths can interleave
as follows:

  1. The descendant enters search_process_keyrings_rcu() under RCU and
     key_validate() succeeds.
  2. The helper instantiates the target, invalidates the authorization
     key, and exits.
  3. The requester resumes from UMH_WAIT_PROC, calls
     complete_request_key(), and revokes the authorization key.
     request_key_auth_revoke() sets its payload pointer to NULL.
  4. The descendant loads NULL and dereferences rka->cred.

This NULL dereference can oops the kernel. RCU delays payload disposal
but does not prevent the pointer from being cleared.

Load the payload with dereference_key_rcu() and require a non-NULL
result before validating the authorization key and searching its saved
credentials. A non-NULL payload and its credentials remain alive for
the caller's RCU read-side section; a cleared payload skips the fallback
search and follows the existing error selection.

KASAN report as below:

    Oops: general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] SMP KASAN NOPTI
    KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
    RIP: 0010:search_process_keyrings_rcu+0x32b/0x790

Cc: stable@vger.kernel.org
Fixes: e59428f721ee ("keys: Move the RCU locks outwards from the keyring search functions")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/pm-key-management-objects-candidate-0004-v3-598361863b76bc25d58d@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/process_keys.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -556,9 +556,8 @@ key_ref_t search_process_keyrings_rcu(st
 	    ) {
 		const struct cred *cred = ctx->cred;
 
-		if (key_validate(cred->request_key_auth) == 0) {
-			rka = ctx->cred->request_key_auth->payload.data[0];
-
+		rka = dereference_key_rcu(cred->request_key_auth);
+		if (rka && key_validate(cred->request_key_auth) == 0) {
 			//// was search_process_keyrings() [ie. recursive]
 			ctx->cred = rka->cred;
 			key_ref = search_cred_keyrings_rcu(ctx);


