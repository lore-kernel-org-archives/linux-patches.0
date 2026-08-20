Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F6037E5E5;
	Thu, 20 Aug 2026 15:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239036; cv=none; b=BlmeMg9Wq3GnnEt8b01QQA8NQP9Oc7lhX+4p+va+GkdU8pK8M/AJiFsR2cwlnALh5MNaWTX+232EqmbnKpADvpGECwTradNtEhEJ2VIvkDx5ZxUcjZo8TjdwQynQxoApEcDlb/IUVjvbMMJK04RIyjCRiT2JbfEDTU0qvyP5wJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239036; c=relaxed/simple;
	bh=3EUtUAyYa6ye1ugm1G1kgtW1Ccg8M+FmEzmjp53o9rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHf7NFvIPlilKyZ60ljmiy61KjU6RYk4DJRsGfrp4F2MpZbiwoILRA+7SOQiJj7UUvDbi4UmH8ZnoHZk9mkKKhBUjE5RH0tgzOF4mBDhVRfbCKrRY9l92wE0ZghU50a8Pc7lzHd9ohN+xHCxr5g64j2PIMjY4Ua4IUCFvXp1E2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXW7Kg1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXW7Kg1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1584E1F000E9;
	Thu, 20 Aug 2026 15:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239034;
	bh=4VGyIA505+qwbm3yXbCPTvcCUXK2sY5ur+QXBV432zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXW7Kg1o3xM+qOJfBCYId2taTBymko0Fy7T1lMSQBg+0P4JGVBRw8xbl9eIy3i5iJ
	 IMjU1ctz6ngE925CVyXXI9d5afjDexRe73MgGnKcS1y2MAW47Fje25T4w945Cbk7Do
	 9kGl2OGCaufewQF5c3Q0nYuIMZ/67chIvnIbz6PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 128/217] xfs: check v5 superblock features early
Date: Thu, 20 Aug 2026 16:54:56 +0200
Message-ID: <20260820145241.584242720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
@@ -1118,10 +1118,10 @@ xfs_sb_read_verify(
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


