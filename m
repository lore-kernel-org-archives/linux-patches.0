Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C562DC792;
	Sat, 12 Sep 2026 13:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218611; cv=none; b=vDbTteTVWiUUccFlkCl54sSUUzDuxdTn88YEvTpcw2xRt+vuOaJjMIm/kkEOFxLazFAdz2AAM1zpF0YWvHj6lZ/OFuOJHnET2YLWMz/YG3/qoL7FiUoSAk7RSBH9MePYDfCWaaIP+NIQ3CeYLUWOgWv2KaMr2GS+vLK8qpfTGXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218611; c=relaxed/simple;
	bh=uEr3yrE0CdsIF0PgJavrvW2UoCOLP08OdeE2hoATvBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4dXD25JNJSi8FmG/VPjqTe4escLztH8p6iNFHPvm66gfns181gcGavlSAopigVuu/2BTDmte4pIcW8/pKYmUTgDYmuMVhsxhOj3AoHJwo4zlfR2Efz2MsQW9g3Ziny+YvRVXqQEmW6yBomXo//3P/OxqPnrnGvEmuR/5zog6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYX87b4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYX87b4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8361F000FF;
	Sat, 12 Sep 2026 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218610;
	bh=DL5yQYqRrP5AZwigs/x9MIIrrexa0sZgRK/oZqlZ+Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYX87b4YqMDOEM/wyneW09PrnCH/lDTuRdS/ld7W5dqYrnIuuoNBuwYcxGtPRddrK
	 ziszHSNbhOUU7tn6gzMkP88aXc8RLNLC+ZcMUY94wpczHdj+xtPfBAjT7Kvw1Q45u+
	 c60xeXpWok2GGSO5Gd14m4io2HyJHXfg9N5uqRAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agatha Isabelle Moreira <code@agatha.dev>,
	Arnaud Bonnet <abo@medichon.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1180/1376] nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper
Date: Sat, 12 Sep 2026 09:00:06 +0200
Message-ID: <20260912065633.850989590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 1b43331eb6ece..a1e65cf3d8c9a 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1504,9 +1504,7 @@ int nfs_clear_invalid_mapping(struct address_space *mapping)
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



