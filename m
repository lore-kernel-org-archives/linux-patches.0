Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA7FF9F3
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9737AC433C8;
	Mon, 11 Sep 2023 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440453;
	bh=LMtISV337OFr4YN3ZIeY+rSIlfXikcpzSuXJoBHaE8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksyFP9JW3RdzQpuC5pM7SkeSAG2BwuSDrMgy93Q4oc3dtYILq3JR8OcJ+PxR+lo6P
	 xiYWO0LDfbgFFjpZH0jZ/6vGsZmaguRvEpaUMo5wSF9wNAeKed2KH3clL3ryw99Z8K
	 E/MN1C+OkbKqlMKj5Mj46UwSRqVOw3E1f3hWl34A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 049/739] s390/pkey: fix PKEY_TYPE_EP11_AES handling for sysfs attributes
Date: Mon, 11 Sep 2023 15:37:28 +0200
Message-ID: <20230911134652.489926170@linuxfoundation.org>
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

[ Upstream commit b9352e4b9b9eff949bcc6907b8569b3a1d992f1e ]

Commit 'fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC
private keys")' introduced a new PKEY_TYPE_EP11_AES securekey type as
a supplement to the existing PKEY_TYPE_EP11 (which won't work in
environments with session-bound keys). The pkey EP11 securekey
attributes use PKEY_TYPE_EP11_AES (instead of PKEY_TYPE_EP11)
keyblobs, to make the generated keyblobs usable also in environments,
where session-bound keys are required.

There should be no negative impacts to userspace because the internal
structure of the keyblobs is opaque. The increased size of the
generated keyblobs is reflected by the changed size of the attributes.

Fixes: fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC private keys")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/uapi/asm/pkey.h | 2 +-
 drivers/s390/crypto/pkey_api.c    | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/uapi/asm/pkey.h b/arch/s390/include/uapi/asm/pkey.h
index 5faf0a1d2c167..5ad76471e73ff 100644
--- a/arch/s390/include/uapi/asm/pkey.h
+++ b/arch/s390/include/uapi/asm/pkey.h
@@ -26,7 +26,7 @@
 #define MAXCLRKEYSIZE	32	   /* a clear key value may be up to 32 bytes */
 #define MAXAESCIPHERKEYSIZE 136  /* our aes cipher keys have always 136 bytes */
 #define MINEP11AESKEYBLOBSIZE 256  /* min EP11 AES key blob size  */
-#define MAXEP11AESKEYBLOBSIZE 320  /* max EP11 AES key blob size */
+#define MAXEP11AESKEYBLOBSIZE 336  /* max EP11 AES key blob size */
 
 /* Minimum size of a key blob */
 #define MINKEYBLOBSIZE	SECKEYBLOBSIZE
diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 8d6f35ccc561d..396a159afdf5b 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -2142,7 +2142,7 @@ static struct attribute_group ccacipher_attr_group = {
  * (i.e. off != 0 or count < key blob size) -EINVAL is returned.
  * This function and the sysfs attributes using it provide EP11 key blobs
  * padded to the upper limit of MAXEP11AESKEYBLOBSIZE which is currently
- * 320 bytes.
+ * 336 bytes.
  */
 static ssize_t pkey_ep11_aes_attr_read(enum pkey_key_size keybits,
 				       bool is_xts, char *buf, loff_t off,
@@ -2171,7 +2171,7 @@ static ssize_t pkey_ep11_aes_attr_read(enum pkey_key_size keybits,
 		card = apqns[i] >> 16;
 		dom = apqns[i] & 0xFFFF;
 		rc = ep11_genaeskey(card, dom, keybits, 0, buf, &keysize,
-				    PKEY_TYPE_EP11);
+				    PKEY_TYPE_EP11_AES);
 		if (rc == 0)
 			break;
 	}
@@ -2182,7 +2182,7 @@ static ssize_t pkey_ep11_aes_attr_read(enum pkey_key_size keybits,
 		keysize = MAXEP11AESKEYBLOBSIZE;
 		buf += MAXEP11AESKEYBLOBSIZE;
 		rc = ep11_genaeskey(card, dom, keybits, 0, buf, &keysize,
-				    PKEY_TYPE_EP11);
+				    PKEY_TYPE_EP11_AES);
 		if (rc == 0)
 			return 2 * MAXEP11AESKEYBLOBSIZE;
 	}
-- 
2.40.1



