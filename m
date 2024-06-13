Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF71428E9;
	Thu, 13 Jun 2024 11:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279248; cv=none; b=cPW2mqyq8iFqfJ78d7ItVpSffebTyCPuBBi7aP+L/am1ynXGarmqfK0HQhhNKvvSI/wJ7jq+6aOy/IFrqYmJ9eE/qIidiGegyJAbsIOKTz6Xb4+vIUM1hFXzcyaoVSwKmmnGepEKJ2IjanVq8eWLvYXL0i8oPw2Jw/ZLAjb6FKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279248; c=relaxed/simple;
	bh=kx2ULFD2210OodSo/vHDIRuieCwhKcL4TubCk56Jh34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFyCTu3xFU1kuWFyKj0d93vTCc6Iz8XC+7EyVVDYlQ5l8MKlZCEVruCFF429WSl5UcWe2JeqgiQpjX1IclRWkueccPIl8poe5Yk6R2PjCHzs5XpSq8RjMAz6lWi90j/F3Wcy7MtnSBxhGoiOXhdUJXNLX/e6ZjnChZtrRl4RbPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Edbb54Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Edbb54Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF5EC32786;
	Thu, 13 Jun 2024 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279248;
	bh=kx2ULFD2210OodSo/vHDIRuieCwhKcL4TubCk56Jh34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Edbb54Ubom0QSgaR8A137DEx+zLTZr+pKRIALrFm0eF08PSkWJV2DzUYEVShGXmxo
	 WotokpRQmDNTW6rcpZX8RC8REcZnjIanl7yNFykg3DSKhsw1Vuja1hWJnxyzzdB+lM
	 DsDpQC38PJWNwqvnN+u2jE3Vna7rpvVHxv98AxkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.9 012/157] crypto: starfive - Do not free stack buffer
Date: Thu, 13 Jun 2024 13:32:17 +0200
Message-ID: <20240613113227.879431470@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

commit d7f01649f4eaf1878472d3d3f480ae1e50d98f6c upstream.

RSA text data uses variable length buffer allocated in software stack.
Calling kfree on it causes undefined behaviour in subsequent operations.

Cc: <stable@vger.kernel.org> #6.7+
Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/starfive/jh7110-rsa.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -273,7 +273,6 @@ static int starfive_rsa_enc_core(struct
 
 err_rsa_crypt:
 	writel(STARFIVE_RSA_RESET, cryp->base + STARFIVE_PKA_CACR_OFFSET);
-	kfree(rctx->rsa_data);
 	return ret;
 }
 


