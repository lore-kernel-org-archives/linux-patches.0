Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670383F9A1A;
	Fri,  7 Aug 2026 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113829; cv=none; b=IIXxqpQzJJKiwwvw8FjlQIbLZXLRCjGBuoyLWq6aWzxnJCiQePrxgLwZE1L6FGtsYfaVp+og8J4mQFg5WodmBH0OhBRttZrQe4qFq9beJ1Yfu6+45mFcrNQ2hiXpL8WvsE6bEcnC2QZj9KF0UKFS5hUpG1+A6sHVBB9mUEdV+vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113829; c=relaxed/simple;
	bh=/o0Hz6YCiIQME+4D8v4Z4RPB+S+siDigqdmKenpHgA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZA2Y/9NefFSR80ZSlK6yc720yTjOeYA/C9/V09rnlzx8k+0mpLhVWgP9d7ta25zno/skHwAudLeVABqOtXOehmG+5mjQugaHhEKL/nyaDHn3wz8EQzu0x2OLnuV7KCqyIRbT1qm4jVdKq+JDVkMQg7EUL6Tw331K3KfyI6iCrfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uT6ZnKQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uT6ZnKQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA341F00A3E;
	Fri,  7 Aug 2026 14:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113802;
	bh=7ENyDc9tp4jPZsPzwJz4/P0sBwxffcLNwle9ItQKnks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uT6ZnKQSysfpeAVeRnpPYJUMqC3ZYrjkw9pOMmKunR57gL6wDNdTNn4cjeA401O2d
	 2xMe4kjoXRXbKLYu+YDKDc9qQ8CTLvRETWJxGfbmY9W4XavHAVvBQ2ZpUkbu0mf7dR
	 KeQghsFkmACBA0wk/xSnDuuVvastfG0EpLWemGGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	David Gstir <david@sigma-star.at>,
	Richard Weinberger <richard@nod.at>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/337] KEYS: trusted: dcp: fix key_len validation and calc_blob_len() return type
Date: Fri,  7 Aug 2026 16:34:04 +0200
Message-ID: <20260807143419.404243047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Derepas <fabrice.derepas@canonical.com>

[ Upstream commit 35d661c98fe4733490f20b4311616a3c2c30abc0 ]

Two correctness and type-hygiene issues exist in the DCP trusted keys
implementation.

First, trusted_dcp_unseal() reads p->key_len from a user-supplied blob
without checking if it exceeds MAX_KEY_SIZE.  If a crafted blob provides a
payload_len larger than 128, the subsequent do_aead_crypto() call writes
past the end of the p->key array into the adjacent p->blob buffer within
the same struct trusted_key_payload -- the caller's own input, not
unrelated kernel memory.  While not exploitable, this violates strict array
bounds and triggers static analyzers.  Fix this by adding a validation
check against MIN_KEY_SIZE and MAX_KEY_SIZE immediately after reading the
length, matching the checks already done in trusted_core.c.

Second, calc_blob_len() calculates a sum in size_t that truncates to
unsigned int on 64-bit platforms.  Because the DCP hardware is only present
on 32-bit i.MX SoC platforms, size_t and unsigned int are functionally
equivalent in production, making this truncation harmless in practice.
Nevertheless, updating the return type to size_t (and subsequently updating
'blen' in the seal/unseal paths) resolves type-narrowing warnings and
improves overall code hygiene.

Fixes: 2e8a0f40a39c ("KEYS: trusted: Introduce NXP DCP-backed trusted keys")
Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
Reviewed-by: David Gstir <david@sigma-star.at>
Reviewed-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260719163939.3624767-1-fabrice.derepas@canonical.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/trusted-keys/trusted_dcp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_dcp.c b/security/keys/trusted-keys/trusted_dcp.c
index 7b6eb655df0cb..c078adebe190e 100644
--- a/security/keys/trusted-keys/trusted_dcp.c
+++ b/security/keys/trusted-keys/trusted_dcp.c
@@ -69,7 +69,7 @@ static bool skip_zk_test;
 module_param_named(dcp_skip_zk_test, skip_zk_test, bool, 0);
 MODULE_PARM_DESC(dcp_skip_zk_test, "Don't test whether device keys are zero'ed");
 
-static unsigned int calc_blob_len(unsigned int payload_len)
+static size_t calc_blob_len(unsigned int payload_len)
 {
 	return sizeof(struct dcp_blob_fmt) + payload_len + DCP_BLOB_AUTHLEN;
 }
@@ -200,7 +200,8 @@ static int encrypt_blob_key(u8 *plain_key, u8 *encrypted_key)
 static int trusted_dcp_seal(struct trusted_key_payload *p, char *datablob)
 {
 	struct dcp_blob_fmt *b = (struct dcp_blob_fmt *)p->blob;
-	int blen, ret;
+	size_t blen;
+	int ret;
 	u8 *plain_blob_key;
 
 	blen = calc_blob_len(p->key_len);
@@ -242,7 +243,8 @@ static int trusted_dcp_seal(struct trusted_key_payload *p, char *datablob)
 static int trusted_dcp_unseal(struct trusted_key_payload *p, char *datablob)
 {
 	struct dcp_blob_fmt *b = (struct dcp_blob_fmt *)p->blob;
-	int blen, ret;
+	size_t blen;
+	int ret;
 	u8 *plain_blob_key = NULL;
 
 	if (b->fmt_version != DCP_BLOB_VERSION) {
@@ -253,9 +255,14 @@ static int trusted_dcp_unseal(struct trusted_key_payload *p, char *datablob)
 	}
 
 	p->key_len = le32_to_cpu(b->payload_len);
+	if (p->key_len < MIN_KEY_SIZE || p->key_len > MAX_KEY_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	blen = calc_blob_len(p->key_len);
 	if (blen != p->blob_len) {
-		pr_err("DCP blob has bad length: %i != %i\n", blen,
+		pr_err("DCP blob has bad length: %zu != %u\n", blen,
 		       p->blob_len);
 		ret = -EINVAL;
 		goto out;
-- 
2.53.0



