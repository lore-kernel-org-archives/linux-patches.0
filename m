Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5C65293E9;
	Wed, 23 Sep 2026 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173676; cv=none; b=bODB0EmuSvGrvlxrxNHG2C9rLkqXbjS6yATZfyME0v5EjWRnDp6bFv+ulYqH7eUJtBi26y2NauBxWL/EDfexAipDbCl0FY3eR6pELTQSBZjSXfdVkRWAspdhYxl3dOs6+jnZkfYF7m3MQXIjYF8CjeKozq5qsAKe+LgHryCRMDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173676; c=relaxed/simple;
	bh=MXRCrGBOHk1nPWOh8Ft28rhjscJnFojs2ly2jnTjFi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8ijTDD3zHADA9tpBCS3XqvUlkSlLPUhhZImS+JkJvVQOSARJwJFediulHqx1sUSVSbkuJhM17ja6TE11F8ecrH/yYeCTt/mXgWclrH+wl93SpH7g1n6SOo08VXqdvUL5FomRPsREIajW3DDcRay3tQxIy46so8fnklucQJigsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2AZrlVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2AZrlVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4141F00893;
	Wed, 23 Sep 2026 14:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173675;
	bh=rMcNt1oba2QEpptl61mXxIYhiWegb+jN0H4mX18H/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2AZrlVPmDVBdnEV2BF1qI2/MGe/eR7Krb0FcCEbBowrp7n1AWU164SxGcsjGYgVt
	 eNcnt7WpWe+btqER5cZVg7Mb8EaggKnWIGmsvXHEN5YwZNbU3mUy/auSbe952EgX29
	 vrRAPZ/cHMu6D4HTLISroHsHHeB/Usroj3blXt1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <cenzhang@linux.microsoft.com>,
	Francis Perron <francis@akrites.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>
Subject: [PATCH 7.2 320/438] KEYS: encrypted: fix integer overflow of datablob_len
Date: Wed, 23 Sep 2026 16:05:41 +0200
Message-ID: <20260923140653.090060579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -19,6 +19,7 @@
 #include <linux/parser.h>
 #include <linux/string.h>
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <keys/user-type.h>
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
@@ -579,6 +580,7 @@ static struct encrypted_key_payload *enc
 {
 	struct encrypted_key_payload *epayload = NULL;
 	unsigned short datablob_len;
+	unsigned short payload_totallen;
 	unsigned short decrypted_datalen;
 	unsigned short payload_datalen;
 	unsigned int encrypted_datalen;
@@ -632,16 +634,22 @@ static struct encrypted_key_payload *enc
 
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
 


