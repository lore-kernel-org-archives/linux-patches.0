Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4AD37F32A;
	Thu, 20 Aug 2026 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238808; cv=none; b=XFc6eAwNKPUUGeSsCZFv28dKNjl5YcV4xsk/AnGVtP4+QXXP/AgApmhBiWYcLOfOgle51DucbGxqrYFKRqYzRMXdDq5HGLA88TFeoR6ZojX9nXmap2LYPFjFdRr2IsuR7kNWW4Hcy5lampoBxnpPypEVVEkixc7nceEWsuMPLT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238808; c=relaxed/simple;
	bh=oqk056qHQ7yXLMM1jc21q34Ouy3KkPvV6L8uJaqo79A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ob9ZGRGdK3GMs+rHSIuXKXdQJY5pvrm3UYYTFboSRCRrz/XEe/9qxamV6X3TwpncOTehhMFBRgsiHGK4IaUylDzuGUx5ypCQmnWhWH6O/GxNpe3/Z8d/X3A/SMy7lvgTL8PniHHt+b2CFxIhUrnVxGRimFIN1bDfbJ9aC/tEOPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrPyKBcb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrPyKBcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359711F000E9;
	Thu, 20 Aug 2026 15:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238807;
	bh=F2MeQTgiedq8OTbvysCEyjs3FP44EianrLLMmkzpdkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrPyKBcbOBM2ygOsk0ew30091Wf0VYtvZODacASW4+dpOB21vpj8oGUExV6UCW/Ml
	 Kl3e1GAslHC8z/sX4APM4nu02MuDpb6A7XRM1bc6tumV6iJ08gCZCoAou8OzKav+s+
	 o4A4TwiuLz+TzLeJ8nGseszdrrcZq+IZqEiYvUnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 049/217] crypto: qce - fix error path in devm_qce_register_algs
Date: Thu, 20 Aug 2026 16:53:37 +0200
Message-ID: <20260820145239.098842427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 9c75402286409f5e1a75e4a445555c84066f89db upstream.

If ops->register_algs() fails, the error path repeatedly calls the same
ops->unregister_algs() from the failed registration. Use the loop index
to unregister the previously registered algorithms instead.

Fixes: e80cf84b6087 ("crypto: qce - unregister previously registered algos in error path")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -60,7 +60,7 @@ static int devm_qce_register_algs(struct
 		ret = ops->register_algs(qce);
 		if (ret) {
 			for (j = i - 1; j >= 0; j--)
-				ops->unregister_algs(qce);
+				qce_ops[j]->unregister_algs(qce);
 			return ret;
 		}
 	}


