Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140BC129A6F;
	Mon,  8 Apr 2024 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583425; cv=none; b=KNY3DHOV3AICQSXJUIlWiAYhb65VviU+prAc7p4pFpMtpP9/ipUE6RFgEbtDcIZpXFlpCvjy9CCbeS0fU3MtJ93QeoQfSHERukgaoo/cbb5ATYeGkIWetIO7wLK9f7YdVgCY6hRFB6FmEA/R9Zbh1FIvqbMY/hO42yn/T6yyfZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583425; c=relaxed/simple;
	bh=6AEMHcR3NPZKtkOZcGFRT64TudVwIfK5oW+3fL+sDrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkAVtsdMhuC0Vb+aqiyrw0cXSMPFGN5W7DQmwMiAhOeS/eaP+fJMpHrJooph5WyXDEPO1UtTCJLUuKDUMxHMf7JCZ99JT9a2aacpfcl1/CemwmknJVyRyuSDSwBSeONprJdsruebCMT0/LdUTUefh2xs25j3mjGib+Inz9F0oDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLUSEGhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLUSEGhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC29C43390;
	Mon,  8 Apr 2024 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583425;
	bh=6AEMHcR3NPZKtkOZcGFRT64TudVwIfK5oW+3fL+sDrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLUSEGhR0tV2JPLAVIbmPgiPQbiWaohFADE7WiRTF7Jpsht/9NUOF4AgoiLjhgVvR
	 gY4axD/GaYSwMtd8fo20hjnY8eKSoaHkfePQyaacez6cdk2T5gw26Twe10uA8bLIjG
	 QehxgMl6bnX7AtRFGDMRbjRE4UxuvG6/nACLJJ9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 246/690] NFSD: Remove be32_to_cpu() from DRC hash function
Date: Mon,  8 Apr 2024 14:51:52 +0200
Message-ID: <20240408125408.541231217@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7578b2f628db27281d3165af0aa862311883a858 ]

Commit 7142b98d9fd7 ("nfsd: Clean up drc cache in preparation for
global spinlock elimination"), billed as a clean-up, added
be32_to_cpu() to the DRC hash function without explanation. That
commit removed two comments that state that byte-swapping in the
hash function is unnecessary without explaining whether there was
a need for that change.

On some Intel CPUs, the swab32 instruction is known to cause a CPU
pipeline stall. be32_to_cpu() does not add extra randomness, since
the hash multiplication is done /before/ shifting to the high-order
bits of the result.

As a micro-optimization, remove the unnecessary transform from the
DRC hash function.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfscache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 6b9ef15c9c03b..a838909502907 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -87,7 +87,7 @@ nfsd_hashsize(unsigned int limit)
 static u32
 nfsd_cache_hash(__be32 xid, struct nfsd_net *nn)
 {
-	return hash_32(be32_to_cpu(xid), nn->maskbits);
+	return hash_32((__force u32)xid, nn->maskbits);
 }
 
 static struct svc_cacherep *
-- 
2.43.0



