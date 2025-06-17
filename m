Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E53C11CBA;
	Tue, 17 Jun 2025 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174268; cv=none; b=bV4toceyrk9l1lyu/v98OjNKOZLP8ea94IgW11keOvFk3NYkVdU7jyrzWdUJreGse+a30xIDwzFaH7qx4wfUCCHLK5YdZtWs0maw6B84VFdLaALwnse9wGT29mSjCpZ1dX9Tmu3xfAU5Ovty+0r4aDsn/ci2noqmtDPHmw63SJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174268; c=relaxed/simple;
	bh=hrNy/I+6g8xjUS8nuyZK3XM11JsPH6qSTVvxhcnu4QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0m8ZG4UGI1CUqgKYkJ9QHE9OGRHxMO7Y3GLTK7PBPydpmpurbXT1KtDVx/w59LuSrNbocFadXeNpDYcuK3FXIeMa4lkkN3V5r/oof7PTUbq8OVeeZO7K7BGx+jkn2VMoEkYv/gei80GMuCKKIHml0ZBLaNwXfW2d7rW93ZN2ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIlNg/ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIlNg/ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D801C4CEE3;
	Tue, 17 Jun 2025 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174268;
	bh=hrNy/I+6g8xjUS8nuyZK3XM11JsPH6qSTVvxhcnu4QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIlNg/kuwvWpUEIDxzykbOp2WJRUlFjpbZtt5HWJwJDh7jBnm3j2Mnlu6IDfHUak0
	 pkp5Um08nzCGEWOA+lkJxyLKlS+OvTeKp9+cyH3FJ+uMQNOtFQlt2Mpzqofcy3Q7Wh
	 ilEMxSeoYXuHYQVwNbUOkwA1jsBlq+ADM0AC+WPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/356] crypto: xts - Only add ecb if it is not already there
Date: Tue, 17 Jun 2025 17:22:30 +0200
Message-ID: <20250617152339.635202968@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 270b6f13454cb7f2f7058c50df64df409c5dcf55 ]

Only add ecb to the cipher name if it isn't already ecb.

Also use memcmp instead of strncmp since these strings are all
stored in an array of length CRYPTO_MAX_ALG_NAME.

Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 038f60dd512d9..97fd0fb8757c2 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -363,7 +363,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
+	if (err == -ENOENT && memcmp(cipher_name, "ecb(", 4)) {
 		err = -ENAMETOOLONG;
 		if (snprintf(name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -397,7 +397,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
+	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
 		len = strscpy(name, cipher_name + 4, sizeof(name));
-- 
2.39.5



