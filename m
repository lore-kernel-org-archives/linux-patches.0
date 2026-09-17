Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045AB4E533E;
	Thu, 17 Sep 2026 17:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666709; cv=none; b=sqzcY5VrNTMFoK3vOMMgI7/8gp7TQFd8Eq9IxaQlS4CXMXXrZgHgpBgtOoq9QyD531Bd67B62umu1a2IT6eRPgv/OFL+jdA2SmlWYGB8ApSUnGzJT/QqRPB/GLl3fwWxUxSEql45f7h131UVxcy+gtWfdtYbEpiZbJ+fdcU8T7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666709; c=relaxed/simple;
	bh=7yxwrVP6IdJfsQ7T2VwAHHLNKDpY7PTX/4qDRLLkTLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFthyFDrMSoZk+DzgP6QtThaATWFQiRzVN0SLT9lM/BuHX86JecptilX4Inn22t9ewbK02THQOod2NNDXPP7EbmBAvoJnRHV2NOLvmTin/8nJtFm7I1SLHdwYZ7gwAR9bc4/vzl/Og1pljYEODaASJ4Mw8Fzk1uoDi3wcJWijr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqRM8vd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqRM8vd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A981F000FF;
	Thu, 17 Sep 2026 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666707;
	bh=FtCF6Lt1IF4tPnqtIsV/bQI6sy0mQfMVQvUTC5UDgv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqRM8vd5AZIa2kfiPhaqs0xgqSFG6sdDA2XY/O2DZfSAf9bqY126DLKgYrcA4kqnP
	 UTLdXu9CuccIH/kxT09mWMoZFgnjUlhA4Vp9lbwrOBuUwrX87fEkUdzDIOJHMV1UL0
	 l/YFD0/Qg50mCVGoI0tb+HYYj0ER7y9LRsV6XIoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1127/1250] xfs: actually check internal-rtdev fields in the superblock
Date: Thu, 17 Sep 2026 16:15:22 +0100
Message-ID: <20260917151622.792523733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 1ee2ce797c360785a3813fef62c90f427f3aed34 upstream.

LOLLM points out that the superblock scrubber doesn't check the new
fields that were added for internal realtime volumes when we added zoned
device support.

Cc: stable@vger.kernel.org # v6.15
Fixes: 2167eaabe2fadd ("xfs: define the zoned on-disk format")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 1fa66aa68e16..fa5d32ec020a 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -418,6 +418,13 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 	}
 
+	if (xfs_has_zoned(mp)) {
+		if (sb->sb_rtstart != cpu_to_be64(mp->m_sb.sb_rtstart))
+			xchk_block_set_corrupt(sc, bp);
+		if (sb->sb_rtreserved != cpu_to_be64(mp->m_sb.sb_rtreserved))
+			xchk_block_set_corrupt(sc, bp);
+	}
+
 	/* Everything else must be zero. */
 	sblen = xchk_superblock_ondisk_size(mp);
 	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
-- 
2.55.0



