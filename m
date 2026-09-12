Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB992BEC43;
	Sat, 12 Sep 2026 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211723; cv=none; b=GO7J2dYfLvqlvay5C27c9kCmc9gJH/Xxiyyr0rVG//jEeeeSen0ZsC0hPON7cul4+Q9furi/qta8yj3CnLuIqlmrwTFiLdN4ajRjNTIm3yzGApqVVYeK69jKdNpbapb3/qnmzKWBpkB11UmgV9pdlDiZppoIPV9FMsl+P/i8sAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211723; c=relaxed/simple;
	bh=Pw8sT1LcswugQ5Vt4ZNggBOVCxYzn4ciddmXdzYUyQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g77gvdgIb2maABbRkG1maiqfuGbQ3uXqiDWXeHN+e4ZA2J/rzUsZhsaoeUvkU/HBgIbMz0e6QLrkii7IemKc0q+aF4eYsFiDXgUugHPmbW1tv2mROkgHehNfaypStxWcY9FgKxv/hF2xZIdlEYR/mFm1+aq1GhdEW36HWblN5HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqLKGiP5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqLKGiP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E451F000FF;
	Sat, 12 Sep 2026 11:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211721;
	bh=ba403XzyZ07Kq/R5/wTIeYaGtYvR6tKQyC2fI9YUlfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqLKGiP5HI3/r+n3/O0D54m/XTbf59oA2qckd52CoVjJyywqflretVWb2r/5CGo7o
	 2TaDZpzob+Xk7uH8koHoEWpFwRjlF18KS4Fb3k3R2dBjRyIKWLSBtWnfMKzg/ODPa0
	 Jwqq8xKbiSI1VS+/n6ywnJI4CoBtyfBdBZgk5o9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agatha Isabelle Moreira <code@agatha.dev>,
	Arnaud Bonnet <abo@medichon.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1246/1518] nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper
Date: Sat, 12 Sep 2026 08:56:55 +0200
Message-ID: <20260912065651.694461322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 8c2bfcc323e02..970e67768d67e 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1546,9 +1546,7 @@ int nfs_clear_invalid_mapping(struct address_space *mapping)
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



