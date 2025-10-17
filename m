Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388FD337100;
	Fri, 17 Oct 2025 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714490; cv=none; b=U5fWd2s/Pxt+Ggiu7fWFqdaYOim7qusLkYHd8CeichuDIk2A0tLmTw+NnS6fvzsegyVcNQs7Ag1MWuTgV1SAwhxv6Nmjli5JKohiOoJs2BiW87PEzpwoy43bgitMbirhr/fHVLVFhwI3W1W7GcTKSJ/vzk4cTBayli/apzFrz3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714490; c=relaxed/simple;
	bh=a0funOSoeVxYu9JmkiPPFrFkTmMyqLil6mVhWf2TqLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMxbOlVGI7YSVlFr9sK6phD30oKNNVBlYjVy6HicLPbsObyzDhK+GlFuIb/gRs0eWRKcyzYamKlWZ7+ISEvbZNTTum5B75OPIcuYkqUhaZV4d/n8dMOg+4n7sBJ19UVW9LRNcTEbUnF6Y9gRcWCxfoDHl9ugaF+jyrsolWTJubc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0TUt0nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0TUt0nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B235FC4CEE7;
	Fri, 17 Oct 2025 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714490;
	bh=a0funOSoeVxYu9JmkiPPFrFkTmMyqLil6mVhWf2TqLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0TUt0nqDeOLoe6dB5By+LGmCAl0m89BL3z+KoKS9aLztlX03agfIJwO03iqouUiK
	 8zI5mPgNDa2FDM21v+KigjFsTPxtTPLIusXxnJqN84efRQV5o9rpoNtEdNtJjCmgHP
	 ChwUfdhOSqeGJpJCAuX2uTpeBVgUbd9qh/bc/oCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 163/277] sctp: Fix MAC comparison to be constant-time
Date: Fri, 17 Oct 2025 16:52:50 +0200
Message-ID: <20251017145153.078609107@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit dd91c79e4f58fbe2898dac84858033700e0e99fb upstream.

To prevent timing attacks, MACs need to be compared in constant time.
Use the appropriate helper function for this.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/20250818205426.30222-3-ebiggers@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |    3 ++-
 net/sctp/sm_statefuns.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -31,6 +31,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/ip.h>
@@ -1796,7 +1797,7 @@ struct sctp_association *sctp_unpack_coo
 		}
 	}
 
-	if (memcmp(digest, cookie->signature, SCTP_SIGNATURE_SIZE)) {
+	if (crypto_memneq(digest, cookie->signature, SCTP_SIGNATURE_SIZE)) {
 		*error = -SCTP_IERROR_BAD_SIG;
 		goto fail;
 	}
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -30,6 +30,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <crypto/utils.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/ip.h>
@@ -4417,7 +4418,7 @@ static enum sctp_ierror sctp_sf_authenti
 				 sh_key, GFP_ATOMIC);
 
 	/* Discard the packet if the digests do not match */
-	if (memcmp(save_digest, digest, sig_len)) {
+	if (crypto_memneq(save_digest, digest, sig_len)) {
 		kfree(save_digest);
 		return SCTP_IERROR_BAD_SIG;
 	}


