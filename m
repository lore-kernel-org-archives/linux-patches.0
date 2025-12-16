Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D02352926;
	Tue, 16 Dec 2025 11:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885763; cv=none; b=CJAKW0JdiBnjIt3cT0DzEKWW+gPRrcJoRYtBBsCKMEKO3+GZ6yo38HcPGdrLe/FM46i/w99UiAeAdISLDi1hl7r14XtamOtotR06lmfhOaYSRE8BTu9VFKJz869IB9lqJvVtjqG5E9wxcDZpjkherik6vvPNP8Lzuezn2GUBnx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885763; c=relaxed/simple;
	bh=GsVXgOcazjaJcff6x9/KM5NPGCiiEw/U2RiUFta+SdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhPYZBSBneIIaJbkH3C+CknFV3IZVQ6422CoY3Fd6/Llj3ZrFakt2bF4/EoNXCTVGm13IPsNwYxzL9s7Wj3zIaJgdjwVDe3JwTibEJ4tyIG2uqMXuVaw6iI+ApsjOmTyW7V/xHRJZdO4A4UTcbA4j7SM2fnE3UBkY70sN4J75wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+KCiMkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+KCiMkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AF8C4CEF1;
	Tue, 16 Dec 2025 11:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885763;
	bh=GsVXgOcazjaJcff6x9/KM5NPGCiiEw/U2RiUFta+SdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+KCiMkMZQXNO+OPXDfvEmL4+A7aGsyHchDxaN1X8u0RZnt80zahWRIHAKauhEzqd
	 QYOcNd9RzvraKNnNFdXlt/mlE6mi+MMdOdUuyfClC6S1RX8+CeniX+y4bvSztGuDJR
	 FE2oric6bAiHZ+EdcbqUXSGzzvqK4zgdfty6x8Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 236/507] crypto: iaa - Fix incorrect return value in save_iaa_wq()
Date: Tue, 16 Dec 2025 12:11:17 +0100
Message-ID: <20251216111354.050170330@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 76ce17f6f7f78ab79b9741388bdb4dafa985b4e9 ]

The save_iaa_wq() function unconditionally returns 0, even when an error
is encountered. This prevents the error code from being propagated to the
caller.

Fix this by returning the 'ret' variable, which holds the actual status
of the operations within the function.

Fixes: ea7a5cbb43696 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto driver core")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 23f585219fb4b..d0058757b0000 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -805,7 +805,7 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	if (!cpus_per_iaa)
 		cpus_per_iaa = 1;
 out:
-	return 0;
+	return ret;
 }
 
 static void remove_iaa_wq(struct idxd_wq *wq)
-- 
2.51.0



