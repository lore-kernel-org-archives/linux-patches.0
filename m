Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459211F2C45;
	Wed, 23 Apr 2025 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420337; cv=none; b=fxk3kPbZKS3bQfOQmdeDLD+areqUkZ+oqIcf5Pid4JQA2gkAuvI7q1gH4kM7TkEUTE9SQ01CCjXVq2TjSB0XoaUZesLlLnfx3B78PvnV29oWNn2+wR9PTUgzrLzBuEnwN0XJgdJMQfi46Zhoyvsdb4fTpw3Q4t4GvTwp2PWtwv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420337; c=relaxed/simple;
	bh=fSyk6Nk1zIncrkiLswybBoVKLW56iizZu4cVCvIJBDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CI8mObkjK3UP7DlKie1cRH5quQLE04fOMzXmlPv7ZZjI/A+1I3YoXgwWY1V7p4Hca4O9EQX7AzshC658xZ85VHFYQfWHFRoBkd7+E+/LslJjdxezdYuklPhoNsRovJMe+2lHNr7TaVMSXkAO2Ifny+x6f2ErCeXEvc4OnfRvkRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g25wJ+Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g25wJ+Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF1EC4CEEC;
	Wed, 23 Apr 2025 14:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420337;
	bh=fSyk6Nk1zIncrkiLswybBoVKLW56iizZu4cVCvIJBDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g25wJ+KpCOoWeJTqis2d6CY2MD1V4eiWkJRbUPvG9qneuO/vZiNzXWBWm0M0+961T
	 rVUesdpOnIzjl9Q1ODIkpyQyswuX3LmhYwoaKOLosmHE4ubrh5ApPj0QjHqlNEfwRy
	 QTddeRlFQbID14fBhMSPpfZ8cyCHO8zuRMxA0pGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/291] fs/jfs: cast inactags to s64 to prevent potential overflow
Date: Wed, 23 Apr 2025 16:40:27 +0200
Message-ID: <20250423142625.948421773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit 70ca3246ad201b53a9f09380b3f29d8bac320383 ]

The expression "inactags << bmp->db_agl2size" in the function
dbFinalizeBmap() is computed using int operands. Although the
values (inactags and db_agl2size) are derived from filesystem
parameters and are usually small, there is a theoretical risk that
the shift could overflow a 32-bit int if extreme values occur.

According to the C standard, shifting a signed 32-bit int can lead
to undefined behavior if the result exceeds its range. In our
case, an overflow could miscalculate free blocks, potentially
leading to erroneous filesystem accounting.

To ensure the arithmetic is performed in 64-bit space, we cast
"inactags" to s64 before shifting. This defensive fix prevents any
risk of overflow and complies with kernel coding best practices.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 6509102e581a1..3d4c7373a25e0 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3666,8 +3666,8 @@ void dbFinalizeBmap(struct inode *ipbmap)
 	 * system size is not a multiple of the group size).
 	 */
 	inactfree = (inactags && ag_rem) ?
-	    ((inactags - 1) << bmp->db_agl2size) + ag_rem
-	    : inactags << bmp->db_agl2size;
+	    (((s64)inactags - 1) << bmp->db_agl2size) + ag_rem
+	    : ((s64)inactags << bmp->db_agl2size);
 
 	/* determine how many free blocks are in the active
 	 * allocation groups plus the average number of free blocks
-- 
2.39.5



