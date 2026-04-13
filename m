Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7E317153;
	Mon, 13 Apr 2026 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099063; cv=none; b=kMKFnorbwV725gsZlp1Y1m9V1zj1CzDf/PsBmxHmdhhL6qJlcDHWE8Kp/l7Fh///BwxwPP9n/WY6ZycaSxOnwXG+LL6kfFIcH0ANdUU20ENDG4waanwNVuo4mx+Sq/2tNBfvwwj7AbvBSLiJ/XkYyIB91LbeJnqGiVWEJnBnPXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099063; c=relaxed/simple;
	bh=DpBD27Qc041yW227T1bhhjWvUGt2enVPd6LO00676gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHT8FkvpOm/DETU3RYVDcip4LU0olWn5ykDQ3D0X710KbumBVvPpecDL0I35X+v/sW2IVl2ZNkGYQ84TupxSTF18CKfVo3JUplOJ3yGxPFVQ/bYxRjLG4BuiTy4mg1Gm2QBuWvPM65B/ge66DLEMMsRzTbre57aewW5aFr3Tj38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIyCIK1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIyCIK1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8169AC2BCAF;
	Mon, 13 Apr 2026 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099062;
	bh=DpBD27Qc041yW227T1bhhjWvUGt2enVPd6LO00676gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIyCIK1la/ShBFCcYJjKLFUJ2ZdtGjqGXA4tp/28ZzS7ylHdhKkPEVhScsBLtktLV
	 kAP7uX/AGOFTcIf1icLSPnniT2aYNRijdusWlB206ca8g4WWCAFv7R+XCSSZJ3JQV0
	 nEZEJDcVn4GTeqFTf14V97g5usbXav8wReipOYHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 195/491] smb: client: Compare MACs in constant time
Date: Mon, 13 Apr 2026 17:57:20 +0200
Message-ID: <20260413155826.371693100@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/cifsencrypt.c   |    3 ++-
 fs/cifs/smb2transport.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -36,6 +36,7 @@
 #include <linux/fips.h>
 #include <crypto/arc4.h>
 #include <crypto/aead.h>
+#include <crypto/algapi.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
 			struct TCP_Server_Info *server, char *signature,
@@ -255,7 +256,7 @@ int cifs_verify_signature(struct smb_rqs
 /*	cifs_dump_mem("what we think it should be: ",
 		      what_we_think_sig_should_be, 16); */
 
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (crypto_memneq(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
 		return 0;
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -31,6 +31,7 @@
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
+#include <crypto/algapi.h>
 #include <crypto/aead.h>
 #include "smb2pdu.h"
 #include "cifsglob.h"
@@ -687,7 +688,8 @@ smb2_verify_signature(struct smb_rqst *r
 	if (rc)
 		return rc;
 
-	if (memcmp(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(server_response_sig, shdr->Signature,
+			  SMB2_SIGNATURE_SIZE)) {
 		cifs_dbg(VFS, "sign fail cmd 0x%x message id 0x%llx\n",
 			shdr->Command, shdr->MessageId);
 		return -EACCES;


