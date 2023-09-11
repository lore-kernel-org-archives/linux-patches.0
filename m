Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14751170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB49C433C7;
	Mon, 11 Sep 2023 13:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440422;
	bh=u2mAFRkqG0LaPcxyd8hGcM31BgmaXykQ2wzdQ8+trCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBzDtfdTjMQLLMHXVf7eAWj2U/WtZiCzlw6jVDZiJy2HaSP0OL1DKvHNAaNQQGRH9
	 q1IylU4U8GrTC5/Ey8OevmyjQHDyQiTM0cY7PQLCqg6je36DgjIhwqiMcZgLSbpapF
	 2IC095yl0cutVdzRke51Nx9z9AT/TJot7zPpk3LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 048/739] s390/pkey: fix PKEY_TYPE_EP11_AES handling in PKEY_VERIFYKEY2 IOCTL
Date: Mon, 11 Sep 2023 15:37:27 +0200
Message-ID: <20230911134652.462107024@linuxfoundation.org>
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

[ Upstream commit 745742dbca11a1b63684ec7032a81aaedcf51fb0 ]

Commit 'fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC
private keys")' introduced a new PKEY_TYPE_EP11_AES type for the
PKEY_VERIFYKEY2 IOCTL to verify keyblobs of this type. Unfortunately,
all PKEY_VERIFYKEY2 IOCTL requests with keyblobs of this type return
with an error (-EINVAL). Fix PKEY_TYPE_EP11_AES handling in
PKEY_VERIFYKEY2 IOCTL, so that userspace can verify keyblobs of this
type.

Fixes: fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC private keys")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 75d7f0d5f14ef..8d6f35ccc561d 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -912,7 +912,8 @@ static int pkey_verifykey2(const u8 *key, size_t keylen,
 			*ksize = kb->head.bitlen;
 
 		rc = ep11_findcard2(&_apqns, &_nr_apqns, *cardnr, *domain,
-				    ZCRYPT_CEX7, EP11_API_V, kb->wkvp);
+				    ZCRYPT_CEX7, EP11_API_V,
+				    ep11_kb_wkvp(key, keylen));
 		if (rc)
 			goto out;
 
@@ -922,6 +923,30 @@ static int pkey_verifykey2(const u8 *key, size_t keylen,
 		*cardnr = ((struct pkey_apqn *)_apqns)->card;
 		*domain = ((struct pkey_apqn *)_apqns)->domain;
 
+	} else if (hdr->type == TOKTYPE_NON_CCA &&
+		   hdr->version == TOKVER_EP11_AES_WITH_HEADER) {
+		struct ep11kblob_header *kh = (struct ep11kblob_header *)key;
+
+		rc = ep11_check_aes_key_with_hdr(debug_info, 3,
+						 key, keylen, 1);
+		if (rc)
+			goto out;
+		if (ktype)
+			*ktype = PKEY_TYPE_EP11_AES;
+		if (ksize)
+			*ksize = kh->bitlen;
+
+		rc = ep11_findcard2(&_apqns, &_nr_apqns, *cardnr, *domain,
+				    ZCRYPT_CEX7, EP11_API_V,
+				    ep11_kb_wkvp(key, keylen));
+		if (rc)
+			goto out;
+
+		if (flags)
+			*flags = PKEY_FLAGS_MATCH_CUR_MKVP;
+
+		*cardnr = ((struct pkey_apqn *)_apqns)->card;
+		*domain = ((struct pkey_apqn *)_apqns)->domain;
 	} else {
 		rc = -EINVAL;
 	}
-- 
2.40.1



