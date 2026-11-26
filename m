Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704478;
	b=KUgiarDQc06Z1tybaWgV2/ezIROJ5MnzXFXLp2iGdrup+rmbeF95j3G7+qUP7U41nzXa
	 9TF9RTBjTAvADDnPloguPKbcTtxr/pHOFWL1xQJ6+JNIlwFtPxsBloCiAfwptMufNsTgn
	 Tkqmzwk5m7vEogKy//CXVc6J1mFIskGfZptl7nJsV2zhsalEcfaSnd+OeM0hlbF+wrWj0
	 AS4hx2OUd8YkzpiyhJbr0h+Fe3xP9RwH05cbkCWTcuOXCeDWj+RlUjqK9maau4lZWhcpo
	 8TQmlQUwVIVc7RLfsX+0XV4AKozyMhVuwp3hfd1gniqn0JY30O7exzUYFZKkbDBTthw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EiJ288QovdnJvntVljHpnw8GiLSPIhvFIERJ3e2Gd4c=;
	b=ZGgji85xBxc4EFqyFTgMLpv+GUf+Cr6g+XAaHP2LQcMaW1m+MXgLL5NtKpFSR4UsthwA
	 AsK2z0sUbJmIN3txfpuPHD1pmIqLbK/FV8A2PbQ/qE5AiTnydD12iR5uK7PX8QsB5xeB+
	 cHU1FNdwrgFT7/Xmx8ehrl99Me8i/b/pfZXxdPLt5ogpD/+ItYHhQOn21NwSccgylJaOB
	 pmT2hFqlQkFclY03tZqus1tH/c7De/hzPlDV+uHBS4xtumHHxXaGiYtE9idT1tSFTA/RF
	 MO9fe09Of+hqKubNCq2jvBMMobl0suFlh8vtaJOLEn7nJ/NU/D3jm4MXuAa8DYb3oQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXJC17b2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2D8606A326;
	Thu, 26 Nov 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXJC17b2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646881F000EC;
	Thu, 26 Nov 2026 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704477;
	bh=EiJ288QovdnJvntVljHpnw8GiLSPIhvFIERJ3e2Gd4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXJC17b2ct+aH8XzOe1hxDu1jLWH/gkeZ0uCFsTgU3ozuWKUYEl8eddLussOCyCFH
	 xn+ovyR2qj6uboupR5AOcSlHSOoe0nXP2kZcLkHCRc0LcwSSf2T1aUdarqEd/DAx44
	 PPoLPTnBeT52RwugLaK8LAkRpnorLfPVS/fCc8ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/265] KEYS: do not let an unmatched key decide the search result
Date: Thu, 26 Nov 2026 15:37:47 +0100
Message-ID: <20261126143614.612691008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index fc6b9894c32d6..655cd752060ba 100644
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



