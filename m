Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377F842AF95;
	Fri,  7 Aug 2026 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117519; cv=none; b=Z4EU64TGkx4pxfXW34nIMxRCqS1B6swNkgAXFebXih60pX0HWN77ojbUubKZduG54ymLE0PDp+S3IiRLLWyjiTqqWPYcwTZyApYO87lR8yzimHs1MBbq/HG5Y0RBAGv18s99TIempVcZSSz5fBOavv8BR9bDKwJ8PUPNDh24Pu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117519; c=relaxed/simple;
	bh=CAo9pPoF/2XYMpbe0g36l99oXqhO0vLQwfX1RV2IqzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaB2uFPP4C9SG1h8iac6ipGMZX829aoLdVLBMShZ6vdR7LwmAyHf6syLDz8zzb2W0lHoqWvop+LZEA8dJNZu7leK9YfXlP4M40184qAF+JNIvAO5u+gRfP025e9ILM5QZjG6Iavhjnl4iMHd3h4oalGQ7bf/cvaeSZAc4wg0Ahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaQx8ALM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaQx8ALM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0551F000E9;
	Fri,  7 Aug 2026 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117518;
	bh=q81nFp7jst0OLd21oJ3X8C5MFcgqBkoje5lYJoggC6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaQx8ALMk+m5xh1w364LtHN2t4K1dkWrtLigf0ylMYcf/1ilGooC4PPHtJry8oJGB
	 EuZW7YHQaFeI1QBBsrdSawBoxEoGA/mO2BaD+8Ou7GzBnounqRuSHqppdPUyM+CcS7
	 9l+NFJiRpGSiQB48Ws+yFe+SDGbf/ZlBFkNzri80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 345/438] s390/zcrypt: Validate length for CCA AES cipher key requests
Date: Fri,  7 Aug 2026 16:39:01 +0200
Message-ID: <20260807143435.329275599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1312,6 +1312,9 @@ int cca_cipher2protkey(u16 cardnr, u16 d
 	} __packed * prepparm;
 	int keytoklen = ((struct cipherkeytoken *)ckey)->len;
 
+	if (keytoklen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem,
 				    &preqcblk, &prepcblk, xflags);


