Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CBC30C628;
	Mon, 13 Oct 2025 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368294; cv=none; b=TlyezGJjQXcPHhe7KsNY0q52jtD4UhdOWRc1CZqKLFRoMiFmDqTR+EaDg10Zrwnbe1wo9m7nGZ3oQUggYD2GwJlUbvGUWzq/9e33Uzpz3bu4gUSnkmCILpEDK1DBhHZUaLr23Mi3Q4/DVSsgSfMDH/uYSiW4gaAbTawgaMaFwYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368294; c=relaxed/simple;
	bh=KELxqXfJY8BSCv7XCetA6CQGdZXkJf67Zb7Kz3ZDMoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lcn+ZgwapUnV1I4sVo2JKpumLLmWprlxqc+uNZpP87HYCzshMbtocmQuxa0locSp2A3ZOb5LmoqwAIrOsZ1pSONGNn+TXNIzNh6Q0zHZz29rxO9561j02XEoxXrjcW7jYBnoVpOBsC7Fo2eGlqY57QTfwofdVIiJbVdf/gMdgbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4ARp/Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4ARp/Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227AAC4CEE7;
	Mon, 13 Oct 2025 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368294;
	bh=KELxqXfJY8BSCv7XCetA6CQGdZXkJf67Zb7Kz3ZDMoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4ARp/YeDY/XM7xynL458bOckfgnDVQpkzL/eJ5EFrow69lnkX1XTAY3GlSlbCvzQ
	 DtLFWD59KVfoe/dDlYA+WI5sgvM5rdAy77ALe2DBXWy0AKMMev63spCEMY8P3tZRJj
	 +QT2TFlF32l7+oN813YQeLABvGdjWGsua7w6uYmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/262] crypto: octeontx2 - Call strscpy() with correct size argument
Date: Mon, 13 Oct 2025 16:44:06 +0200
Message-ID: <20251013144329.873810361@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 361fa7f813e7056cecdb24f3582ab0ad4a088e4e ]

In otx2_cpt_dl_custom_egrp_create(), strscpy() is called with the length
of the source string rather than the size of the destination buffer.

This is fine as long as the destination buffer is larger than the source
string, but we should still use the destination buffer size instead to
call strscpy() as intended. And since 'tmp_buf' is a fixed-size buffer,
we can safely omit the size argument and let strscpy() infer it using
sizeof().

Fixes: d9d7749773e8 ("crypto: octeontx2 - add apis for custom engine groups")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 1493a373baf71..cf68b213c3e62 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1614,7 +1614,7 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 		return -EINVAL;
 	}
 	err_msg = "Invalid engine group format";
-	strscpy(tmp_buf, ctx->val.vstr, strlen(ctx->val.vstr) + 1);
+	strscpy(tmp_buf, ctx->val.vstr);
 	start = tmp_buf;
 
 	has_se = has_ie = has_ae = false;
-- 
2.51.0



