Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE0A81725;
	Tue, 18 Jun 2024 13:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715826; cv=none; b=s4aH6yfwqA6VxVMS4Kfgec4x5y2wumtjaLD+hGOdcSMritFWFwl0xsygjJ79SFxgTUt1zI2TQ60GAF7Pf0O2IQHq0db2L0Wcfm3xB2gV37nCdOrAAhg/6Si/WwzxnqafKuwxTf2zjRyQXug2natBPk6LMpzIkvzA74r0UB9RPoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715826; c=relaxed/simple;
	bh=CtvRZgk3s5tktDCh14YrCog8F0qtYEvGOQw6hcmO6bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6fdMqCCTiuVcRdzUv0qo/+P4nrXFW7OOu1JYp2gqMelLk1MwQdsVpyHHvSY+OW5bOU5m2fUVIDYa4lmEkBNYLTHWN+o8ulbHxep5Ux1JGiAgKrnb1VErf3RyaPq1bYk23a/sgFDYjxT9eHjoXAshxLTc5wFJmN/iq+xMzBZTrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jykk+et5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jykk+et5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5289C3277B;
	Tue, 18 Jun 2024 13:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715826;
	bh=CtvRZgk3s5tktDCh14YrCog8F0qtYEvGOQw6hcmO6bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jykk+et55vu8DTzJ2xAeIjxPfry0DJdHQphR8xQDRXCGV+YPaQRB/+A7AwEtwMNSk
	 gqE21nv/D1ja/XipXqr5kq5+bwjdO99nH3JwMAzJQF3TN21SMrA5CYCqEc7KV8b1Ek
	 3cKJfkrvBsUNppSErQeMoJU0nYi5Z02/Rudf+Rr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 439/770] NFSD: Remove be32_to_cpu() from DRC hash function
Date: Tue, 18 Jun 2024 14:34:52 +0200
Message-ID: <20240618123424.233721223@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfscache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 6e0b6f3148dca..a4a69ab6ab280 100644
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



