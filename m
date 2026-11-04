Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827112;
	b=rSov0W9kN8lKAYKEn1naAv/Kra8Dsw2UfiEkdH88rn41BhVpE+AD6grao/oiEAw8lZam
	 IzHkCpwC6LDqK+A0u5jpfNTyg4Udrqgc/JEpFaFCrK1tfAFfrTfLbPYLbhEP/o3dgIFOv
	 JJ2uxV5mAmsuvEw/DXhPrUnjVo2uO6XLMmq1hUm+3owwBhLEa8cNO1/TrhafGOnMUrAph
	 dkEeFqD7CfX7og4W1IQ8p22tHypBsFNkYEnJqDhN2LsRVwknvl00J4ygLPQzqDwEve4Vm
	 mnrlu2zBe8DU7z7nzzl6GwsMhcsd6oHykESzWO03U5oEzwnuuMuH+ZGMaxmafymzLHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qSYDKlAZVJOCOMYZW6MiktTALcVLvWoWEyO8DnSGnGI=;
	b=Ibqp/vr3ulXebJ5XvscX2t6xfRZcaLocfU5oifWFn41XQJ7hasuGu4QbljrO6nPT4hQE
	 KfLLD/xdMGzhdsPq6zcl//0NVAxwl09Z/+gCnuddDlbmvP06kf/mzd5WzgVslr7TnQW/a
	 pnLdL8YqKrVKVwptl7UkQfjL1QVZyHpZ4LujZwzwKaVmYwYxqxr149YEYb9HoY6bYCL4b
	 BhONryrJIb6F6RjompT5Mgy2jFTo1i7VmKjfLk4HY9rLv+C4Lp6lG2tKxGVzTjppDgB5z
	 nvPjw23mAqA/ObP6Cjlpy/5pkzmc5YYNY+lcrT+bG7z10A7Foc0yHOXuTp+7cO4Cwsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5ehTH3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3EA606A854;
	Wed,  4 Nov 2026 21:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5ehTH3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D031F0093A;
	Wed,  4 Nov 2026 21:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827112;
	bh=qSYDKlAZVJOCOMYZW6MiktTALcVLvWoWEyO8DnSGnGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5ehTH3QIODmdjFPfFM7s11iLJS4+75Jof7jBrdnOxpUl6ZDIkq0mazf9aRI9+LTV
	 KHaiRhXtusJv/N/xqfxP0jcaYdl/XjI7eEUH7fx9xnrgvSxH3A5oVIfk+KGTAQniUo
	 TmSrv6Sd+3ObjQl3oe36UXq+jI+eOw3OWToJp1CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 181/547] s390/zcrypt: Fix out-of-bounds ptr advance in cca_query_crypto_facility()
Date: Wed,  4 Nov 2026 16:06:05 -0500
Message-ID: <20261104211043.288768423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1627,6 +1627,7 @@ int cca_query_crypto_facility(u16 cardnr
 		u8  subfunc_code[2];
 		u8  lvdata[];
 	} __packed * prepparm;
+	size_t datalen;
 
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(parmbsize, &mem,
@@ -1673,27 +1674,44 @@ int cca_query_crypto_facility(u16 cardnr
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
 


