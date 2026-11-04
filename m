Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831411;
	b=VjrZJntZIGJ0Dfuo8rGeTsuoujT6aan0SKNEkIYTusURAF74eFX9D9zHtFEalE5mOyxl
	 PSutKYd1rIwQnCbaoZ4Zd4XsIHBUHRLMmta8sNXohIGZiVA5ioVMKaW3jjHdNDk8d/obn
	 /uZuBHZ+UGMin3mNIK3RAYnCKbJFL/cNNjFoRxWN3ZYy0eNJZS/Dm6dylDkKB7XmveB+b
	 a2KKC46tmx0VQkikMnSGTym0J90Vhr20vF+WytOcAhSvxpFjwBLFl6ZLHhE14XohIMEvR
	 2Ow2k3YbSvU88ADb3KI/RG6FtwnOd2ZlEmkv+VEE6xui9pKA9628fkvA+NDtZ83g0Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Nybc1CuY43XddMuKf3jcvIY74S1y7YsSzT9qkc5UO8=;
	b=WNnyDNwopwsXOwCt3o6YiG3p8UeryaWAriDsj8LrnKMXeNaSAp9PltdN6p/KccRoDEaN
	 IZO8hDMoMp6f46NqANAYG6Ob7Im8FgUYUBHCnBHTG7j4Pgii1/1GPalAtfnMCtPRWJz2l
	 5Wv4v/LoA7GexLA009IAgM0viQ0a88ITphboAjT/Z0fesm1LoYGp3j1aOL42QuOEZcXjW
	 LswoNg4CNcXwtEYGYbOlab0xzzCyw968hyfE0tvhhLjMYSMKH4lafhvYq29Gx5Q78lkDu
	 rq+KaBMjLIp3RW04JA8/D0Ri/xwPaz2bY1ayWnYdxJ1hOo4bu6SCu1dRFSK9lB4dtBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=apQPIgw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3096B606AB2E;
	Wed,  4 Nov 2026 22:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=apQPIgw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD531F000C1;
	Wed,  4 Nov 2026 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831410;
	bh=7Nybc1CuY43XddMuKf3jcvIY74S1y7YsSzT9qkc5UO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apQPIgw08VirKNyHU0epuFpUqxj1EifYV7F9Bnak7pCrn5Dnly2SxlQtLxTUco9Q/
	 dZlAsjf04GUH0HKppThpKdc7TrEuVqCNkgeJXzRI+SdumuZfukpk/W14l5LPRicD/d
	 yMgo3llJA/aeTBw62byqCpnBoePGTeCnsKIYEhD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 0689/1005] s390/zcrypt: Fix out-of-bounds ptr advance in cca_query_crypto_facility()
Date: Wed,  4 Nov 2026 16:07:02 -0500
Message-ID: <20261104211102.915420486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1615,6 +1615,7 @@ int cca_query_crypto_facility(u16 cardnr
 		u8  subfunc_code[2];
 		u8  lvdata[];
 	} __packed * prepparm;
+	size_t datalen;
 
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(parmbsize, &mem,
@@ -1661,27 +1662,44 @@ int cca_query_crypto_facility(u16 cardnr
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
 


