Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8E7FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3067C433EF;
	Mon, 15 May 2023 17:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171975;
	bh=SKrgA1z4HvkUaeFXuMXmhV+lwuEqXF9XleiPLZJOkWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqhzbiMjCEgSH6gQGl0iVjdNY9VIfh4dN2pHAiqKvdhcglBbcTtb0mSYvg8hBvH3l
	 MZi6vNuXFmwDllWdI5rHvU+RasiBQ1Khkb3W0XK/j6UGPGFhPcgCAJigm/qi8Wqqy9
	 m9SV0goBgElNgxXmtqqnhGtzhij6m1j7Rad2rZIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 116/134] ksmbd: fix deadlock in ksmbd_find_crypto_ctx()
Date: Mon, 15 May 2023 18:29:53 +0200
Message-Id: <20230515161706.995449072@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 7b4323373d844954bb76e0e9f39c4e5fc785fa7b ]

Deadlock is triggered by sending multiple concurrent session setup
requests. It should be reused after releasing when getting ctx for crypto.
Multiple consecutive ctx uses cause deadlock while waiting for releasing
due to the limited number of ctx.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20591
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/auth.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index c1408e922fc6b..59d2059467465 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -220,22 +220,22 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 {
 	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
 	char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
-	struct ksmbd_crypto_ctx *ctx;
+	struct ksmbd_crypto_ctx *ctx = NULL;
 	char *construct = NULL;
 	int rc, len;
 
-	ctx = ksmbd_crypto_ctx_find_hmacmd5();
-	if (!ctx) {
-		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
-		return -ENOMEM;
-	}
-
 	rc = calc_ntlmv2_hash(conn, sess, ntlmv2_hash, domain_name);
 	if (rc) {
 		ksmbd_debug(AUTH, "could not get v2 hash rc %d\n", rc);
 		goto out;
 	}
 
+	ctx = ksmbd_crypto_ctx_find_hmacmd5();
+	if (!ctx) {
+		ksmbd_debug(AUTH, "could not crypto alloc hmacmd5\n");
+		return -ENOMEM;
+	}
+
 	rc = crypto_shash_setkey(CRYPTO_HMACMD5_TFM(ctx),
 				 ntlmv2_hash,
 				 CIFS_HMAC_MD5_HASH_SIZE);
@@ -271,6 +271,8 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		ksmbd_debug(AUTH, "Could not generate md5 hash\n");
 		goto out;
 	}
+	ksmbd_release_crypto_ctx(ctx);
+	ctx = NULL;
 
 	rc = ksmbd_gen_sess_key(sess, ntlmv2_hash, ntlmv2_rsp);
 	if (rc) {
@@ -281,7 +283,8 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	if (memcmp(ntlmv2->ntlmv2_hash, ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE) != 0)
 		rc = -EINVAL;
 out:
-	ksmbd_release_crypto_ctx(ctx);
+	if (ctx)
+		ksmbd_release_crypto_ctx(ctx);
 	kfree(construct);
 	return rc;
 }
-- 
2.39.2



