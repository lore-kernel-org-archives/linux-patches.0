Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1116A330B0F;
	Fri, 17 Oct 2025 15:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716452; cv=none; b=H+XaP1X+EkoJSp1rk7IpjYGOeuzSMEiiaDw3c2As9TUQ2UQBkRiTNCABKyHGVzLhwFEtQo1z4f9lwE8ttcoG0IqkkSQxt0O7gnkHG4n3U8M/rn74Mc5UJriVYu9oZ7JF2lBdv1zzW74QXbyWbSqJA3HVsl7YYQAc1KSXFKYY6Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716452; c=relaxed/simple;
	bh=NNd0+VY8KRnIq8xyvv4/0kp1XR89rQB09tDYcb482dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckA/hawMHANpyjQ6eWI3/rK1ftaqCGvloK8YFno+1x+ibDed6GLscK16qfNXCcoqgo/K5uuGeqkz5bpBRmYbLslNAj088YmRZ2ZezWgi9JeV4V/e765yXoGIbf2CBmv/9d+f/BL9OuCAKo0ugx8bt6hwQlGLS+y3rso7zekhYnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG5nSQre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG5nSQre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6D6C4CEE7;
	Fri, 17 Oct 2025 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716451;
	bh=NNd0+VY8KRnIq8xyvv4/0kp1XR89rQB09tDYcb482dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG5nSQreSJwpGYdci18/0HEN1xdpYQY1EGEB2vYZ8Fv2HO2yc52HannQsf9tZSQ+C
	 9bg+6eDovApa4z+/9mIoMzKlx6AUE91PkNygJvPloUjPLqZiIMbew5dCbMGxRuW2tF
	 x+KaNdcsTbXypiU/mgz+9dMwAmBTqndXYu/ShXuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 196/276] sctp: Fix MAC comparison to be constant-time
Date: Fri, 17 Oct 2025 16:54:49 +0200
Message-ID: <20251017145149.626675018@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
+#include <crypto/algapi.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/ip.h>
@@ -4402,7 +4403,7 @@ static enum sctp_ierror sctp_sf_authenti
 				 sh_key, GFP_ATOMIC);
 
 	/* Discard the packet if the digests do not match */
-	if (memcmp(save_digest, digest, sig_len)) {
+	if (crypto_memneq(save_digest, digest, sig_len)) {
 		kfree(save_digest);
 		return SCTP_IERROR_BAD_SIG;
 	}


