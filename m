Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CE2153836;
	Fri,  6 Dec 2024 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497928; cv=none; b=CtvWf5Kk9SiVKf/QlLt1bpc3w6oAvChV/afPhR26N7Tg3P+A0uPWDmsVxxwvQn7lgabE7g2gALOA1kdTQneukfz6iRfBfSmkjovB9ISnrZ2busQfTEo9ZMV7VM2LDqejobu0dT3+T+NI1JQA5pTQbRRMAbs+zSgjntzooIHbysU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497928; c=relaxed/simple;
	bh=y/elpe2cfCQC9GxKS/qExqJ3Hxr4uSrFUIwcU070CnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iM4ivFEixaZ/k17zAlI1zbtTGQQWfaw1fCYdwssrPnG8OkOiPii3OhSWZvSS/PKymZIStDMdpm4kyHdvEV0yxvvec9mS9uAOs9CqVVPDWTsJXBki3bjvj0ZmF6Rh6YP8BQF17ny/diMKMkN3dZ9xmnZxSCNd6obGVFabtSoLiWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XICjboUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XICjboUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88300C4CEDC;
	Fri,  6 Dec 2024 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497928;
	bh=y/elpe2cfCQC9GxKS/qExqJ3Hxr4uSrFUIwcU070CnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XICjboUW74vzDOa9EHv94FJqEPkpp/yz7sCIL9uuIeedC/Ou6kg3vogFMPwiUuiKX
	 TnlfX+Ong0Bk3Sx6MVluVL5otT20CUlLT6Vag1pp0Jg0z6kmDYg94ggsb1i3FezG/X
	 Bcre6E999FuOV6lm9OKUsJCuWUIFUz+og9sMhOLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Russ Weight <russ.weight@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 434/676] firmware_loader: Fix possible resource leak in fw_log_firmware_info()
Date: Fri,  6 Dec 2024 15:34:13 +0100
Message-ID: <20241206143710.293873624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 369a9c046c2fdfe037f05b43b84c386bdbccc103 ]

The alg instance should be released under the exception path, otherwise
there may be resource leak here.

To mitigate this, free the alg instance with crypto_free_shash when kmalloc
fails.

Fixes: 02fe26f25325 ("firmware_loader: Add debug message with checksum for FW file")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Russ Weight <russ.weight@linux.dev>
Link: https://lore.kernel.org/r/20241016110335.3677924-1-cuigaosheng1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 0b18c6b46e65d..f3133ba831c5e 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -824,19 +824,18 @@ static void fw_log_firmware_info(const struct firmware *fw, const char *name, st
 	shash->tfm = alg;
 
 	if (crypto_shash_digest(shash, fw->data, fw->size, sha256buf) < 0)
-		goto out_shash;
+		goto out_free;
 
 	for (int i = 0; i < SHA256_DIGEST_SIZE; i++)
 		sprintf(&outbuf[i * 2], "%02x", sha256buf[i]);
 	outbuf[SHA256_BLOCK_SIZE] = 0;
 	dev_dbg(device, "Loaded FW: %s, sha256: %s\n", name, outbuf);
 
-out_shash:
-	crypto_free_shash(alg);
 out_free:
 	kfree(shash);
 	kfree(outbuf);
 	kfree(sha256buf);
+	crypto_free_shash(alg);
 }
 #else
 static void fw_log_firmware_info(const struct firmware *fw, const char *name,
-- 
2.43.0



