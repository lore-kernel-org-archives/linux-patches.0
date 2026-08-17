Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662864457D3;
	Mon, 17 Aug 2026 14:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977464; cv=none; b=IelkLSITEKBw5adVfJLOn6nXDHIn/nc8xyMsPFHaVqJWAX0qpBl0RH7ImjPUKNac31AyNiLfM2clMddxViqYDasnkpeW00dyHyT5aonpbzJ/DPS/6peBFfv1WyQQFhchv3+j3/cBOMm38HCR5SHxCvx12VMDZG2+M5WA2HMC+Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977464; c=relaxed/simple;
	bh=RZ5eG0fHhezGlBD3bZZRBBGgcJo/kmkor43MYgmIR6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dN00vc7su0UUIde6MYx4dVeVb3K5T9UKrw0iZLIF4p+wjClljhp+rugnQDHT9weFtEZzxYtrjNXSD4zo47AzVV9Gz1YkGzK9+CrYxMu2JTQg6JcQX3ENUPW6mqqez3SmwSbKWURzrs7rGP9U4H0zQ3cZasqlhreWdVrqo37Pl2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFB0Xjab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFB0Xjab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1E51F000E9;
	Mon, 17 Aug 2026 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977463;
	bh=fxaSZhCDmTcw6jrcJaalVid4FRksDx741m0PdaKwkkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFB0Xjab2nCisV/4lKbS1c/fIJXiHqogmuSHzn/LpwA/wH4EReiU2+dcdIXaC+FK2
	 f361Y65jZvpEP811YhG9zjPqs/6WKEvtfkfvKb8b4mHyz6xBF1V7UcGT49OEe3zoDC
	 918u9uZ4jzTzXeYQLH29MlSrQtwapH6BEJSlLjIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 338/456] s390/zcrypt: Validate length for CCA ECC private key requests
Date: Mon, 17 Aug 2026 15:32:08 +0200
Message-ID: <20260817132552.826470535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


