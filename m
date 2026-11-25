Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622262;
	b=CM9QM58uiQH6KDjGMMHEyKT/JEgnHuQSozgDyeNTABq5nEI7fUo2m0kDY37i7UY3h735
	 r95dZp7UEALQpYjoB4BADqDMSn6x5Fa6afIR4h20P/iZEdMH8gmibVADjFX+DR14hN762
	 5FFK5J9m2fy5QLP51gqO67bS5yKXhHYPWqAjcMtBEwLWKQuqqEzBb3J30xa8cuGmTJCwZ
	 /W9fqe3QUUl7x6fqRmyldPHrBoi1r2Dqg4hIyakDrrrsuXpNPO6w62hrVIzvgO4fFYj0f
	 tLkZFbDTIvCFsEIFPJgAImpVB6KEJgWSl7JGBaig1eTeSsoDlwMYBj+LcVzzQeLC6tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qIHXDg6ikT+vnkB5aes7DZbwC6jWDr0O5moeNXvab38=;
	b=V9sNOIZC5rwNjdGmzR5zgXzdFWjlDWmUbffqP6tOeRX8UaB7+8NuLL2u/wLC600AxsN1
	 yX8knAst75O6WmrEprd13C5aqL8TdEd7+XQf13WWhxyD826O13xS5dj+PF+yybIHJVmNv
	 Nom0gHrLfDdRSH+0QZ72FSflQKt1fn3twlpc1/A+qmZTlciM48OjUSioR/hF2jCKMxVXu
	 bxBhkqiBxm+9evzIhTAgOWQ1hZvStqlTngJHxH9/s8iivTUhn+wdtnwOp7ezvd3UNd6IA
	 UNNYQolDgt16LC0J7DGSaanScdz1QlvyHx325e6rWZPknUYimykHjCevGHlRURMOJhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1dawImP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCDE606A31E;
	Wed, 25 Nov 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1dawImP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3691F000C0;
	Wed, 25 Nov 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622262;
	bh=qIHXDg6ikT+vnkB5aes7DZbwC6jWDr0O5moeNXvab38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1dawImPSSPO6/2QY5xVc1HWB7pyStKT6cUhiW6RycRXAfksPZoYBmgOygZSnpbaa
	 RohpRePTVMdWi8n+4Ev+WoTaeuEia06XSUKlc81hrchmF6i9yCgiPD6LW0d5XDjgLP
	 kW3HNg6WNhoZPt5VptNnpvZUeGlw8N7FUxAXzaz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 480/990] KEYS: do not let an unmatched key decide the search result
Date: Wed, 25 Nov 2026 15:30:47 +0100
Message-ID: <20261125143833.339449375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



