Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB252EA163;
	Tue, 17 Jun 2025 15:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175059; cv=none; b=FuxFd/XZFXHVhUDBU8ZgOzgUydPTZmuz5np1gprAFudATOQPZp3I7NdAlWVnI2hnAb1DsJcDz6DTDibGtTUnD0XGmn2QsVOzXXrpXBd0NpqcmmcQms0FCRVemOBsGIep4jwOs/oofE/3uqOlmGOLxA8iP+YyxZ2GZ7k1seVJ5ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175059; c=relaxed/simple;
	bh=Ppxk+TJp1c7N2kcyVl38ABe3RjDFMAnxRF0Y8gfKals=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQ/3EiT8nJwPYnthhxd15XtURbiPMNAnSeA1wGTq64IH22dCFPDp1/2rx6HnWY+FsgqS98xrNykPqpL3yMfsrf99Aj15+H14dLI7/v5shf5WEK0nEiAghl64LhD7IJlGhXMTjyPoWeLTvM4igTjSxBLrGi1ra5/9I3gYtaTbyw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZg2QYgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZg2QYgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DC8C4CEF0;
	Tue, 17 Jun 2025 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175058;
	bh=Ppxk+TJp1c7N2kcyVl38ABe3RjDFMAnxRF0Y8gfKals=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZg2QYgMefUAKQOGB/WvRrJNBJ4OYu/VSF9kAkyNz1+pddCtabq7N5SbSBDJRwR0+
	 EE8qA366t0YatjsUMnnTxS5J2l5+8qAQAvyig9skBGe5Z0GDLms3KcHu0Z4ZfAO3KO
	 fGj7YDOYnJ8Ied1As79hqeM38POUu3v4N7twvnH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 045/780] crypto: lrw - Only add ecb if it is not already there
Date: Tue, 17 Jun 2025 17:15:53 +0200
Message-ID: <20250617152453.328147956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 3d73909bddc2ebb3224a8bc2e5ce00e9df70c15d ]

Only add ecb to the cipher name if it isn't already ecb.

Also use memcmp instead of strncmp since these strings are all
stored in an array of length CRYPTO_MAX_ALG_NAME.

Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202505151503.d8a6cf10-lkp@intel.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/lrw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 391ae0f7641ff..15f579a768614 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -322,7 +322,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
+	if (err == -ENOENT && memcmp(cipher_name, "ecb(", 4)) {
 		err = -ENAMETOOLONG;
 		if (snprintf(ecb_name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -356,7 +356,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
+	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
 		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
-- 
2.39.5



