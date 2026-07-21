Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB312E736D;
	Tue, 21 Jul 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654584; cv=none; b=eq13SIPeP6fdu7151yADtL3quIJ/8pZYo8jeuO3R7PzFYWJzR7n4SojDBpOoML+QLB1pOSt8qVmYM5kvUH9RyWCDu7DC0FbdaRDKKiHpuPldHvVFuOCIFT5wP4os8za5sAiNEqIq9oQRVudQIb1iRzJf8cPdu1/a3jLRByjcHOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654584; c=relaxed/simple;
	bh=QTXV2jhyzwbL1So174JlI0BKOf9DRWvc+aP0szVYlOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnqU+/mzo6gjfrnhOWwFqEBaopZ1JcxcrZ3qp2R0/6VMnwOA3dC2o26PociIDEYYlPhf+Np0CE6jhx8YSUAjJMVCxhwLCxdjMtWcZwpy5Du0VqJj+LAnDwxBDQFfcEPgkHLbmnxKLCfE9umLEo2VljyS88kaQtlqyKz6rA+NEuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9fXrtGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9fXrtGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36421F00A3A;
	Tue, 21 Jul 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654583;
	bh=49wVsjFq8wkDrsSjd5JdvmuZ+UApz1EgRuseRup67Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9fXrtGICZVSZy8Z2BZHQAXF2K1cxT74ol4ZnMZEUHtn0AomY1/UqWxxVhxbGSoNm
	 OckYHyd+4RUW0Ez+fSyHWnC0CAtrt0HUoh8BU0yGeU+HnWvLUOoeyjoxI9qvpTXt0y
	 WC/KATOJC4Y7oI6/Nzg2WSNTdISLCXLL9e3nNH0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 7.1 1761/2077] s390/pkey: Check length in PKEY_VERIFYPROTK ioctl
Date: Tue, 21 Jul 2026 17:23:54 +0200
Message-ID: <20260721152634.281421225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

commit b3d4ab2d7df9426f7f1d3671d7e2108f2ca6e970 upstream.

Explicitly check the buffer length request structure provided by
user-space and fail, if it exceeds the buffer size.

Cc: stable@vger.kernel.org
Fixes: 8fcc231ce3be ("s390/pkey: Introduce pkey base with handler registry and handler modules")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/pkey_api.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -334,6 +334,13 @@ static int pkey_ioctl_verifyprotk(struct
 	if (copy_from_user(&kvp, uvp, sizeof(kvp)))
 		return -EFAULT;
 
+	if (kvp.protkey.len > sizeof(kvp.protkey.protkey)) {
+		PKEY_DBF_ERR("%s protkey length %u exceeds protkey buffer size\n",
+			     __func__, kvp.protkey.len);
+		memzero_explicit(&kvp, sizeof(kvp));
+		return -EINVAL;
+	}
+
 	keytype = pkey_aes_bitsize_to_keytype(8 * kvp.protkey.len);
 	if (!keytype) {
 		PKEY_DBF_ERR("%s unknown/unsupported protkey length %u\n",


