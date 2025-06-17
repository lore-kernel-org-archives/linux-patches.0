Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F8D2F94B0;
	Tue, 17 Jun 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176843; cv=none; b=lxnDciBKYy7tidx9Psjlns72/1pDbcirGskTYh1e/xPOJTyaMp0nUJNw82HAK4I7dyu+uw+mjQncp5iheqTKjtCkz69x9LnpYfX8vAmgGINSmTkkXi/T7QE3rp8boCbOZm70DWgZ2ce/EiJOjKYVqrvvPxDI7Y57MuuObdxk93U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176843; c=relaxed/simple;
	bh=RoqXf0Bg3Hl2+lVPuYCI51xUcUEPMAVOe91NZaQMOR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBRN3Bgt8Bcm4CbOu30ReWk2amrU36stn2oYupj12Gw05j3tu2EVmxOPJViMu9KbHFVrp7rTBpe4NbVfw7S7tcQT+2Ac+xru9lyiTa7gvI3s7HTLcnDmHD9Im/LpkIUShmirhtJDdAeI9xvSY4H94xkHfHg9qCI6uYkoRjxFGYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGG35S1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGG35S1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F7DC4CEE3;
	Tue, 17 Jun 2025 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176843;
	bh=RoqXf0Bg3Hl2+lVPuYCI51xUcUEPMAVOe91NZaQMOR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGG35S1Mo0Ng56Xsk7If1uaSeU7DmwPQbXuJjZ/hgSUHMHPlJKpmsctxEwVyh7Ldk
	 OCAoHeoGb14BcvUsW3R99/jPmZ0KR8WyLv0vn8cXwO2/aN8Hok9Q8eaEGPBZjgHDE1
	 v1Q8SxOBlMmmBVRa9izthdGpwej1miOtkrlTGROY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 231/780] crypto/krb5: Fix change to use SG miter to use offset
Date: Tue, 17 Jun 2025 17:18:59 +0200
Message-ID: <20250617152500.858674718@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit eed848871c96d4b5a7b06307755b75abd0cc7a06 ]

The recent patch to make the rfc3961 simplified code use sg_miter rather
than manually walking the scatterlist to hash the contents of a buffer
described by that scatterlist failed to take the starting offset into
account.

This is indicated by the selftests reporting:

    krb5: Running aes128-cts-hmac-sha256-128 mic
    krb5: !!! TESTFAIL crypto/krb5/selftest.c:446
    krb5: MIC mismatch

Fix this by calling sg_miter_skip() before doing the loop to advance
by the offset.

This only affects packet signing modes and not full encryption in RxGK
because, for full encryption, the message digest is handled inside the
authenc and krb5enc drivers.

Note: Nothing in linus/master uses the krb5lib, though the bug is there.
It is used by AF_RXRPC's RxGK implementation in -next, no need to backport.

Fixes: da6f9bf40ac2 ("crypto: krb5 - Use SG miter instead of doing it by hand")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Link: https://patch.msgid.link/3824017.1745835726@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/krb5/rfc3961_simplified.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/krb5/rfc3961_simplified.c b/crypto/krb5/rfc3961_simplified.c
index 79180d28baa9f..e49cbdec7c404 100644
--- a/crypto/krb5/rfc3961_simplified.c
+++ b/crypto/krb5/rfc3961_simplified.c
@@ -89,6 +89,7 @@ int crypto_shash_update_sg(struct shash_desc *desc, struct scatterlist *sg,
 
 	sg_miter_start(&miter, sg, sg_nents(sg),
 		       SG_MITER_FROM_SG | SG_MITER_LOCAL);
+	sg_miter_skip(&miter, offset);
 	for (i = 0; i < len; i += n) {
 		sg_miter_next(&miter);
 		n = min(miter.length, len - i);
-- 
2.39.5



