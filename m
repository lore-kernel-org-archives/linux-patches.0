Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1B430FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5087C433D9;
	Wed, 20 Sep 2023 12:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212468;
	bh=vLp8/PXrhm+HA/bmGsb7n9MbaOKzmXw8BbZlOSpPdaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nqg0xljo/n74ODy/vf6ki3TsGawVbAJef9waT81/enCHXDJXcEqq690Up0UmztskT
	 Ww+jqtAkqcPz9maBV9WkZwySmxhr1rjyBbA8BFoc5LNsW8qGRiz219Kzbw/aTyHim3
	 +Bz0BVy/5Ba0Pz0TNFlOSz2t6kcYJFmFf59cATRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/83] crypto: lrw,xts - Replace strlcpy with strscpy
Date: Wed, 20 Sep 2023 13:31:03 +0200
Message-ID: <20230920112827.201845018@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Azeem Shaikh <azeemshaikh38@gmail.com>

[ Upstream commit babb80b3ecc6f40c962e13c654ebcd27f25ee327 ]

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().

Direct replacement is safe here since return value of -errno
is used to check for truncation instead of sizeof(dest).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/lrw.c | 6 +++---
 crypto/xts.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index bcf09fbc750af..80d9076e42e0b 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -357,10 +357,10 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
-		unsigned len;
+		int len;
 
-		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
-		if (len < 2 || len >= sizeof(ecb_name))
+		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
+		if (len < 2)
 			goto err_free_inst;
 
 		if (ecb_name[len - 1] != ')')
diff --git a/crypto/xts.c b/crypto/xts.c
index c6a105dba38b9..74dc199d54867 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -395,10 +395,10 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
-		unsigned len;
+		int len;
 
-		len = strlcpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
-		if (len < 2 || len >= sizeof(ctx->name))
+		len = strscpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
+		if (len < 2)
 			goto err_free_inst;
 
 		if (ctx->name[len - 1] != ')')
-- 
2.40.1



