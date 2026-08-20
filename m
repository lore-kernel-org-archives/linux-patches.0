Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AA547D46A;
	Thu, 20 Aug 2026 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244010; cv=none; b=fCIZ0XCVQ9WPLKxTMPaQfcvIiJkDNeIrEQtIO74wMEMJUmNxQrmkqYpIHW2bokBEH5wb1faVaoNWNHExUVl8+jpX8ZZwXO7xj151AEVwuwUgqapGv8g1ZXqkETxS6ipx39jZwPu15AMZd9DoI9kyK0xFTtYfxwsZOJKMrtaR6yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244010; c=relaxed/simple;
	bh=K3e3vd6OrzUH0RfwJ6oe3k6LHHmMsOLVHDGHi6/JGRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIZ+Yo5ToHsNo8U4ZzdHwdQvUQRcoIzsrKJ/e89oRxJhejal7EZfxXARAJfAafyMXcSTVlPxP+VTbdz2mpT3aif9cm8+d02PW/Cbkav/RgpHV4MJtKW1CFVJqrUz6aMMrDOE2tZeMv+uIOrkLClBhEfqInXnz/e3swp8Z5DX1xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEaTKaA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEaTKaA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8C51F000E9;
	Thu, 20 Aug 2026 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244008;
	bh=s0GtySlMgGQ3h4adxFZaBpgkZrjseQMZWrbLxGc9fJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEaTKaA0vLEephm9pYYslRPhpnNOztK3txYSHPWsjtmNgI6cHPNw1resC12IqbUZ9
	 if1h/psYm734w2Vix/NM9hcSf85CjPCkBvje4mt69xkQ4lHw9Mj26W67xzYY48Sovi
	 /porHbcRrBw/HYPjnZURXpJX3FFLweEM2F4hHSnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 021/235] crypto: qce - fix error path in devm_qce_register_algs
Date: Thu, 20 Aug 2026 16:54:17 +0200
Message-ID: <20260820145217.083771437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -52,7 +52,7 @@ static int qce_register_algs(struct qce_
 		ret = ops->register_algs(qce);
 		if (ret) {
 			for (j = i - 1; j >= 0; j--)
-				ops->unregister_algs(qce);
+				qce_ops[j]->unregister_algs(qce);
 			return ret;
 		}
 	}


