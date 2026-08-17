Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0722EC0B0;
	Mon, 17 Aug 2026 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976293; cv=none; b=V6iE5c7wb6mM3oL3bRJBfbHFFYec285plCCDPIsTJ/hm9wsGbvwbh+Rcaj6yO5dFZwUmEo59fFfu5XD9GTy52ZOmFKyJXGeC2SSxDnWNtsQwA8e7jnRRzViB4WK3VuWLybB26hiP88vu5iIOTFRFO3kD3eDeYkCAeKcEDaiOkxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976293; c=relaxed/simple;
	bh=M4nYmY83dZdLlfY0Narb5Wg7FxuCJ2Npfr7rEzTCrX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQjkYmwrPBAVQIS419M4udMbmAVSuf5ChmloyM7oe6PFYoMck0UFcD8uKwPKT1vx8PFowDHCaJIIyvFPj6I2q6xpDjmSsBcHYhvrIzSusR/jG45EbcN2+DoZ88UXC/PZn0LXYtMWKls9Fgyy/ONrml9YIU2ldJeif6QySJuSKx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvFGB6hL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvFGB6hL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6431F000E9;
	Mon, 17 Aug 2026 14:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976292;
	bh=lSYCtjCWvbqiatSelfH3y8bpNTmGXDADMtuoot44dV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvFGB6hL8n5zrxjczpsWjlcsHPXR56T/PmZFe8O4KSxgjo6FWYzb55knXIKAs+7A0
	 /z84/zv0E5hREDsqiGzH7Y+OCytxzJTJaNhD6B1Bbkev9ntQ+UFXmfiF1gDoMcHcHa
	 SeStRVYhSCF557WFy/z2GKCtR2ekkiJcScxrsmPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 283/389] s390/zcrypt: Validate length for CCA AES cipher key requests
Date: Mon, 17 Aug 2026 15:32:02 +0200
Message-ID: <20260817132550.156389963@linuxfoundation.org>
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
@@ -1229,6 +1229,9 @@ int cca_cipher2protkey(u16 cardnr, u16 d
 	} __packed * prepparm;
 	int keytoklen = ((struct cipherkeytoken *)ckey)->len;
 
+	if (keytoklen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
 	if (rc)


