Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDD73769FB;
	Wed, 30 Sep 2026 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788672; cv=none; b=ntaNTwgXpsDdG1/w/m8xtjINMdFCRkpMgEgVpCXVQ3VLGUJdUng0nthiasNA+bL5huv+KB4QggLwDgtlJyyv6j+wvZGUjuoh7ym9Rth5Q/kQpb6VDdGn8IP/R+5YxTDs8tIpfhyQ0EasRocx7Nl33njgbtOuSsqds0wtdr9nZvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788672; c=relaxed/simple;
	bh=q1Du138MfACrlSC424Is6BmAC6BlzY3GkGjd/MDZ1uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+StdQn9M/Av2ot15jg1g/WqztWzlVEoItgkXEEWExYnHHxabymK2SGIZZcPb701TWNnjmVEmJ8WMtHEJe+StQsPk8Y9/oWUImzn8rhSZ8WZVgvXnR5+tNhLIlI98pFK5vtRgPC3IMFDOCdI+gIYj+3Hgvik4xvIS9vRKi5CK/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2whJcoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2whJcoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30AF1F000FF;
	Wed, 30 Sep 2026 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788671;
	bh=5jtxSEXEe4s2978P2KLsjSEEwo46mJP6KrivBNdwgt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2whJcoKtGJ1sOjYJjSnKMXVq6mpBUXfJL7yo+EWDh9nYaBCVHcpmOzZPM7wVZOeZ
	 0B9WoAaVxexFZezn362+c78bJmi7RU1HWpUgRSCf1PHSi2/r24LY+vCMhDV/oYtylp
	 gwLJb/iPs0OW6o8IdkVXLPVpABgLgM0I+Cr3/0eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <cenzhang@linux.microsoft.com>,
	Francis Perron <francis@akrites.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>
Subject: [PATCH 6.12 205/877] KEYS: encrypted: fix integer overflow of datablob_len
Date: Wed, 30 Sep 2026 17:18:36 +0200
Message-ID: <20260930152419.147398092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Cen Zhang <cenzhang@linux.microsoft.com>

commit 8697c431e297eb0d0ab13dda6bc172b48a34f05c upstream.

encrypted_key_alloc() stores datablob_len in a u16. It is computed from
multiple string and payload lengths. If the result exceeds U16_MAX, the
assignment truncates the allocation size. KASAN reports a 32760-byte
slab-out-of-bounds write when __ekey_init() copies the master key
description into the undersized buffer.

The total payload length stored in key->datalen is also a u16. Use
check_add_overflow() to reject values that do not fit either destination,
and use kzalloc_flex() for the flexible-array allocation.

Fixes: 7e70cb497850 ("keys: add new key-type encrypted")
Cc: stable@vger.kernel.org
Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Cen Zhang <cenzhang@linux.microsoft.com>
Signed-off-by: Francis Perron <francis@akrites.dev>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Link: https://lore.kernel.org/r/20260909153433.83117-1-cenzhang@linux.microsoft.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/encrypted-keys/encrypted.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -18,6 +18,7 @@
 #include <linux/parser.h>
 #include <linux/string.h>
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <keys/user-type.h>
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
@@ -606,6 +607,7 @@ static struct encrypted_key_payload *enc
 {
 	struct encrypted_key_payload *epayload = NULL;
 	unsigned short datablob_len;
+	unsigned short payload_totallen;
 	unsigned short decrypted_datalen;
 	unsigned short payload_datalen;
 	unsigned int encrypted_datalen;
@@ -659,16 +661,22 @@ static struct encrypted_key_payload *enc
 
 	encrypted_datalen = roundup(decrypted_datalen, blksize);
 
-	datablob_len = format_len + 1 + strlen(master_desc) + 1
-	    + strlen(datalen) + 1 + ivsize + 1 + encrypted_datalen;
+	if (check_add_overflow(format_len + 1 + strlen(master_desc) + 1
+			       + strlen(datalen) + 1 + ivsize + 1,
+			       encrypted_datalen, &datablob_len))
+		return ERR_PTR(-EINVAL);
+
+	if (check_add_overflow(datablob_len,
+			       payload_datalen + HASH_SIZE + 1,
+			       &payload_totallen))
+		return ERR_PTR(-EINVAL);
 
-	ret = key_payload_reserve(key, payload_datalen + datablob_len
-				  + HASH_SIZE + 1);
+	ret = key_payload_reserve(key, payload_totallen);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	epayload = kzalloc(sizeof(*epayload) + payload_datalen +
-			   datablob_len + HASH_SIZE + 1, GFP_KERNEL);
+	epayload = kzalloc_flex(*epayload, payload_data, payload_totallen,
+				GFP_KERNEL);
 	if (!epayload)
 		return ERR_PTR(-ENOMEM);
 


