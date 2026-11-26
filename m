Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705347;
	b=gUk6fHCOrXzHurH6UinmmKJ71We9eC8D90s4XvdQfMRaV+qQHuXDussFognuQmv66e3u
	 ZfR49wf1fxDTlSHQ2Q0vo7+sU9V3RwbVIx+3MYtBxpNWzzmhhczSJS7Ow931KtKM/o8m5
	 S0Nym5h5nKkSmLFh2ky4/pzLAkkSn/eX7WDSFbl5lwoRrOiOOWsqnZJ64g5YYA9x6r1ey
	 pS1IPWuE3Jk3gv61n44irVZ9EpSI+Yo+Csofr5WZz5r9OZbSCtxbUbwBTCHSdQxKRnEy3
	 eY0aUDbaxx49Bdk2Wln60q5feplQkKUQElQW6r2RiS1yKzUqmNF7zS/Pz5yF1QS/VWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qtSyAjPcxmFq82mqEAh+1brAaWi3SynaLt82D6zvE1s=;
	b=Ll17DI1i6ETwKjYuWKcS5ZS2NUXqbaMCkGH2ye6WiVkAz2KEWCJADV/Tm6GlrlOSzKFT
	 aFTycQsmth/HqbZ9jrQLQ4M7k1csUXX+FvCVcm4QYuMwLfrbuA6YCHROj4NWxpbK0mA3G
	 GKnJpFy9rYFjI7Yu27o7M8U9CTqTuMHvT1i9hzXd73E1ZqVnsnldHNrWFD05jSf3A4vc7
	 57C2RN37ds0wjmXTbYYa9ft2igdqGbZI4XslWqp7El/2IzggNNnKiXiE0t5CsO21Jm0fR
	 QDf5VwK8wB8bJJqRTG06WZ4+REQvjGhP7lCxnJO7wNRY0InU6SqsutmdEfHjSnVqX1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3WmEkwY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC58606A326;
	Thu, 26 Nov 2026 15:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3WmEkwY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015C51F000CA;
	Thu, 26 Nov 2026 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705346;
	bh=qtSyAjPcxmFq82mqEAh+1brAaWi3SynaLt82D6zvE1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3WmEkwYxTK9AeRnVpmCaP2oJ3exl++rFN5L4MfsY6SNV6khi3pJ4CDSuoMXGiVM5
	 U9YvEjVivxuoRT9jmGPXQFSBD5FEtejPLnlQThK/890CJBegdzd4Fy2p52zk8kLJvq
	 BQOnAHkpdfuS/BOcocPXc59+hRstOuzfU1WOr8as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/319] KEYS: do not let an unmatched key decide the search result
Date: Thu, 26 Nov 2026 15:38:53 +0100
Message-ID: <20261126144010.471242286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 83fa6f0a54d4a..118b993783157 100644
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



