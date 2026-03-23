Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD733B531A;
	Mon, 23 Mar 2026 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278711; cv=none; b=YC+XPBcgqJYZ7E7Q9ujLNIh7fEZU5UIdSKdXSvIlMq0GfaJ6gLgSiNZWh0cCKsoEuFOmlJU4yllqwZ8hAiRRgxfZABlLMCRmas4Qm12NDGxFgaB8V7cuP1iFWRHGXmrMB7lFXjux8h9iwz62zZhBilAcgfWfYJcieaWG6XCmS0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278711; c=relaxed/simple;
	bh=Yvq/pPoGxjYcwKvhDpmwyUYocO2jAEo9sCI/iBWEx+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y69AEiytGAdVJHWWbPUaLXFxTPmmDk25gZCK6PWP0DwvObpRdAN0ia/5tmI7mQhgvNN4BjP71pzo/uktrHoYgOdHV/eTL79vtJZdy42jae224vKpCx0mmirlbespMIbJQmFLnuPf8xEPLLP2sefk0OGBDkJIq0xtYy2lPq4CDQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdqFCkRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdqFCkRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027B6C4CEF7;
	Mon, 23 Mar 2026 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278711;
	bh=Yvq/pPoGxjYcwKvhDpmwyUYocO2jAEo9sCI/iBWEx+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdqFCkRkeHaNfw/G3s4LMvgj9zarna40RbByMlPLzXgcJrJ/fVOwo8cju+ya1HHG/
	 Hs8JD7+20AQ/oJ7lCh+rUToLgE2BGx8U7JYz0jT+SSuQI1vUr/RjDqwZ4FWDfzKOhw
	 j9Fqr0PK7hx/JCsWkYETbOvFXZlMSv5hkTlNynAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 395/567] smb: client: Compare MACs in constant time
Date: Mon, 23 Mar 2026 14:45:15 +0100
Message-ID: <20260323134543.631170285@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 26bc83b88bbbf054f0980a4a42047a8d1e210e4c upstream.

To prevent timing attacks, MAC comparisons need to be constant-time.
Replace the memcmp() with the correct function, crypto_memneq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsencrypt.c   |    3 ++-
 fs/smb/client/smb2transport.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -23,6 +23,7 @@
 #include <linux/fips.h>
 #include "../common/arc4.h"
 #include <crypto/aead.h>
+#include <crypto/utils.h>
 
 /*
  * Hash data from a BVEC-type iterator.
@@ -371,7 +372,7 @@ int cifs_verify_signature(struct smb_rqs
 /*	cifs_dump_mem("what we think it should be: ",
 		      what_we_think_sig_should_be, 16); */
 
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (crypto_memneq(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
 		return 0;
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -19,6 +19,7 @@
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
+#include <crypto/utils.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
@@ -732,7 +733,8 @@ smb2_verify_signature(struct smb_rqst *r
 	if (rc)
 		return rc;
 
-	if (memcmp(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(server_response_sig, shdr->Signature,
+			  SMB2_SIGNATURE_SIZE)) {
 		cifs_dbg(VFS, "sign fail cmd 0x%x message id 0x%llx\n",
 			shdr->Command, shdr->MessageId);
 		return -EACCES;


