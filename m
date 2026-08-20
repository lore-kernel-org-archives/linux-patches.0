Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2C9468C17;
	Thu, 20 Aug 2026 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247503; cv=none; b=GrvFRJTsYzqiFjO0YyayWEsfHGK/SFPisP+Xuox1taiJzN67+T+lOQHPCivo1lBTFDnJtWcmUHdj1hhm3SgUa5oCpzhTF4zut6u4rswzscEmO8mWiYiTfVpm1NGTPM92+1CPeaVKoYw0WPrB4dOtMXOeo0+PAuw4iH9n+VxLuDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247503; c=relaxed/simple;
	bh=FtpB53NF2dR58uO/KDi3i/hKT2H61nVzyZ5s+b2ueug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCN9LhqMQfnaUF7u61xcB7YimQgaV1x8B2YfEMJR9N3RluhJVa+KNEL5Daa3WBhUqVe3qBhoS7CTygg8GyjEon32yYsxMK9VMvjxuUt0szfLXCtLTYb+mpUFYuHf+/kNaQaFIlAGOwOphhDVxwJuL0naW98B+AtDfzdA9PWtwLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKjR4WMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKjR4WMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992D21F000E9;
	Thu, 20 Aug 2026 17:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247502;
	bh=8MId+fyLu4w2bu6qnO7M115Cuem5aBmzalGCB4NO7F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKjR4WMMwy5EkaqsHWQDUhcd5DaOC2NX4t8f8BDgkoFAdyRciigYDNhCkTjV3QhND
	 OxAq2Mixrgem1qffdNZmnsrWY+65greV4qWW8Ne0eoESDOOZc65yDHtdxSIcNH832+
	 r85O4vGT6Mc3uC1aOYLAyjrzybp60KnmnyTq/L+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 067/166] xfs: check v5 superblock features early
Date: Thu, 20 Aug 2026 16:55:26 +0200
Message-ID: <20260820145213.159495986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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
@@ -865,10 +865,10 @@ xfs_sb_read_verify(
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


