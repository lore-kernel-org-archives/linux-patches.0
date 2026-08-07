Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A40380FCA;
	Fri,  7 Aug 2026 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114304; cv=none; b=i0hAvKda4Eq0YINiKfig+/bS3/j5YGYkpIfxPr4R4IP92oIfv8gVP9rdSLUbpzoc8+fCnZ1j8qM7SPfXd4VMxRlhXOGownf7eqFXkvMm1gTT4jTP+lVfqbahY1WXHhAxoC040RIAjIP1D7BQfICLPVM7ezwsuPRX8dqcefcfd4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114304; c=relaxed/simple;
	bh=VCR/Ba7fh2GMeMeto6VPW5IWdvrxWY/Kx2vdFlGUhwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IobFzy42HpbPLcu1Rd9+jQmbqqVj/EvSMBA363yeyQVZ0xz/lGSxxdJeXiqG+qXsigWCAT0s+bc0WihWG7uOS6KLIdcHki31wxTMffqq4JMAF6RN+T7VoNBrAuBIPiFVUN9eGhcnFJ633LDqSF3N6RwHxZujxAKH5z74hBLrN6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0biUtaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0biUtaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955971F000E9;
	Fri,  7 Aug 2026 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114303;
	bh=VYp3k2D9H+Er5HfR29guodrLkyy1V0S/VL+r3J/JveQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0biUtaSP6RfKz+q+Ock3eeRqctL3qKBU8jkNGIpt/6jgpnzQvl7dbvGchB/GYlwb
	 iaoxoR3DM5fxA2Opjawg8vXj8HPuQYixeabwD29RJZCGZ0m9hPCvM95RO/x/fvqQ0i
	 7/U+8+evSjN5DvTQ+ZMPxKm8xmlNhe7GcJ+uf8Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 214/337] s390/zcrypt: Validate length for CCA ECC private key requests
Date: Fri,  7 Aug 2026 16:36:57 +0200
Message-ID: <20260807143423.192361718@linuxfoundation.org>
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
@@ -1384,6 +1384,9 @@ int cca_ecc2protkey(u16 cardnr, u16 doma
 	} __packed * prepparm;
 	int keylen = ((struct eccprivkeytoken *)key)->len;
 
+	if (keylen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
 	if (rc)


