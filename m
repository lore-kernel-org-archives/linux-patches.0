Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9891474AF;
	Fri,  6 Dec 2024 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496803; cv=none; b=hjL0ywPSxOhmVeXzBT1ycSRIPIV9kYEwiUgWdAL/2sSd91mnPlJJj8IEmGKJ199Ka685LaDy1CaMg9b5os3XEo1rTqeIWbo52ZVcZ9Qc9QW8bkzYZlKHDMhtMEz1lz245siZNH4oUW/w8Ol5+33FvXGfx4N7PEO9xHgZUz8u9cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496803; c=relaxed/simple;
	bh=T0qzNhshEXA5e8ESb4JVny0UfjCsvvX6phn2KGYwfRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aoj5028CftYU8pnIczvb5GKdrkUQvd3bXJYM6ecaaR31LLxjfT93d2g6G2YyIVomW/KZtoCZybloaTsYLSqQ/z7Z3aFTgiE+nxjtNUNg5MzDNKcAetf8zY3kfBsncJRAPoqFlTDafXU1AyUpnrHtsSVhkBh6aibjz8h+a/3CEl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDC2H7KR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDC2H7KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1DEC4CED1;
	Fri,  6 Dec 2024 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496803;
	bh=T0qzNhshEXA5e8ESb4JVny0UfjCsvvX6phn2KGYwfRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDC2H7KRSZNo+sYXk0X8sd4BTRI2+UyGAz1jIl/fLlEoQFcZuCDunbiLswsGE97ti
	 9hCRZwrIqH9Yn6Vzxi3vcgVJuII7trwpA11ZayqvGE/WDJ3QPVO6qoylQiNgOQK/7O
	 5wVxHSXZU/77KZAOeDVn/3CFghVm2MAftLwajya8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/676] crypto: caam - Fix the pointer passed to caam_qi_shutdown()
Date: Fri,  6 Dec 2024 15:28:16 +0100
Message-ID: <20241206143656.376477288@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ad980b04f51f7fb503530bd1cb328ba5e75a250e ]

The type of the last parameter given to devm_add_action_or_reset() is
"struct caam_drv_private *", but in caam_qi_shutdown(), it is casted to
"struct device *".

Pass the correct parameter to devm_add_action_or_reset() so that the
resources are released as expected.

Fixes: f414de2e2fff ("crypto: caam - use devres to de-initialize QI")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/qi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 46a083849a8ee..7a3a104557f03 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -772,7 +772,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 
 	caam_debugfs_qi_init(ctrlpriv);
 
-	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
+	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, qidev);
 	if (err)
 		return err;
 
-- 
2.43.0



