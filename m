Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F0533CE8A;
	Thu, 28 May 2026 20:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999281; cv=none; b=ZEAElV/sujKL6PG77/HKPKk4ELRxOvnBp+mGy+YKhWTNQTEPVfWPgVepxVeHDXS/AlIyCybJf7TCTL5Wy8d8QyRGMr0EnMquT8FU4qUKdJ1KijdmLKjKflYzs00JXiXvt8bPeOldnUK2Z1eUQ5R7ilsBpDvE84dJThn6ZVfvkIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999281; c=relaxed/simple;
	bh=cjnDDRXY9RLjaliqdF4L64WbP7xzVeoEBMCb6YLQwuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdMzNhfke2ef1bwQREoR2hzkQ9+LYOoppBIOYEJHBLZ8ATIwFqfHJ7tnVlBtxPVA/NJy7m1Rzv6EEWsWByOm/QW+F6npbzMP3if82sM0Hrt07jWjhb0gJbCAuJYRDKxlhak7mULN0ygWdhQCM3Bc1JiD9H9sD9TJcB8NTbjwHCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNgCXhfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNgCXhfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5331F000E9;
	Thu, 28 May 2026 20:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999280;
	bh=D+mQO/ZeKASSEr9FS8PBz6qJ0AVaTdLcd+IpVJ+aL5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNgCXhfDKbb36j+GhDh1ljIzLrhwrf1DrGK5U1wzLC/LCkwD67o8zaJgOsR3WrwH/
	 wnjsBHSQuPY1nxJrgXhWSW9mcxemrinO/wYZRpYYpg6gfmjIauGgBFRdFVvhD9pitJ
	 ateTdsB2jW3nLOIHeKMApwr1Nmewk+UaipJEPAtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 011/377] smb: client: reject userspace cifs.spnego descriptions
Date: Thu, 28 May 2026 21:44:09 +0200
Message-ID: <20260528194638.715343147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Asim Viladi Oglu Manizada <manizada@pm.me>

commit 3da1fdf4efbc490041eb4f836bf596201203f8f2 upstream.

cifs.spnego key descriptions contain authority-bearing fields such as
pid, uid, creduid, and upcall_target that cifs.upcall treats as
kernel-originating inputs. However, userspace can also create keys of
this type through request_key(2) or add_key(2), allowing those fields to
be supplied without CIFS origin.

Only accept cifs.spnego descriptions while CIFS is using its private
spnego_cred to request the key.

Fixes: f1d662a7d5e5 ("[CIFS] Add upcall files for cifs to use spnego/kerberos")
Assisted-by: avom-custom-harness:gpt-5.5-qwen3.6-mod-mix
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_spnego.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/list.h>
+#include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <keys/user-type.h>
@@ -40,12 +41,27 @@ cifs_spnego_key_destroy(struct key *key)
 	kfree(key->payload.data[0]);
 }
 
+static int
+cifs_spnego_key_vet_description(const char *description)
+{
+	/*
+	 * cifs.spnego descriptions are authority-bearing inputs to cifs.upcall.
+	 * They are only valid when produced by CIFS while using the private
+	 * spnego_cred installed below.  Do not let userspace create this type
+	 * of key through request_key(2)/add_key(2), since the helper treats
+	 * pid/uid/creduid/upcall_target as kernel-originating fields.
+	 */
+	if (current_cred() != spnego_cred)
+		return -EPERM;
+	return 0;
+}
 
 /*
  * keytype for CIFS spnego keys
  */
 struct key_type cifs_spnego_key_type = {
 	.name		= "cifs.spnego",
+	.vet_description = cifs_spnego_key_vet_description,
 	.instantiate	= cifs_spnego_key_instantiate,
 	.destroy	= cifs_spnego_key_destroy,
 	.describe	= user_describe,


