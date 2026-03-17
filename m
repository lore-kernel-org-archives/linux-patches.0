Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFDA1ACEDE;
	Tue, 17 Mar 2026 17:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768512; cv=none; b=l39VkWxV71xkfDmbZd8ouqwCzIDXG4+7R1zj+OZYRD0BNDmSIIkqBcdzT0hvY1a1n8ygskZY6qDmbyJ23Gk9e2y4EeoL8DjOaain+XylvEhrtl0O7/xwhjvULv6L1Z1+EfTYWFDapb2mIE45ZfdssR73KP7PcJ669a/IpKxs0dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768512; c=relaxed/simple;
	bh=1QS14YKicU6WZU3EJU5wxbeJdKJIdLvNKawdad4BXGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4y4u/CFXF+Z97Y/gMxxkY95E4LwIkjDXs4o37FrNkCGUOByNtQvxB3UbXjf/7b4UcBoW7XMH8UDPxJsaabhJ6NaXAMds++u7+AEIog3yKxp1bhO+y6YrS6p4ETfjavl4BOnRPX+z3kewZYSG079RlMAn303weTIvWbEsBncruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE/Sz8er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE/Sz8er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BA8C4CEF7;
	Tue, 17 Mar 2026 17:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768511;
	bh=1QS14YKicU6WZU3EJU5wxbeJdKJIdLvNKawdad4BXGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TE/Sz8er3uBFEVxwpxmq0ZA+TOGtM7fS7Ir+zBWIw3vpGdfu1rTbXmPLfQ+17oH5N
	 kQrPc6Bg8TNAXOlIRu2h6YwZhu5nUcrkxYZzlSsghCCD6lGhAqVxf6c3sDhoDBZFFy
	 5CymKaatZ+Us3RB4hlaJ4rhm0geEpcGqmS2o3bes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 327/333] smb: client: Compare MACs in constant time
Date: Tue, 17 Mar 2026 17:35:56 +0100
Message-ID: <20260317163011.529402940@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
@@ -26,6 +26,7 @@
 #include <crypto/arc4.h>
 #include <crypto/md5.h>
 #include <crypto/sha2.h>
+#include <crypto/utils.h>
 
 static int cifs_sig_update(struct cifs_calc_sig_ctx *ctx,
 			   const u8 *data, size_t len)
@@ -277,7 +278,7 @@ int cifs_verify_signature(struct smb_rqs
 /*	cifs_dump_mem("what we think it should be: ",
 		      what_we_think_sig_should_be, 16); */
 
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (crypto_memneq(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
 		return 0;
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -20,6 +20,7 @@
 #include <linux/highmem.h>
 #include <crypto/aead.h>
 #include <crypto/sha2.h>
+#include <crypto/utils.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
@@ -617,7 +618,8 @@ smb2_verify_signature(struct smb_rqst *r
 	if (rc)
 		return rc;
 
-	if (memcmp(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(server_response_sig, shdr->Signature,
+			  SMB2_SIGNATURE_SIZE)) {
 		cifs_dbg(VFS, "sign fail cmd 0x%x message id 0x%llx\n",
 			shdr->Command, shdr->MessageId);
 		return -EACCES;


