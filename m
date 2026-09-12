Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DC337AA65;
	Sat, 12 Sep 2026 09:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204120; cv=none; b=jzI8aufu1vTobGrvyIw3+dLHKNcH0s9rQOS/JLr+1TKyWY19A3XBQn+cxERj2qk21TZTklcUWrnYxVSzgUlR5R84TMygxu+dW7CYrYJlzo0OdahBjkBsAmZUPT/dEyDFdxAw0zca+QZIWrJJZafeHQGVmcG3dia5MJR9HYQl+8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204120; c=relaxed/simple;
	bh=T0d3ShlshWkdm9twG6FJFOhsGRZfmdA8Ld9l8gboeaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sArVZDHIsgVXSeq1sn+Gmcc/GsQo5Y4DvbmXAUVD7OWVppyk8AH5zs2YAX22lMc6MBpy0T8Hhb7oxhkNmnmMOgca2HAWdvAqsfRsxsMbSyYeOCPqxlSxMRD0IKOunNr3yU1N3E0UwKfMed+Lw3cIo+S8lQnKmQ7KiuQ3xjR7XEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGBTQ196; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGBTQ196"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11221F000FF;
	Sat, 12 Sep 2026 09:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204118;
	bh=Fn/kqSKBgMgQpwWSNcIDC5g4wY55/2SxfwZm9Ctokf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGBTQ196TNzcx+Wb+fNg/u6hb0GSK/K0KPWquPtsz65IL93czLDr7m06oGCG4UzyR
	 X9No6PTKoA4W36D/NavEeVhj92bLdkqlTSF7gnlG3Fljzo7natGU0Vq+bYkk1vI/V5
	 sCrV8MX2DIbeIJvjTONQKo+i2LFj1FTTuBmbbF1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agatha Isabelle Moreira <code@agatha.dev>,
	Arnaud Bonnet <abo@medichon.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1546/1815] nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper
Date: Sat, 12 Sep 2026 08:54:56 +0200
Message-ID: <20260912065725.296978169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Bonnet <abo@medichon.fr>

[ Upstream commit 61461050da42401b484d03e0fdac02878d235fe6 ]

Commit 8236b0ae31c83 ("bdi: wake up concurrent wb_shutdown() callers.")
introduces the clear_and_wake_up_bit() helper as a wrapper for the
common clear -> barrier -> wake up bitops sequence.

Use the helper in nfs_clear_invalid_mapping as inode.c already relies
on functions from <linux/wait_bit.h> and to homogenize with other
subsystems.

Suggested-by: Agatha Isabelle Moreira <code@agatha.dev>
Link: https://kernelnewbies.org/Beginner%20Cleanup%20and%20Refactor%20Tasks%20by%20Agatha%20Isabelle%20Moreira#task_007
Fixes: d529ef83c355 ("NFS: fix the handling of NFS_INO_INVALID_DATA flag in nfs_revalidate_mapping")
Signed-off-by: Arnaud Bonnet <abo@medichon.fr>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 5bcd4027d2033..e538736bb165a 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1531,9 +1531,7 @@ int nfs_clear_invalid_mapping(struct address_space *mapping)
 	ret = nfs_invalidate_mapping(inode, mapping);
 	trace_nfs_invalidate_mapping_exit(inode, ret);
 
-	clear_bit_unlock(NFS_INO_INVALIDATING, bitlock);
-	smp_mb__after_atomic();
-	wake_up_bit(bitlock, NFS_INO_INVALIDATING);
+	clear_and_wake_up_bit(NFS_INO_INVALIDATING, bitlock);
 out:
 	return ret;
 }
-- 
2.53.0



