Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186C822CBEC;
	Mon,  2 Jun 2025 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876424; cv=none; b=r5JUJoC05UBHsGBgQIn00G/DKUwWHsgEco/57eYRqPqFh/l0udD2qPkrQurgenQROUgYvPNVgUmsagNAt38kBpf55TN2YXXRN80NDtDGnz7jazsbanRkDEzFbMqIgiMURpstOL+SyfO5/4gmsq5/Hx3I5Vr0mpl1PS8xKMYgWBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876424; c=relaxed/simple;
	bh=1Ftr4HdEkH2n7WhLDwFywThCnnyq+z0QeULipoHnY8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlSra9RImAk0XZhtQVPDoBEDWNT/xYjoWafXa7lEYJd/Y10vP8e59TkrnPiR5smQnIB2zBIq4lB9l6WukeBTnUWzszInt6g83Ao6unWSSOw9XYlPlhMtNi+ormpOZN6T6mLkBAmdByhDN0b78JpHSSjGTiNylWqyu2pKgbI/EJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUZ2FTnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUZ2FTnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17318C4CEEB;
	Mon,  2 Jun 2025 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876424;
	bh=1Ftr4HdEkH2n7WhLDwFywThCnnyq+z0QeULipoHnY8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUZ2FTnAeWLKxSsF68NQeivcKI6Tz1AKTBYzXOv5bcNdGGmn6VFz27mAk5hTsVqJ/
	 cfxB+DDRg0P9I4ZpwxLK+QuouQZpmlubYRX2kVd431r1ot1AobPf0rXP/IKDmH0lie
	 5A9HMjnXv2n9tVQdp6astGgVMf5d0KQ2t6LaPrX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 170/207] crypto: algif_hash - fix double free in hash_accept
Date: Mon,  2 Jun 2025 15:49:02 +0200
Message-ID: <20250602134305.403178530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ivan Pravdin <ipravdin.official@gmail.com>

commit b2df03ed4052e97126267e8c13ad4204ea6ba9b6 upstream.

If accept(2) is called on socket type algif_hash with
MSG_MORE flag set and crypto_ahash_import fails,
sk2 is freed. However, it is also freed in af_alg_release,
leading to slab-use-after-free error.

Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algif_hash.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -262,10 +262,6 @@ static int hash_accept(struct socket *so
 		return err;
 
 	err = crypto_ahash_import(&ctx2->req, state);
-	if (err) {
-		sock_orphan(sk2);
-		sock_put(sk2);
-	}
 
 	return err;
 }


