Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FDF3EC699;
	Mon, 17 Aug 2026 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977462; cv=none; b=WzluY06iTjQb3IgOUqKFQiPpaff04G4IS+/2ZeYOPLuXguNC6zj6Bsz9MMSLCYrc+olQ2bulSQpoYp1LfUmdmbu6b0E2wK0CmsmZ/eoOYAQn/ZY5kXvtXgcR7Wu9+xw/zTkD+I06mPsMm2NxjHLDUw0V75tVWOyiAemzjFHTdn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977462; c=relaxed/simple;
	bh=FW1jycKmzwdZmEhy7j96VX848D+CZ6dNcRhBF9yDN5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tigkbibpJbvSu6qCDLmWEizYucd2q/X2sEI8ylvnHY/pnAktDRloK8t54edUJMm7ME9q15D2KSpE/w0c/BkSyOSAwh4pAUVWXl5EkqMcyPVZXmG91VWrzGKYLSBrnTogb2dElhw038JOxJbqUK1C5Tefg9LD7712ThF8Jz4iSpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOoxTqWA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOoxTqWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE10A1F00A3A;
	Mon, 17 Aug 2026 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977460;
	bh=wJeqW85WRqK80r7ZudnT4GDhyrf+KzKmvvIQPe1lmEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOoxTqWAv4Zo1Ye3NiaZtV6ibopemUAlLpyzh9N/Kmel8Q5z2SAyEHCZkbQ/Ltt/e
	 /13bTT6NiOB+JBgHXb1KDQhEssLiS6bEO9+HYXD+yyHVrf8cNfu/49tEnSRMcggyJt
	 cVEOSTLzCjO0HwyDZluljdDANxiDZPdj60irP3sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 337/456] s390/zcrypt: Validate length for CCA AES cipher key requests
Date: Mon, 17 Aug 2026 15:32:07 +0200
Message-ID: <20260817132552.792717720@linuxfoundation.org>
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
@@ -1232,6 +1232,9 @@ int cca_cipher2protkey(u16 cardnr, u16 d
 	} __packed * prepparm;
 	int keytoklen = ((struct cipherkeytoken *)ckey)->len;
 
+	if (keytoklen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
 	if (rc)


