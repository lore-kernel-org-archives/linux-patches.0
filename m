Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624746;
	b=XS1nWna63znUkaz/r4+ZBNc3OCRi0FZjesf/fGZbFVRVqSx3fObyafhfnM3VtPbVeAk9
	 1eQ93iYuXXFREb++jtunjlWiJ+qFcPsCiSeKiQru41jjT8lxQFa8Nilbo7YAbFa+uRjzV
	 1Sp37PsZNhHbR5xFSuSPEwr/mjEIHv5oSlqbduvRwMGU3ezan6K9OO1welz1Bs8qBpCnb
	 yqUcKKYopg2nnKuN6mOL7zZpZ6wYep8v5vL7nSh14ltgDhbjda6SdnjwGPw2/eD5dCBn1
	 Sxdc40gPOFImQtVUkbopdViJ6AfnYogUQpkYw33Izzn/ORfZXxkjlA+xInAG3ItO3dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9VM+jX9MgHy7nIHQKMR3LWIZEQ+p2+zPFOYFJ/+6gMc=;
	b=1SZReGMLMe08HbKqlc46Q5knoOb2TKofFsSBesS49THA3BNtnVIrqqQXFGMOr2M43bM7
	 0xb7aoKbNY6mbFeOt1GmVD1ptAnYxCS1DVUoZqNi7zX19MdSh7pCoIT9HaeCnNvOGCgwc
	 GSSBge2VFwEcoAmCVUyiclXeAwD5Eb9tRpFCLXrgRtFBksaCPwC7uUE63wx9+O5eyGj8X
	 ZQObAXVbzyyk+/PxRlnUoz5N1C5Y1FWc8XzAG0q37CRM0jX8fu/93tdwR1Puuj5f91lkC
	 /gnRuMo3IaadXNFyHOEPvOGSBPkHUIM0f95zSFJi1zYiSEfAxuRZkrLcSojQeyxKHLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxdViOJE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE78606A33B;
	Wed, 25 Nov 2026 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxdViOJE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17881F000C6;
	Wed, 25 Nov 2026 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624746;
	bh=9VM+jX9MgHy7nIHQKMR3LWIZEQ+p2+zPFOYFJ/+6gMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxdViOJE72T6cVFlFuDQB+p1QR3kVCBZBu3mESEESyTerKQu9BoLX5wy7hkDPQKyS
	 hXSFu8SRq5I2cNMwBJKZgVYwtIMmQFUGPigvDN1aEsb0SQtiVtA92ZNs6j6bgC2TkW
	 /J1MT3pUv69QEaUTrLSXSR0DUUYVoFmCGT93PZQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/816] NFSv4.1: retain MDS I/O until both thresholds are met
Date: Wed, 25 Nov 2026 15:30:42 +0100
Message-ID: <20261125143856.011967604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit eab627dcd18a18a44a2cbee47df3058d3637ba0d ]

When both size and I/O thresholds are configured,
pnfs_within_mdsthreshold() uses size && io to decide whether to
keep I/O on the MDS. Both variables indicate an unmet threshold,
so reaching only one threshold returns false and may trigger
pNFS layout acquisition while the other threshold remains unmet.

Use logical OR instead of AND to stay with MDS I/O until both
thresholds are met, as recommended by RFC 8881 Section 5.12.6.
The new RFC contains the same threshold selection rule as RFC
5661 which is referenced in function comment.

Fixes: d23d61c8d351 ("NFSv4.1 test the mdsthreshold hint parameters")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 33e8f8e816bd5..b48be785ebd5a 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2059,7 +2059,7 @@ static bool pnfs_within_mdsthreshold(struct nfs_open_context *ctx,
 		break;
 	}
 	if (size_set && io_set) {
-		if (size && io)
+		if (size || io)
 			ret = true;
 	} else if (size || io)
 		ret = true;
-- 
2.53.0



