Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D749F320A05;
	Mon, 27 Oct 2025 18:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591314; cv=none; b=G1lG680pIfijBYxIeCRGdsI0QlWqfrSgBEU/Q0yXp62/22ZtdiLiA1FIPgt4IhyUeLRxMwnXeJziMd5+4cRKYsCbMgmHGrm/GDHqe9Pb4A+g1TwZX2e8DS8DY1mHy76+o0K2wxSZKV/5wYJL7lHw8IuGEySx6FRHGPoZr6h/fOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591314; c=relaxed/simple;
	bh=HyhBTeN3fyyJGhOb4XN4OddnIoeohRm9p7/Tca4+DtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3AizXApfRFFoX7u+q/Oas9I8FzeR3VO7LwPhgNxOyQMrVe0rS+ZONwDPjbA/Ba7T3TUMdluumrAb1ACXWhPP324ZqqNDjq5d1lEblplOM2WoR/fukUvxgu3+KBPl6JvoetDiCo3nk04oWaHPqVBRU4N4DyxkuKv4aLuSZZKmMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8wvvVgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8wvvVgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7D0C113D0;
	Mon, 27 Oct 2025 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591314;
	bh=HyhBTeN3fyyJGhOb4XN4OddnIoeohRm9p7/Tca4+DtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8wvvVgAFf6bTiJPDkg52kFclgPLh8jrOF7Kx3rQ2DlVIKqS67cuCEI1cwMLBNBgS
	 YkJR1BDxVaOFprV4PyLOKeA9WfPZOabt0nvFgsVOCCT/0+ECE+lMhQM9zbOscFKkW1
	 3KAKS+ifL+4w5JG0Dw8vPcSSvUAz82x1ez/HIx2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 148/332] sctp: Fix MAC comparison to be constant-time
Date: Mon, 27 Oct 2025 19:33:21 +0100
Message-ID: <20251027183528.542700540@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
+#include <crypto/algapi.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/ip.h>
@@ -1751,7 +1752,7 @@ struct sctp_association *sctp_unpack_coo
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
 
+#include <crypto/algapi.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/ip.h>
@@ -4303,7 +4304,7 @@ static enum sctp_ierror sctp_sf_authenti
 				 sh_key, GFP_ATOMIC);
 
 	/* Discard the packet if the digests do not match */
-	if (memcmp(save_digest, digest, sig_len)) {
+	if (crypto_memneq(save_digest, digest, sig_len)) {
 		kfree(save_digest);
 		return SCTP_IERROR_BAD_SIG;
 	}


