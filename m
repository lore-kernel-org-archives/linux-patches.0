Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34039433042;
	Tue, 21 Jul 2026 19:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663791; cv=none; b=YE2qbaxs0UdzVZpq99BVBLdS26C3uc7/mLH36fo245SXCBODiVdzzEOZ3RKnmWTbMz8ZuyIhNRH3yjBtiw4qRKd6eG7ASkmC3lLekQFJEHeu3na199vu4o3KdKOo8qm5aPc7Xn6cXMqKKCK85gC3it/Zu8cK5na4U7pqwZP1JX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663791; c=relaxed/simple;
	bh=SSd9TT8tX9N2L4Q2QRO7sSldufG+YB6btQ45ECmhgAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKc8RCAK2RUnHm1m/YEwBidx0f3z28UFOLh0rZWcKE8wzUOfbAi1EfUJ32/tDqatz5iuuHCT+b9AsVwiromRFV1mdNrq3G4QT2THw3fLNkF2RpDi8iJeokr7LMSXym5l8aLwtYSEUc6WY+mwDQ9VZ20mzOEhzcb9YlK16okyxfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3r2H+tL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3r2H+tL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D681F000E9;
	Tue, 21 Jul 2026 19:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663790;
	bh=KzmxyQXyd2dGMHQrYgs6vkUHYgIgyrQlMrH09a111fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3r2H+tLcshJff9EdBfa6et22/zkL9zYNr6XXy+zliSlel6B9YNHr9v/XXpHTQpGX
	 P3NoFyaXWHVvCflT9i2oZLc1VOBG32CXTngq/G7lnUhHcz2FX+UE87+fmgOQuNmtp+
	 kZgDu0svniq+ynxh/bD2ski7yYQtN1dYQpXeSIwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.12 0955/1276] s390/pkey: Check length in PKEY_VERIFYPROTK ioctl
Date: Tue, 21 Jul 2026 17:23:18 +0200
Message-ID: <20260721152507.401006540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -332,6 +332,13 @@ static int pkey_ioctl_verifyprotk(struct
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


