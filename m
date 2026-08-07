Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B54364941;
	Fri,  7 Aug 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114301; cv=none; b=jnxR3tBbVA9LSkgoD/klQbY9OUE2keOuePWs+QCQON92K10RHAwGt4cW/MyfnIdLH43+QWkx13jhhc/qLg1efzyEe4APpn4ncuOZAwD56ri4jhqOxzuh24NyekBEuDUjeNide/chReqg06zAIs8/gTK+yFvtLwrBN7XGmjnHvIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114301; c=relaxed/simple;
	bh=BQynxRtX9/P82uXGvHadflPw3aF2DS5Uf5lIdj2jZk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVbHBKceLmLKuIfQzhjRWwUC+krIOMPf9Oo3cf5f2zhCNzkeHiNyN+nwRYeXcAmVYFAC2d+qHEJWjyLPYmr60BIGG2Gtr083TlxTSqOQWxcqquLCnnuBJk4YR85/SLoladSA2W6FRBCVenVQtUfKjbZz/yvzwN7sPmzxjDxlIEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R64GxR+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R64GxR+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4231F000E9;
	Fri,  7 Aug 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114300;
	bh=mJnZ6TlUz3D2W/qRiZgHl7pdNAnc/zLVJQ9qnDIidmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R64GxR+h4lEmaeRse4lyJ3vxKgIhW3EvCPk+1pEYlpn2nyL2TYc8px8gRjKVIERnh
	 FIkynn7JqJT9x/LKmv7L+IEZaWwAtrdTpFHjf4DXpWuR6eLX6TdSbBx7GJlKsoldZK
	 wdM2iQjpsHjxN7Bp7GBfxpRR2Jr/KPAIXTfZTxEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 213/337] s390/zcrypt: Validate length for CCA AES cipher key requests
Date: Fri,  7 Aug 2026 16:36:56 +0200
Message-ID: <20260807143423.172157743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Dengler <dengler@linux.ibm.com>

commit 06afe425d5283b9764303de47f554da5a808ce8a upstream.

cca_cipher2protkey() derives the copy length for the CPRB parameter
block directly from the length field in the key token. Reject the
request early if the token length exceeds the available space in the
parameter block.

Fixes: 4bc123b18ce6 ("s390/zcrypt: Add low level functions for CCA AES cipher keys")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.4+
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1218,6 +1218,9 @@ int cca_cipher2protkey(u16 cardnr, u16 d
 	} __packed * prepparm;
 	int keytoklen = ((struct cipherkeytoken *)ckey)->len;
 
+	if (keytoklen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
 	if (rc)


