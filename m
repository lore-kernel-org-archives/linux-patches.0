Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3240346E016;
	Tue, 21 Jul 2026 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658805; cv=none; b=ZSSJs4kKDMnQKvjlsEE2m/dxQ1ylT1CKdt6UwO8voqWw24Q/sk39it3cWOL05bVxH15xhItNUWCYILR8l1UfuN73FQl9v7DILiIET/1OjprrJpJp3SPcgMJ+YcL7+qxro5DEl/aQJKApL6WDCPdJDLzMVczBNoJsaE8eh8YBXt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658805; c=relaxed/simple;
	bh=V8hNLyeYke77sN9JSNx7aOWSqWlmZiyUvevvCWzvud0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL3jMJfuzxKwmFofRs9HwPASPaDG0OMkoI45EpqGFFTRs2Sr9gS+Y/dt7OH9OfitMKgqfasHpZxtcwoFf1AoTns52YIvRQjQmPdf2/U4tMXedSMFPcTA0XrWFB38HzvvR5X+mw4eRLgDULGLA2KGAV3gV4IvhDKlyk6MEda15lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDF+bVfl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDF+bVfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DF41F000E9;
	Tue, 21 Jul 2026 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658804;
	bh=MfEbIVId3DRtDDFXIKfT90zvKjHL6kIK/TMoiIqJBxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDF+bVflGCdjsJ5UlzrKZa4mdOBFiqra6t6J1yH/zJQOd9vjdnEkkpPNdHa7iHJMY
	 cueHiNENKTYac/nvk3/K2J5b+sRs2oAeSEAnp83bdt4xqULT7E3zRTVbuWJkZF2NAM
	 tJdYeFd+pbktE9rdRKltD+MwmFUN8aoSJK8V24+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.18 1281/1611] s390/pkey: Check length in PKEY_VERIFYPROTK ioctl
Date: Tue, 21 Jul 2026 17:23:17 +0200
Message-ID: <20260721152544.259978798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -335,6 +335,13 @@ static int pkey_ioctl_verifyprotk(struct
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


