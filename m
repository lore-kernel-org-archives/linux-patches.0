Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035082;
	b=14CipAS6/go8vh7DLGCZoUZ1i4Ja0U6j54jQu6Wp851C7BEMFLaOFX6Bv5+uzyNLmkg9
	 QJX4u6MRLqIBLNbRT98tP3WLFctepQisgR+ygoV3PXdqwYz35Ogbop+CnqSZzHw8c0x5+
	 QcLB/QfQ02R5SbJcomxgcrQ72oeZFb3z3W5wq8oEyUYN2G0Y/CIZInhSk3Bzl4zxnNHEx
	 XjOBUeT6pkHMJTiieD+3e+etHS4eFoetCbQHdavn3nv91c8buepkFSVFzSGr2a6pVybsd
	 ARlXvZXd52slqyVPCln95ICyg0kzsz6ghpdUJ1IwD3wr2VrYYVjvBIDVkIfiUNgqAsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z5VQ/9R4g247rO6inP5m7D3zTkYCOzLNDVx24ZZeekw=;
	b=iOXm/wpZTbNCd8HhmyxYrn09ZQPhJZMsjrpcV6ub8/kZN0jj9SiRJUtISLG/fCdHVYIJ
	 GWZtgPKFXJpUZ4ywbVrwHJqOTzUkbcpQD2cuPULWHPtsYH+F2ffASA+/qWDoAw7zYZHBU
	 heMT3ahsDWq9L0+iY1u9U3kCSmNzPmTju1RXB6Kxbo34GL7sEw1ilYa/CNfXmncTN521H
	 b5eKFo8VI5NyKHowTcsCtTPKIjq9G7smipSgQGK/80TM+Wf3WsaAqXb6V63NNxIrBtDc2
	 nT0lubwHTyHvQVqbnrp73xVmB+UZEUTCjfFBMw+HB9yBZln+meg7PvoklpAQE/Xi25A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Daj69xER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B1D606A333;
	Wed, 18 Nov 2026 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Daj69xER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EEF1F000C4;
	Wed, 18 Nov 2026 20:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035082;
	bh=z5VQ/9R4g247rO6inP5m7D3zTkYCOzLNDVx24ZZeekw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Daj69xER/B/6OsjfzddqKVvVfbmjNn01jfxTReaY+1ULwqYLHXdAKbUA0PhySS1nt
	 PMJT1sB4aH/qWAu4CtQ/xbifQJwOtFM83pWXm+uhKKdce4xlxSdVS+QdaZhuWayfQn
	 UcfoJNxYo+2OmBDOu6lm1ao7SW5H3MdB2BuSGQ1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 0600/3318] s390/zcrypt: Fix out-of-bounds ptr advance in cca_query_crypto_facility()
Date: Wed, 18 Nov 2026 15:20:22 +0100
Message-ID: <20261118150335.693291882@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 9fd7fca66735307fd7afa3450882a55ef80f2add upstream.

The FQ reply parser code blindly advanced the walk pointer by a length
value read directly from the hardware reply payload without checking
that the advance stayed within the allocated reply buffer. A corrupt
or malicious device response could push ptr beyond the cprbmem region,
causing an out-of-bounds dereference or kernel memory exposure via the
subsequent memcpy().

Fix this by tracking the remaining reply buffer space in a variable
and validating each device-supplied length field against it before
advancing or dereferencing the pointer.

Fixes: 2004b57cde6b ("s390/zcrypt: code cleanup")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1581,6 +1581,7 @@ int cca_query_crypto_facility(u16 cardnr
 		u8  subfunc_code[2];
 		u8  lvdata[];
 	} __packed * prepparm;
+	size_t datalen;
 
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(parmbsize, &mem, &preqcblk, &prepcblk);
@@ -1626,27 +1627,44 @@ int cca_query_crypto_facility(u16 cardnr
 	prepcblk->rpl_parmb = (u8 __user *)ptr;
 	prepparm = (struct fqrepparm *)ptr;
 	ptr = prepparm->lvdata;
+	datalen = parmbsize - 2 * sizeof(u8);
 
 	/* check and possibly copy reply rule array */
 	len = *((u16 *)ptr);
+	if (len > datalen) {
+		ZCRYPT_DBF_ERR("%s reply rule array len %u exceeds datalen %zu\n",
+			       __func__, len, datalen);
+		rc = -EIO;
+		goto out;
+	}
+	datalen -= sizeof(u16);
+	ptr += sizeof(u16);
 	if (len > sizeof(u16)) {
-		ptr += sizeof(u16);
 		len -= sizeof(u16);
 		if (rarray && rarraylen && *rarraylen > 0) {
 			*rarraylen = (len > *rarraylen ? *rarraylen : len);
 			memcpy(rarray, ptr, *rarraylen);
 		}
+		datalen -= len;
 		ptr += len;
 	}
 	/* check and possible copy reply var array */
 	len = *((u16 *)ptr);
+	if (len > datalen) {
+		ZCRYPT_DBF_ERR("%s reply var array len %u exceeds datalen %zu\n",
+			       __func__, len, datalen);
+		rc = -EIO;
+		goto out;
+	}
+	datalen -= sizeof(u16);
+	ptr += sizeof(u16);
 	if (len > sizeof(u16)) {
-		ptr += sizeof(u16);
 		len -= sizeof(u16);
 		if (varray && varraylen && *varraylen > 0) {
 			*varraylen = (len > *varraylen ? *varraylen : len);
 			memcpy(varray, ptr, *varraylen);
 		}
+		datalen -= len;
 		ptr += len;
 	}
 


