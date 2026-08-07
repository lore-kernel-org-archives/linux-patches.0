Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4311B364028;
	Fri,  7 Aug 2026 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117522; cv=none; b=GaSU6bLG/58GUNdMUimJcMDO7paBv4a4nkf15vteE+YQzzuMv9gBOjr7D66Q53iB6Wmg/EafvRZFXiNkdQPK7mqXk0CTVYIUekW6Q45Lh4L0w608b2kcc0hkt0TY3x7UdKtIaqRk10x0CkLn5QQHuzYRh2mp4DnVjgw5T/D5hOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117522; c=relaxed/simple;
	bh=GVegokQgiMAhS+iLlf4k9SDj6bb4mzWPchVfPBhk2N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJHy8XyRq2IsBsauuqPBqux7D/hCHiEWXEIItGnU/j55Uq6Dpwe+CgqXwCXBZ5QOWzHJqwqKTP2bQcOjRSGEfKGYrK+rPYh4BL1+OrxGzsvsU95w0rlgs/6jlS5VmiMyNWdUhYDNn6P8NG0vL8vfF5W4+vfUzmh0w1sKCmBhGbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHTggyhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHTggyhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7971F000E9;
	Fri,  7 Aug 2026 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117521;
	bh=KcyVgUMQSZNb071L4u6PSUdwgv0gfmoFj2JRcOpBkPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHTggyhNccUcbPa8vsrZBmhTFPiMQa66SUpIv+RFwaeifGLLd9lEyjaW3bc5BPxPB
	 5xDSulNQxrBuzpz24kEpPluWUbzstaXM0dkO3vD7AzUihcOY/lPwVbBOaFo2jvb7h2
	 8CX4CBHxx/dBNvv2cq/T9DTR+EVUTTaZe2B4r8RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 346/438] s390/zcrypt: Validate length for CCA ECC private key requests
Date: Fri,  7 Aug 2026 16:39:02 +0200
Message-ID: <20260807143435.349979835@linuxfoundation.org>
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
@@ -1479,6 +1479,9 @@ int cca_ecc2protkey(u16 cardnr, u16 doma
 	} __packed * prepparm;
 	int keylen = ((struct eccprivkeytoken *)key)->len;
 
+	if (keylen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem,
 				    &preqcblk, &prepcblk, xflags);


