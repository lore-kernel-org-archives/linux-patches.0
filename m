Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33053342173
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301194; cv=none; b=p7VgWnDufFFtarnsAs7xqNh0mTX0MhkUVuvNIGPn+JdtyFOj9leB8cqDbcjzc9L7s1UVckG9FZA/JjN4GR8vEEOIMHflFD0Q6RrJgg27KYv/ZF1OCtZU0CYfzhoAyO9bcqf9PEYs3j2BDyIUTfh8lcEv5N113a+8+pXKNCrywMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301194; c=relaxed/simple;
	bh=eWITnqWXfaZitEoPiMIQV7/NPA/XVTeyfYJ6Kov8XQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzzHadTQryIDAoLIW7WV9nePpSotbhR7AZKBrF5I5yLnM0PYQl9+P0LBn9t1Al9O20i0a2jO5jiNYJsWY80BLsyzbelB6ROSeFNUrWghySEb0liCXjtR4cK1e7KnC4ATlSowEZOBTR+2rQ3dsRedZ2tKflW2R04dFXqlJ4xXJaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LF6kwX0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LF6kwX0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF02AC19424;
	Sat, 28 Feb 2026 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301194;
	bh=eWITnqWXfaZitEoPiMIQV7/NPA/XVTeyfYJ6Kov8XQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LF6kwX0F8Wgsi+RFp7xTfpH6Cvyvvl101l9zzOOZnM6nKRiW6Hb5NOAvrz/vo1G9x
	 6YKLYy22ATZDKNl7LfxNoB3YQCc9ISxMe9K09jige1A29KvT6gZE8UMr3fu8IotzQk
	 WDFrZ7L5Hl7Dby3hfMvDMgo+SRsHq5wCS4hmrOMEdZH3RKS2996F0fmi2h3nkpRdxP
	 6zY5mDzUuodjBWB6aV7bMzZJeGzjRmDHV4nf0LmOrVsmdwfj5bsNskyQK53KB5z+A3
	 I4u257HufbDELpqvwccVQAoUjSVsiy7+ltG5PhCPxBAByQ+1V/d4U2TsieKihwAB+V
	 SwMXCjvn7a1dg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 365/752] libceph: define and enforce CEPH_MAX_KEY_LEN
Date: Sat, 28 Feb 2026 12:41:16 -0500
Message-ID: <20260228174750.1542406-365-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit ac431d597a9bdfc2ba6b314813f29a6ef2b4a3bf ]

When decoding the key, verify that the key material would fit into
a fixed-size buffer in process_auth_done() and generally has a sane
length.

The new CEPH_MAX_KEY_LEN check replaces the existing check for a key
with no key material which is a) not universal since CEPH_CRYPTO_NONE
has to be excluded and b) doesn't provide much value since a smaller
than needed key is just as invalid as no key -- this has to be handled
elsewhere anyway.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/crypto.c       | 8 +++++---
 net/ceph/crypto.h       | 2 +-
 net/ceph/messenger_v2.c | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 01b2ce1e8fc06..5601732cf4faa 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -37,9 +37,6 @@ static int set_secret(struct ceph_crypto_key *key, void *buf)
 		return -ENOTSUPP;
 	}
 
-	if (!key->len)
-		return -EINVAL;
-
 	key->key = kmemdup(buf, key->len, GFP_NOIO);
 	if (!key->key) {
 		ret = -ENOMEM;
@@ -83,6 +80,11 @@ int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
 	ceph_decode_copy(p, &key->created, sizeof(key->created));
 	key->len = ceph_decode_16(p);
 	ceph_decode_need(p, end, key->len, bad);
+	if (key->len > CEPH_MAX_KEY_LEN) {
+		pr_err("secret too big %d\n", key->len);
+		return -EINVAL;
+	}
+
 	ret = set_secret(key, *p);
 	memzero_explicit(*p, key->len);
 	*p += key->len;
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index 23de29fc613cf..a20bad6d1e964 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -5,7 +5,7 @@
 #include <linux/ceph/types.h>
 #include <linux/ceph/buffer.h>
 
-#define CEPH_KEY_LEN			16
+#define CEPH_MAX_KEY_LEN		16
 #define CEPH_MAX_CON_SECRET_LEN		64
 
 /*
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 061eaa047f765..b67f2b582bc76 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2361,7 +2361,7 @@ static int process_auth_reply_more(struct ceph_connection *con,
  */
 static int process_auth_done(struct ceph_connection *con, void *p, void *end)
 {
-	u8 session_key_buf[CEPH_KEY_LEN + 16];
+	u8 session_key_buf[CEPH_MAX_KEY_LEN + 16];
 	u8 con_secret_buf[CEPH_MAX_CON_SECRET_LEN + 16];
 	u8 *session_key = PTR_ALIGN(&session_key_buf[0], 16);
 	u8 *con_secret = PTR_ALIGN(&con_secret_buf[0], 16);
-- 
2.51.0

