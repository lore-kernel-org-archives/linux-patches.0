Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22983333730;
	Thu, 28 May 2026 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001124; cv=none; b=NZ0lfn02S2LIgBArGBiveE1aPk9BbjTFzbi1GmqMRpG4d5tuzk+wpSSpccgncTLkJ5RpCsTq4G8kflCTcySkMmYVYXjD8bJ8Nl1vNa+rWGoVDdzfxNh/7qtgsikF5ewQymxf6Hj7nTqun49LqAhp94jlxqImArfqzsWcbN9U2dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001124; c=relaxed/simple;
	bh=yBU98Tkw9CizCE6SiIIzi64uC5xeLIQAh+1Ezj0vNZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUDO+Q9iD9lJ/JGfMf/T6FC4vCsX6E6w1XFpea4ICCV1KETfVEuG/ZcV2a1FP7c+S/X/r5LzYGyZPv3TsYMHpUwJKdXiZCCUAyl6xkbIoAAz4eztLGHkedazgcCHOCkXFy4eKjBsSRPgYeKqo6G7onZ8DkcU5EF5+JjqK2f5Eec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AV7PmYxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AV7PmYxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DFB1F000E9;
	Thu, 28 May 2026 20:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001123;
	bh=F4kUcw8ieCHiGh5zMN0qCXH6eDiT+HNHxAlrxmk++bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AV7PmYxSRgHM89q+fiCMzIzoqIzpN87OEXgqdeqAITufywcMwUmjr8m/7OgXesWKt
	 RSh/j2s9pxj1b2zWIiKo2hejzQj+y5qmsFBtA7mM2IfouKzruQpQf3ET0uSHzgDReY
	 2No3xsKXnfm5mMuw0guW8zncXBI3Q/p2JMsRN7IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 016/186] smb: client: reject userspace cifs.spnego descriptions
Date: Thu, 28 May 2026 21:48:16 +0200
Message-ID: <20260528194929.394180968@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
@@ -46,12 +47,27 @@ cifs_spnego_key_destroy(struct key *key)
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


