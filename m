Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708923AC17;
	Sat, 12 Sep 2026 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225740; cv=none; b=bjdN0l0Bju8o4LhvbR2VdXx5JmfJJbVADXifauGgbaPtxK0x2mlSmL/cxULuB/AueuPvaYCbgBDfrtXOom9ArZwEemJbpoCtOpFYJvoR7rA4qMWdDs7LuCBFIirQid/9EqQOyOSIqfKOJSQxNKzKLrqUaNhvsyLGs+x2bq/6Xdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225740; c=relaxed/simple;
	bh=sVVMt6QwcryvroZ1mU9IgF2ps0IxvxM8MJcR3o4vch0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isFnHB+FY55SKGNXFO0UBz4yQPeEixqSXAPzWJNwyGd8wadUiVPqzpa98AmuxProhObFNa6hV8Gt1L6DSu9uwHClkOt8DHjbXAoi28aMrVKRWHMjbcMQQc4wQhGm2OpsXZW83Iew72/GyARHFY72qyFiufNNJucbfjgm4h70XOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hxX+JVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hxX+JVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B301F000FF;
	Sat, 12 Sep 2026 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225739;
	bh=S3OUbxscva6Jax0y09EOaFwOBeqI3+iuVO67sVpICtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hxX+JVpnsjeiGwDXFy8UKRoSM0Sx8Vdfu0Q9NqRqbCr2gXRoiKyAAiTrAlBZNIg8
	 WHbWlqqOv64YqwqlkpPqqREojtfsGsS9aTBldETteVwoiB73mVEz2fDHltZhjJd6St
	 KBrhsFI/dy/HFmG5jwPiQ3SSr/H2MmrVbZRP2230=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agatha Isabelle Moreira <code@agatha.dev>,
	Arnaud Bonnet <abo@medichon.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1258/1424] nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper
Date: Sat, 12 Sep 2026 09:01:30 +0200
Message-ID: <20260912065635.452169112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 0d7facfdafb95..08326986650ac 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1376,9 +1376,7 @@ int nfs_clear_invalid_mapping(struct address_space *mapping)
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



