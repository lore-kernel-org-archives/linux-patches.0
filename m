Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B17E44236A;
	Mon, 17 Aug 2026 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980055; cv=none; b=fxDqSeP73NYSEDm3+uwwC4YhC7ACX71rdK1aJRbxzqdi3i1IOXJthsz95S4LoZS9JjhIdrasa3NMpSkq86HvQlcpRup6xd/6yZyr/9o5Wwe8g7qcp5GmgaJiWrCOLvS/S7W3i0EKi5AtiZvapQmrVlJJ62eTpu6NlK5u5JynWyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980055; c=relaxed/simple;
	bh=oNlkWidXdFicfnhgijmdTzsIlsiBSlVj5b/kU/eu9+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lN97d13ZTRsKYUSLtbBKH/WTmPFS5mHlIAtBy3RHDufnNLwZHPVSKpRzAb+TT0ud9gkeLOgM5Q5fIG6nxeJuDkfE8JHYLhcnbB4LlimMgBiWv0h6LGCvappFhpjm9kYj91fux+D4mbOMfRZz8Mbqq968aGXW6q61eG0a1YqiSZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/Ebt1A4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/Ebt1A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7543C1F000E9;
	Mon, 17 Aug 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980054;
	bh=a9nd/T3ul+EeAqDidni1tvC7etE8168zqv5EuoPhJds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/Ebt1A42H/s8akJtzmjbloo7OcZQQ7bkqfqs8qjuA39KjZhVXbxWz4vei78ikUxG
	 pQBbi5CP1AEUZfWIhqjtvGxWEoBfl5uB+VGgvmDksgiPiJrCOZVzqrv24bsw6LwcZF
	 B6FaKDDc7Zlc22fcypJNJ5uEEwFjYaClAkBwoXaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.1 439/609] s390/zcrypt: Validate length for CCA ECC private key requests
Date: Mon, 17 Aug 2026 15:32:15 +0200
Message-ID: <20260817132558.790625496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1404,6 +1404,9 @@ int cca_ecc2protkey(u16 cardnr, u16 doma
 	} __packed * prepparm;
 	int keylen = ((struct eccprivkeytoken *)key)->len;
 
+	if (keylen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
 	if (rc)


