Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590392;
	b=gPI8AHm4KPM0NUTT9F0JK/THbrNCP0KRe3YWwZJ3o3n2nXCkT894eANcytBKALPyEc0g
	 n/v+TEw7g92Z6ubb+EMKdhuDh4C7r8gh4xxX16KiDAYzUvMgQEUBsDztP/XB7ErIisn/I
	 PfZlJhQgGThHJ1hNcZ6vjO01jQitSvXDd0xDsbILHoJAxwIGIQo8I8OQdk0cdnhOUDCER
	 i6v4RJx+i7AAf8qdADqWkvcm7wna7H5beArH4Y8M4kUUr3mmWq3FFKPdSbkF7pKkw0oBc
	 gbgfzmgqscMsVC4AfeNiI5BD27dqwtbe5EIlouva9mTvr32U2PArSo1VeydoBDgn0cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhQeUrml+Iqk7B7cUistrcv59kYEHHiwdygMwEWkC8U=;
	b=MNk1fAESbZVowdQ2PEXXsKeO+5HjEMfTA3loHwvdR08PZgWsshaMVRnlKvSsXMoHz4eT
	 er83e3Ph5kgPfKh/ML+8u5bDETy9rvj/jkgycjbKWrIhZJjh86H/pPkkj8gWmS9eQqJiq
	 h5v6gMNpGl1ffiDJfXVFb6te/SZVnFs1qsdR+OnwnFI3TR+5YLTyoCu+ZvqUpf70pohAR
	 6vJc212WHp6AQBDL0JrE17TkSpo3nKS1kQqso9fNtnmYY8wIYiv8+UanG4QmJt8YhlGA+
	 Mt8crYySGUMSY3lmfPHufLo+JljSurDX6B3edARCL5uKwZ8kkMFhGyu/16GHiug+pfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCPWpETK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3942606B448;
	Fri, 13 Nov 2026 17:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCPWpETK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C2E1F000C9;
	Fri, 13 Nov 2026 17:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590392;
	bh=DhQeUrml+Iqk7B7cUistrcv59kYEHHiwdygMwEWkC8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCPWpETKSxYKsA8cTJJ8UmpMwd4n4sNLZNgpmgK3LZSu3iC24vgN2MyboD58ri2dg
	 p886eZ1U71TonEkqaT5IIwiboPnJym/tMTm1UcCltKBU/qAcCH6Amb4k9JoIQ2fgOv
	 ISx8/aGAqpU+SWUlT0l5/KVUx803wK58oylaUTJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 360/686] xfs: fix recovery of partial attr removals
Date: Fri, 13 Nov 2026 10:48:13 -0500
Message-ID: <20261113153833.103914841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 30bb61651d2da5a502cf504bcdad16c093c1bb08 ]

When running xfs/753 on parent pointer-enabled file systems with DEBUG
enabled, log recovery will eventually crash after a few dozen iterations
due to an ASSERT that XFS_ATTR_INCOMPLETE is not already set when
xfs_attr3_leaf_setflag is called:

XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 3045

This is because parent pointer use logged attributes, and the attribute
intents do not track the work that has been done as the transaction
rolls, and the recovery mechanism is to run the operation from scratch.
Because of this various places check for XFS_DA_OP_RECOVERY skip work
already done.  But while recovery tolerates an attribute already fully
removed, it currently trips the above assert for an attribute that
already has the INCOMPLETE bit set, but still exists.  Fix this by
handling the case like all the others.

Fixes: 1d08e11d04d2 ("xfs: Implement attr logging and replay")
Cc: stable@vger.kernel.org # v5.19
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 914f5dfb6463a..a6fe8a845079c 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2948,7 +2948,14 @@ xfs_attr3_leaf_setflag(
 #endif
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
-	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
+	if (entry->flags & XFS_ATTR_INCOMPLETE) {
+		if (!(args->op_flags & XFS_DA_OP_RECOVERY)) {
+			ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
 	entry->flags |= XFS_ATTR_INCOMPLETE;
 	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
-- 
2.53.0



