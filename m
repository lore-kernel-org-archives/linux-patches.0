Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C741170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81B6C433C9;
	Mon, 11 Sep 2023 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440391;
	bh=jEts0mPqEXbAXuDYlR3zoLhxeUw9Yf176uTiNfiSX0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drCIwrf5GtcpVi93rkPf5URrQch3cy7mynO2K7kanWDDCiOMLP5jxJKvgYW6zSbk7
	 5ccF4TW8nAjyo52Ndz/e83aZwN3VQfpBdFzN0xgDLq2rM2+NxT9n7zRpmGvaazsjag
	 jkJIE3n9VRFvXq3avT5aCkqqmY7YDq6aBPMCcVqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 044/739] s390/pkey: fix/harmonize internal keyblob headers
Date: Mon, 11 Sep 2023 15:37:23 +0200
Message-ID: <20230911134652.349810478@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Dengler <dengler@linux.ibm.com>

[ Upstream commit 37a08f010b7c423b5e4c9ed3b187d21166553007 ]

Commit 'fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC
private keys")' introduced PKEY_TYPE_EP11_AES as a supplement to
PKEY_TYPE_EP11. All pkeys have an internal header/payload structure,
which is opaque to the userspace. The header structures for
PKEY_TYPE_EP11 and PKEY_TYPE_EP11_AES are nearly identical and there
is no reason, why different structures are used. In preparation to fix
the keyversion handling in the broken PKEY IOCTLs, the same header
structure is used for PKEY_TYPE_EP11 and PKEY_TYPE_EP11_AES. This
reduces the number of different code paths and increases the
readability.

Fixes: fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC private keys")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c        | 2 +-
 drivers/s390/crypto/zcrypt_ep11misc.c | 4 ++--
 drivers/s390/crypto/zcrypt_ep11misc.h | 9 +--------
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index e58bfd2253231..ba8581e0809cd 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -895,7 +895,7 @@ static int pkey_verifykey2(const u8 *key, size_t keylen,
 		if (ktype)
 			*ktype = PKEY_TYPE_EP11;
 		if (ksize)
-			*ksize = kb->head.keybitlen;
+			*ksize = kb->head.bitlen;
 
 		rc = ep11_findcard2(&_apqns, &_nr_apqns, *cardnr, *domain,
 				    ZCRYPT_CEX7, EP11_API_V, kb->wkvp);
diff --git a/drivers/s390/crypto/zcrypt_ep11misc.c b/drivers/s390/crypto/zcrypt_ep11misc.c
index 958f5ee47f1b0..d7ecd6ce5b7a7 100644
--- a/drivers/s390/crypto/zcrypt_ep11misc.c
+++ b/drivers/s390/crypto/zcrypt_ep11misc.c
@@ -787,7 +787,7 @@ int ep11_genaeskey(u16 card, u16 domain, u32 keybitsize, u32 keygenflags,
 	kb->head.type = TOKTYPE_NON_CCA;
 	kb->head.len = rep_pl->data_len;
 	kb->head.version = TOKVER_EP11_AES;
-	kb->head.keybitlen = keybitsize;
+	kb->head.bitlen = keybitsize;
 
 out:
 	kfree(req);
@@ -1055,7 +1055,7 @@ static int ep11_unwrapkey(u16 card, u16 domain,
 	kb->head.type = TOKTYPE_NON_CCA;
 	kb->head.len = rep_pl->data_len;
 	kb->head.version = TOKVER_EP11_AES;
-	kb->head.keybitlen = keybitsize;
+	kb->head.bitlen = keybitsize;
 
 out:
 	kfree(req);
diff --git a/drivers/s390/crypto/zcrypt_ep11misc.h b/drivers/s390/crypto/zcrypt_ep11misc.h
index a3eddf51242da..67cc80d71ba3b 100644
--- a/drivers/s390/crypto/zcrypt_ep11misc.h
+++ b/drivers/s390/crypto/zcrypt_ep11misc.h
@@ -29,14 +29,7 @@ struct ep11keyblob {
 	union {
 		u8 session[32];
 		/* only used for PKEY_TYPE_EP11: */
-		struct {
-			u8  type;      /* 0x00 (TOKTYPE_NON_CCA) */
-			u8  res0;      /* unused */
-			u16 len;       /* total length in bytes of this blob */
-			u8  version;   /* 0x03 (TOKVER_EP11_AES) */
-			u8  res1;      /* unused */
-			u16 keybitlen; /* clear key bit len, 0 for unknown */
-		} head;
+		struct ep11kblob_header head;
 	};
 	u8  wkvp[16];  /* wrapping key verification pattern */
 	u64 attr;      /* boolean key attributes */
-- 
2.40.1



