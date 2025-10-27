Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2392F5A1B;
	Mon, 27 Oct 2025 19:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593156; cv=none; b=mK6cYNAiFdXHM1qr/mjE3GNzPkgYM5aSLZpzw95RhONdnpvNEYT/5U5JSbhaRowBZtPADRxd2fKt8RtN62jnXAy6Pht8LTIWfUcwG5omhya2mhaV2hMUjyNMez+GcJGPMRTkQ1BIdr9BgVkF8McqhHVtxLNucdhHimwnmuWdW/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593156; c=relaxed/simple;
	bh=iiskUz0AnLKbMCxmUBTetguHKV7XvzM9roT5R+7nu/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwOOGmzcXQJ3fflYlRbkHp7sQrQhUCVnyHAznuG2P81CD4CKny0Zr/bEKG0s/A97sLWJOeZPQiXsKUJLHpPuYm0aBIK0qcrIJAnzPqX9O4x4pxvdeM+EUNAQVBlkLrwOwAisNzNHLrN7D9JvDkHJieykAXHVM1J365sQSR8oFKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOORuS7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOORuS7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49E6C4CEF1;
	Mon, 27 Oct 2025 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593156;
	bh=iiskUz0AnLKbMCxmUBTetguHKV7XvzM9roT5R+7nu/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOORuS7t9x7+0/UBTEJxLGqXicX72g7k5tJNU/lTCSzsUthsFRzSsgth8O4YDzV6v
	 IlwP+iBt7KgJWqbOH2fLzhh+SZKuU08yGMmNLFyR47th4DFFapf35b9/y996TYiWGn
	 VB0BlpW30arYVgrgnsqJ4sQzoP9gtTngEc8GtoCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 008/184] s390/pkey: Forward keygenflags to ep11_unwrapkey
Date: Mon, 27 Oct 2025 19:34:50 +0100
Message-ID: <20251027183515.162204780@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 11aa54ba4cfa5390ea47c9a1fc62502abce1f6b9 ]

The pkey ioctl PKEY_CLR2SECK2 describes in the pkey.h header file
the parameter 'keygenflags' which is forwarded to the handler
functions which actually deal with the clear key to secure key
operation. The ep11 handler module function ep11_clr2keyblob()
function receives this parameter but does not forward it to the
underlying function ep11_unwrapkey() on invocation. So in the end
the user of this ioctl could not forward additional key generation
flags to the ep11 implementation and thus was unable to modify the
key generation process in any way. So now call ep11_unwrapkey()
with the real keygenflags instead of 0 and thus the user of this
ioctl can for example via keygenflags provide valid combinations
of XCP_BLOB_* flags.

Suggested-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_ep11misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/zcrypt_ep11misc.c b/drivers/s390/crypto/zcrypt_ep11misc.c
index 3bf09a89a0894..e92e2fd8ce5da 100644
--- a/drivers/s390/crypto/zcrypt_ep11misc.c
+++ b/drivers/s390/crypto/zcrypt_ep11misc.c
@@ -1405,7 +1405,9 @@ int ep11_clr2keyblob(u16 card, u16 domain, u32 keybitsize, u32 keygenflags,
 	/* Step 3: import the encrypted key value as a new key */
 	rc = ep11_unwrapkey(card, domain, kek, keklen,
 			    encbuf, encbuflen, 0, def_iv,
-			    keybitsize, 0, keybuf, keybufsize, keytype, xflags);
+			    keybitsize, keygenflags,
+			    keybuf, keybufsize,
+			    keytype, xflags);
 	if (rc) {
 		ZCRYPT_DBF_ERR("%s importing key value as new key failed, rc=%d\n",
 			       __func__, rc);
-- 
2.51.0



