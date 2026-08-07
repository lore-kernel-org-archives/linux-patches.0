Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39B31A681E;
	Fri,  7 Aug 2026 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115449; cv=none; b=m2LzyKRjJ5R9tpSTIGGnP1y7EJbbbTcNu2UcWfW79BuLZ1OSPsUJU5SMDnfLtlMRwH9Z9V6cE3NDGr4Fxjt4GwYYiVQFxxp9YaqlryZzS+4kfoMXzb8wzQeBAhk/iia9qlJ7ewDYzUM+6f9l18iKlAGHzVKoEy3ip+RKqxxEltc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115449; c=relaxed/simple;
	bh=5xhQh4vVaYJhCF40lLB+LhBhmcJX+89QL+3tmQAKugM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM+V/V11QINsLvwzuqdI4jdlcmeXlFJ7y6ZNidJ1ktE5GUqP7NMPgW7sZxUnPyU3nn6amZnYNqPgh1A0jMoz+C8P1obNfpFC1rX6+xnL+9Sff3V6HdMqq1wd68KtHEFtpZYRgmK1JqnjinPW5r1Zj5RWjo7BXdrOwBPWP2+cb74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik4AmgCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik4AmgCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC7B1F00A3A;
	Fri,  7 Aug 2026 15:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115447;
	bh=ajBkrnR0HBSSTEkyGSTLYjiUTdjLUvzeqmYXAVKWYzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ik4AmgCjskXcYE+pkmQEdBj942KHWhdrOIFxyLy98fIn++gnoeBrYyjF9zI9B/m+t
	 lqoXAC9ijZf4O0OgVHL5O9Jf3iiC4IJs3chLAeg4jyQ/okgpeCcSw42oOtMe2Y4fWO
	 tM528xKBNcs8Gy9j1hqZGxFE6PTl/30xJIqQGzm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 278/396] s390/zcrypt: Validate length for CCA ECC private key requests
Date: Fri,  7 Aug 2026 16:37:18 +0200
Message-ID: <20260807143430.252179455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Dengler <dengler@linux.ibm.com>

commit a9ae0f6dd45c3ccc1d69363f7aea8af179122730 upstream.

cca_ecc2protkey() derives the copy length for the CPRB parameter
block directly from the length field in the key token. Reject the
request early if the token length exceeds the available space in the
parameter block.

Fixes: fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC private keys")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.10+
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1480,6 +1480,9 @@ int cca_ecc2protkey(u16 cardnr, u16 doma
 	} __packed * prepparm;
 	int keylen = ((struct eccprivkeytoken *)key)->len;
 
+	if (keylen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem,
 				    &preqcblk, &prepcblk, xflags);


