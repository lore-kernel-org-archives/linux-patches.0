Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24E71C84D0;
	Fri,  7 Aug 2026 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116235; cv=none; b=jojSIT/N/ZeqcBvVmGLHb5xCChfICKIemsMgOukR18m1ixmPclnOxD+OXbxY7KACIzBO0o7PV5wB3RkmbNdgqpn63VEdYmLARh6sO+9Cic4ojF4mjQwEvGvjiYEwgQBKdkZuy7wL8plKeI26Npdit8Pv0nuS1SIVVj2BrVqAgmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116235; c=relaxed/simple;
	bh=cOFM1sEFP/l7j9Jqr78pdErByaxh9aEh0uNXUtY/6M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UImhiY3rfUZGg58XCock0xsGciZj+n4V/aCn0809XJi/7TMXxVVwmViVbkCEu8oHWn96SpMMV95hKpQX/uhj723tRsFl0mGjgEVKiFYAx/xdAA5Oaz8+TIxXkDNqWa99Hts+vG9WaT1FMm0AaMQXezJwCrPvyv6h1qJK+6XAGa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTO3mJ3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTO3mJ3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5881F000E9;
	Fri,  7 Aug 2026 15:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116234;
	bh=D0ePMmZT1uHTRZR21gdVsUL0+66dpuj7VzV3DZHHCvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTO3mJ3YbOJ3cjKPsN5mJBKKCZUF40bUTs1cAoYfg64aBWo0fOK/CZH9U8dy26k6Z
	 UhVZ38rEf1rla4vMZEhR83wn2klvO0yGdR+n62Iwowz5JAqc/Tpf7VENdFmZ1RKPAG
	 2yLlIRSqhKdrLNjSZxbZ0XSg+WiH0yJOBu8untcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 158/261] s390/zcrypt: Validate length for CCA ECC private key requests
Date: Fri,  7 Aug 2026 16:38:35 +0200
Message-ID: <20260807143418.776466919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1402,6 +1402,9 @@ int cca_ecc2protkey(u16 cardnr, u16 doma
 	} __packed * prepparm;
 	int keylen = ((struct eccprivkeytoken *)key)->len;
 
+	if (keylen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
 	if (rc)


