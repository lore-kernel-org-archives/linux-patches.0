Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CA937CD5A;
	Thu, 20 Aug 2026 16:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243235; cv=none; b=P49xLtqKUsla0q2LJCKRVhp9NIi7vZ6e33osz0Eppc3jGucQ+bu7uKfOTjGtgmFsPDdVOktxgcvWZkq2B/i2bGpY3awFaojjwrsCK0IginXgFoBjvEjaKk7GE1CrSsU9XCd4nxeDSEWS+R/8/12XX+if9WsDCqjpyuT604zbJWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243235; c=relaxed/simple;
	bh=FRLIetSgEBNpY7rZ16qK/k3yhTzSFGDSsWTgsh1xxiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTDSc8227Bj6pi5WKEsaJLBNgw0ibiCObx+zPlCXgKqqaY73HMVMN6t0RD1jCra4ataJSGAL0b4pRg7OwG/bzstEis79gpJWjGGiB9Q7h3owU/nTJ8Akf18UIoOkjVHt0LO+3KRCfTQ+EVoKtbPqtEgdtGF1WMWGgxUc2G8TdyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0DwITsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0DwITsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD651F000E9;
	Thu, 20 Aug 2026 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243234;
	bh=22QlVAcIOZOrDsKAdaFDpWA9ivGH7XRfuJslJKt1bpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0DwITsf+eZKEPzUbw9ES/X/IqUSQhpCdrk4eCBU685FU2rQueuZP/cJ4I9unWGys
	 s+y6tSi/3bnLDb+piG7bxDblGufv8Rmxfh4DN/Lkeo5Z3rWR+pekEEE326pzWpoVkf
	 BVAjfByGCKWXRAj9K5VXK3yqKbNFGqg7c22DV9gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 024/272] crypto: qce - fix error path in devm_qce_register_algs
Date: Thu, 20 Aug 2026 16:53:28 +0200
Message-ID: <20260820145231.955941687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -55,7 +55,7 @@ static int qce_register_algs(struct qce_
 		ret = ops->register_algs(qce);
 		if (ret) {
 			for (j = i - 1; j >= 0; j--)
-				ops->unregister_algs(qce);
+				qce_ops[j]->unregister_algs(qce);
 			return ret;
 		}
 	}


