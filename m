Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC232931C0;
	Thu, 20 Aug 2026 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247938; cv=none; b=M/E5WQ/BQypxpDfO3+1SqjifqCEEIC+Q5+/o3m65ypmMh7I+90QFxPbRZrqYLbsCZ4hkaxViPvw8swyWjHNdeSE4wg/K5t88hrbyvjc9tbF1tK/J4EWNBRJ6rOd1SFs9uKBayRc6HPKICBRlV2fwPPzAoAzRhjGOJOsIdZF0hlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247938; c=relaxed/simple;
	bh=UPkJ+j5QxYutMpJRKYTUlharmN3HVgVcqsRl5ovIV0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0/KjTNGmyVdcpVBHDLqedSr3zbK6cFFoIZytkRZbpeo70LsY10EXqF5SZzI7oq6Ixdv8H6X4KpX7IystKjjSlJ8X1I1RNh5LryvJNQIWDqMs2ICigDTTRQmTvUxwV1JflPgA4k8UqvQvG0ZR3SnSOMmuZ58aBuxwICNBpqXSIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/E7sB9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/E7sB9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031D81F000E9;
	Thu, 20 Aug 2026 17:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247937;
	bh=VC+1mvGsgecT1nTJIZ5yt3NuJiUxkT907ozuY+Rh4aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/E7sB9N1XBz5pYgb7m3YJIddRP6rZYRrZB25XF1sryVANjmb47qkql1sH4FNLJk8
	 pxB1DwwXbN99JwkEj2RXLPDYjIiJ6ghpU74ujYBYpU3usywmorQ0pTfvOt/UR7+lZI
	 Yq4mi7taXnU8T/B0a9bp5to8r5ldnts7huUBMDAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 053/303] xfs: check v5 superblock features early
Date: Thu, 20 Aug 2026 16:53:09 +0200
Message-ID: <20260820145254.765155345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -864,10 +864,10 @@ xfs_sb_read_verify(
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


