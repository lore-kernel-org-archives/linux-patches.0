Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852613B9930;
	Tue, 21 Jul 2026 22:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671718; cv=none; b=qOj4pZIGpiv/78YkpmkuJVXSWe/M7OtTKQ04kiYdVGqcdn0niMM5m4sDAIpmdrzpOCpeevQf/C81fsNOFKnD9GSG1XbDro1/nmusBmOZNTViObqPYZ46JGLtv8ir6prlQe9B2vxzK4ZE3jjd4KMrIEcQGLkkyKL8WMZANs4ujJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671718; c=relaxed/simple;
	bh=yPv7Ib/vdYWDgd0ZUpEFQvmTp8nRLkB2K5DVtIJl/5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyJBToTOPHBzaPzyDxdBrVoFFu1t5sF4NTzDC5wp9QkpVAfrZFrSCVgdFcoAfFWgpiO9z3WuoXu8R3Dnr4QkxJX/a1M/aZ8L0j8UxvItHlTUCbIj9+MEgq6T3GwbX1ugrOnq/ycQ4kXWALKdAKTiqhrbrw9M+TuWxvZI9NDy6ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pE5469Je; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pE5469Je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF31E1F000E9;
	Tue, 21 Jul 2026 22:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671717;
	bh=L3Oup4PxU5ST9UKixQjhgFbhfL9SDtmk7pffyFd6Uw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pE5469Je/f9NEgiksdKau6fJiEnBkQ00cc4OeIh3t6u4hekKE+KHFSpicpHmwkgcu
	 38gOn6hlEtStXc52bgYtSxCenVMtRiKWTkduHvTwPVrdgpgSCepNLV9xATEZydVeBX
	 YqttHvLUHa4ooVnCpkSXqrlgcZ1LxVaeo99YXbww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/843] crypto: rng - Free default RNG on module exit
Date: Tue, 21 Jul 2026 17:19:45 +0200
Message-ID: <20260721152413.909719114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 606ba888b98e0d26a2c4e5c8dc0542e3ad8f0f3a ]

When the rng module is removed the default RNG will be leaked.
Call crypto_del_default_rng to free it if possible.

Fixes: 7cecadb7cca8 ("crypto: rng - Do not free default RNG when it becomes unused")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rng.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index a2bf2efb7937f9..5992cdb392c50a 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -232,5 +232,16 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
 
+static void __exit rng_exit(void)
+{
+	int err;
+
+	err = crypto_del_default_rng();
+	if (err)
+		pr_err("Failed delete default RNG: %d\n", err);
+}
+
+module_exit(rng_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
-- 
2.53.0



