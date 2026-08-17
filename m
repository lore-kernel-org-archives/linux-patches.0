Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCB82E7BD6;
	Mon, 17 Aug 2026 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980052; cv=none; b=TRVM7WO5EztFHrdSyzIblPAoOCtBuy6ndjGaAaVYylY/PE+w+kMVhKiKvGtb9XrwiyV8eajZTj+MCqY1wx/6xK9Pby7KGrnoXqOtlMOp84SUf7SuB6U099zDNK1GlJ86Qd82HE9Fp3H6WAYe6FsGu9Q8dCsqmtAcQ7MG34zpdAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980052; c=relaxed/simple;
	bh=t7rEjYZXfEdlOuBdDhADqpCOjY7fEnZ1VUwq5Qk26sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEnPIwmV5pkzXdCzeR9jKiMtWMlvnzRnexHuyQJna0zGpgg0beDrkZbb79PP3VAO4j2zIl9+moXq+MybQV1WlMj3VGhv/h/f4hI6n1gn2cpClMdFAe88bzWYQ0piMMJrnZJxuxcHnj/IfHbEpHbGFR8PV4ey+/m5BshF9ErRPV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgK2hSU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgK2hSU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E2E1F000E9;
	Mon, 17 Aug 2026 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980051;
	bh=MVo3tBOhKujEnqfzS+IQC2b83k3i+geA1/ELPH3OLBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgK2hSU9XD/zpxDSvUxGLr8SkA0HmTu3+BOwrw0CX0sHFyI3pgAJKeaqKrjr5l/K9
	 gkHmFK5PL5OcfnHm2viBbag+qhRtYWFlp1IHAYK+4IX1OTvL3HrKhxeBJ5QqEPc3xt
	 c2C2m2vT/9Koaro0djsH10UhlVkNTr42wloMJfts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.1 438/609] s390/zcrypt: Validate length for CCA AES cipher key requests
Date: Mon, 17 Aug 2026 15:32:14 +0200
Message-ID: <20260817132558.757807976@linuxfoundation.org>
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


