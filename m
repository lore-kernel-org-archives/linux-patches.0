Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624965;
	b=IUtJph0E9A/RQWKGtyT30goj+uf/SjWBgHjprg6BB0Y7oEkkl8feVi4pavXgQc0aujh1
	 SI+PA2wjepLcczK+6Tyl42F76Mf/5yc2QaHzIkYS0dGSARioSqavp9yEQO3dG0fL5sKR1
	 M8mKWMjU32JzGg3wsAN3YMHCIc8rd8uno0obELLsROoi3sxVhdamxNVJ3v8v14bQMlfuG
	 8mfYpzX5YFbG4g9iINWB3Mdap9qA4lRtXuAjlhtqy0pWtHLjCejZqdgTuAji2dHhsEZwF
	 8I/0M7Shk+FqkXFiSDW8GtNr9eMr0pfoPAVMKxuDrS2eq8wyX1etJXm7DZo8slxDKuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/zQPCH3HW2cSZVupvbrrHaXP1OuBemGK9SVcpoPXIzI=;
	b=jH6jzQHA1xc1y5y8qoA/ecWe3HsrH/luxJaU/X1jqpyeyFsFMJEb3qrAQ5DZmBeiXF70
	 MxxlkXE9uOUtaNJHw1tVMZx6aVsCVgn7k77Pa7qOW9vjLHzJ5tprl+jztL6YBRxE98USY
	 oJx0UpjOBo3qnFNPxTHvgO/Jn+Mf8WREFDC8TZhvaLceYwVlcBbsd0Kt9U4KzQKGSTn9g
	 PWoNjkfAruFULeq/s5lKvmm3XGoZydrybGw7J8uehHNa1w4EbCzIIR6wjp+STJ5i7ojfN
	 s8Ax5gzZT4DTMFBMEAs+BddDlQrUYoxRDqQK3qBT/NwDcpOV4FFyJfb5PzzWHxjvT6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhX71W72;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC08606A327;
	Wed, 25 Nov 2026 16:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhX71W72
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24E51F000E6;
	Wed, 25 Nov 2026 16:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624965;
	bh=/zQPCH3HW2cSZVupvbrrHaXP1OuBemGK9SVcpoPXIzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhX71W72Smcfwah7RC5h3KzpinMjp7IK9QFuKPY2g1e6mB2a2grRX0IeqkAUAsIhr
	 hq2xNxQDS33NtjRJxuLBdfmS/0lC6j2gPAJLq896AvYvC1PV1J6T3Zia7tNVkOtYzA
	 0sGE+2fvVD9+vG+cXSIsoAJAU8EpSkp7i2ElLLhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/816] KEYS: do not let an unmatched key decide the search result
Date: Wed, 25 Nov 2026 15:31:48 +0100
Message-ID: <20261125143857.532005031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixiong Wei <weiguixiong@bytedance.com>

[ Upstream commit 143fe160178c73e43575bff4890d23f84e37146d ]

With the dns_resolver key type available, put a key named "foo" in a
fresh session keyring, revoke it, and search for "bar":

  keyctl new_session >/dev/null
  A=$(printf '127.0.0.1\0' | keyctl padd dns_resolver foo @s)
  keyctl revoke "$A"
  keyctl search @s dns_resolver bar

Results:

  keyctl_search: Key has been revoked

The search returns -EKEYREVOKED even though there is no key named "bar".
It should return -ENOKEY.

A dns_resolver search walks the keys in the keyring and uses
dns_resolver_cmp() to compare their descriptions with the requested
name. When keyring_search_iterator() sees the revoked "foo" key, it
records -EKEYREVOKED in ctx->result and skips the key before comparing
its description. The search continues, but without a match it returns
the error recorded for "foo".

Call the match callback before checking for invalidated, revoked or
expired keys. A nonmatching key then leaves ctx->result alone.

Fixes: b2a4df200d57 ("KEYS: Expand the capacity of a keyring")
Reported-by: Jarkko Sakkinen <jarkko@kernel.org>
Closes: https://lore.kernel.org/lkml/avDG8G-Jl1YsmfCs@kernel.org/
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20261109032931.80406-2-weiguixiong@bytedance.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/keyring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 74ed1372d22cf..c339b4073ea02 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -598,6 +598,12 @@ static int keyring_search_iterator(const void *object, void *iterator_data)
 		return 0;
 	}
 
+	/* A key the caller did not ask for must not decide the result. */
+	if (!ctx->match_data.cmp(key, &ctx->match_data)) {
+		kleave(" = 0 [!match]");
+		return 0;
+	}
+
 	/* skip invalidated, revoked and expired keys */
 	if (ctx->flags & KEYRING_SEARCH_DO_STATE_CHECK) {
 		time64_t expiry = READ_ONCE(key->expiry);
@@ -617,12 +623,6 @@ static int keyring_search_iterator(const void *object, void *iterator_data)
 		}
 	}
 
-	/* keys that don't match */
-	if (!ctx->match_data.cmp(key, &ctx->match_data)) {
-		kleave(" = 0 [!match]");
-		return 0;
-	}
-
 	/* key must have search permissions */
 	if (!(ctx->flags & KEYRING_SEARCH_NO_CHECK_PERM) &&
 	    key_task_permission(make_key_ref(key, ctx->possessed),
-- 
2.53.0



