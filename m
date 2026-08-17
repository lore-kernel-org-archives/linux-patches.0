Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4709265621;
	Mon, 17 Aug 2026 14:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976296; cv=none; b=ElrFep2+MgaHSTTfnzds2cF3/CBCGiclO3rx5M4IcBLRnFFLetqm5nzd+nrzv44lg+ad4xZT7nrFJ5GzK1Jaom75r/CdEs1Xy+z6FOrPNM8TPGeHtbLmq0s5qabsDECip09pRCfDwANudmZ59nWn8hxCK21KoqwzHQAaE/KlCWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976296; c=relaxed/simple;
	bh=kc4FRPKN64ULzrjeQiCZIUIXY+Y/zu8Z5pYdtQNh1co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maTss9Rr9jPBgbSR8cLfLZSHUhbEb81zYk46pc6BBatITPGyYRPbaiRJQ10s//22XKD2LagKCnuKTgAWhoxLJMc3Eipc1pe6HA1PFOpmxCydjWZYlCkgNb8foE9l0icKtkg+2Xc7w7TyEqL1XGC2LGae6j+FdGTCmknpo/JPePo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfJY6mOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfJY6mOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B6B1F000E9;
	Mon, 17 Aug 2026 14:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976295;
	bh=Dpv5sqMrjP2L4hUfVA8h19ZatAX6noFstt48mv7y+jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfJY6mOJ5gBG3IKWi6goQSmutALAcSeIl8cMZRX6dsGMPEbPhKBVIJLtfAVPuXMoA
	 VSv+EZGOK4yYL+zhUIwHxDmA+wiuNQZp+YjBlN8PjBB1rgHLvnOfOcrNYBzemM0M3D
	 gsDVkpBkQA0EOVPe/JcUFHRNSw4ouQ8F6dBlA17k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 284/389] s390/zcrypt: Validate length for CCA ECC private key requests
Date: Mon, 17 Aug 2026 15:32:03 +0200
Message-ID: <20260817132550.192645132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1398,6 +1398,9 @@ int cca_ecc2protkey(u16 cardnr, u16 doma
 	} __packed * prepparm;
 	int keylen = ((struct eccprivkeytoken *)key)->len;
 
+	if (keylen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
 	if (rc)


