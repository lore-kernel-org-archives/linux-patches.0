Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E47A2C324F;
	Mon,  2 Jun 2025 15:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877349; cv=none; b=aKOinOg+2LUiM9+G6t9yaYwngY1ZykXMSloeTM1V9gb4dsA3WkFC9YSrfSM7N8wt0Tm8/cgaVuPInKuEgemxlFSENN/E/JXtszyCrvEucEjkBVclO3iUZ2sjG6dqIvuqqseY8EmG7yzEjPjbxUgVsclL5660ldrClB5585GeIws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877349; c=relaxed/simple;
	bh=Sm6N14lkQTAEp5SiPFuZzqKmpLdZgUmv1MgcPg/if8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akTbO+X9evT6eqSKfFk1CyBNICnqPy1LUE5Jvn2QYCFX1ADxrniD/9OSvtJyvk+BQDPY4fUT42/dBKL0m1wGRqzoTpfzjX3B9r1PucuIc9Wf+4hnfkxfGAtPN7Amcby9eq83dAn6cOP0Z/ra9rr7EuMZVLbwU0QdsuqlguEqOiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfsUwUux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfsUwUux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92312C4CEEE;
	Mon,  2 Jun 2025 15:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877349;
	bh=Sm6N14lkQTAEp5SiPFuZzqKmpLdZgUmv1MgcPg/if8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfsUwUuxiucEXet65bk1C8FJPCr0msjK5vZ1ulC3BrPsRijQVD9hGGjfPOotcJbQW
	 xewbTgU3yQR3QX9yqU3RakFk+P09OIrMM9ukKVkFXv7Wg3CWltQQ6TN6MJXNCPUuaE
	 dJRVc8Qu/3bYyjrbGiY/ky4tfCitua75eDz4BeRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 250/325] crypto: algif_hash - fix double free in hash_accept
Date: Mon,  2 Jun 2025 15:48:46 +0200
Message-ID: <20250602134329.937545350@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -263,10 +263,6 @@ static int hash_accept(struct socket *so
 		return err;
 
 	err = crypto_ahash_import(&ctx2->req, state);
-	if (err) {
-		sock_orphan(sk2);
-		sock_put(sk2);
-	}
 
 	return err;
 }


