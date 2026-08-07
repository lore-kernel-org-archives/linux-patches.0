Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50A034216C;
	Fri,  7 Aug 2026 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116681; cv=none; b=cyk0Pu5OPQM0hAak0m+5zEp5pIwGMJC1fAE+2czUqTlgP1TzTRzWHQVyrxbDIH88dTY1Ji0ZNiD/6eS/utYBQV3jitc19w2B4DV8bQxFZCYoF9mdaSzWCGPjR8J+7J/2sG1/j5+W0oOoZH3z6k/MpqXenXcIWrDq5gfqWbbtf4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116681; c=relaxed/simple;
	bh=i4SdQPwfsvm0zDoV15Uc+W5GVp5b+Net7kR3UCgHmBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTvHzROGSuSGcWae5hdpHJDyP5ij5NAgPImGwsnPrT3plDweFlngw8CkiVdST2mpruONocn21rePrDqhc22yLS9uiKzTj84/5pGGONHdZ0M1JxyfVxmvJF8NGY/gx7q+ij7P/8jrIoCLJrX16v9uCAsbWHYBvI949AKC6ouWFNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgZtZVXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgZtZVXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B67F1F000E9;
	Fri,  7 Aug 2026 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116679;
	bh=wLl0pepbJrYu/y+wdKw4emVZDIRDZ0PMctvxuYJOL2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgZtZVXf9cGSZAjJACd6abayJtux1khilqn44QfonQzMgS1hzXHgGzIMoIkcYw4qh
	 WxwHOLuXaZL/VN6ZL4j5/7f2KV0XBplQ/76lr14tVSTcX43wF4lwreSsMq0+66p5r8
	 G47KqRk0Urzd+aCuFIRzaRBea33pUjTpDoZj/rqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	David Gstir <david@sigma-star.at>,
	Richard Weinberger <richard@nod.at>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 052/438] KEYS: trusted: dcp: fix key_len validation and calc_blob_len() return type
Date: Fri,  7 Aug 2026 16:34:08 +0200
Message-ID: <20260807143429.102900105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



