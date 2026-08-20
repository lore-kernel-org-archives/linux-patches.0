Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39FA272E53;
	Thu, 20 Aug 2026 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243293; cv=none; b=OYzhoRo92BvDYYkcf6W5Q+PhO9KoDkYj2G5sE64SG6k2XC+25Ujn0z0qH3MHRRD/hMtp1ewOifG0OCJX4zC913wXdRFQLsmS/zweMy531NLeAWm+08zE+K9+BXzIDW0KDTjMMRld52rpX2+rd6GfL/WC+3yJvKcU0rnUttOJokw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243293; c=relaxed/simple;
	bh=5vIPJL6rl8DcuN+uJBgvkZGefysxSP30YacrFJBPtqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoVWQwrar0AwRqP6XLqi6pq12pnVijzLEOe4IfpXumgTqeTqVeDYlqpbHIbwv/RQz0EqvTYwOpoQ7BEUWb4C1thl30WriHuRO/+8zRT0Ygy4VXRMtCvg5drtPkOVr9TcQ3hl+SCUAPHcEqOLobV0ZQjQn6N2vHSEYC7PRtJjLRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYHJnBaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYHJnBaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AECD1F000E9;
	Thu, 20 Aug 2026 16:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243291;
	bh=6LDPjKJanuhp78Q4JZ4iNn1pPQEoeogtCiuK48sqmB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYHJnBaHd04vL7xzO2dAO7NMISOjbvjxk733ILFXV5iPuawtqkAbukV/62mSwXVMM
	 lBWmzL2Ohxp3KFyMMxH2cKoJh+7vip4L3RiGPA4458HkzUx9KTDLNIP5StHRs+kUlL
	 M+jTR+o1pFJhgcchR7f0g46XI1fPnrgm+f/sQ00k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 045/272] xfs: check v5 superblock features early
Date: Thu, 20 Aug 2026 16:53:49 +0200
Message-ID: <20260820145232.574117511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit eb6b2cc1fc8ad566d746d128a559989ff0bba5cc upstream.

When working on a new features that reuses the existing pad in the
superblock, I noticed that mounting such a file system on an old kernel
logs a rather confusing warning:

    XFS (vdc): Metadir superblock padding fields must be zero.

This is because we only validate the various feature fields in v5
superblocks after the common superblock validation helper is called.

Fix this by calling the feature validation first.

Fixes: eca383fcd63b ("xfs: refactor superblock verifiers")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -805,10 +805,10 @@ xfs_sb_read_verify(
 	 * because _verify_common checks the on-disk values.
 	 */
 	__xfs_sb_from_disk(&sb, dsb, false);
-	error = xfs_validate_sb_common(mp, bp, &sb);
+	error = xfs_validate_sb_read(mp, &sb);
 	if (error)
 		goto out_error;
-	error = xfs_validate_sb_read(mp, &sb);
+	error = xfs_validate_sb_common(mp, bp, &sb);
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)


