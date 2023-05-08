Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0038E168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AB2C433EF;
	Mon,  8 May 2023 09:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539789;
	bh=gZ+bRMauUXwl5no0RP9+NqdPeV2jwAvkv3NtuIAfj0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQ2BNo4YXkUDoCPkoH9SBWwMS3Yba8DhyGgh2WM5tBy5hA6bvFcKHgSkWNBM+oJXV
	 AScruA4oZT/OiT0ZHAlY9BPKyDEvWnVKhSAoqIj/Ey0JSZmZM7yhEYCG9QXfaa0J8e
	 2ZOz8CJgDEs8DVMrWyPcRdl0rIe7E1QXwx9+jads=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6.1 107/611] xfs: dont consider future format versions valid
Date: Mon,  8 May 2023 11:39:09 +0200
Message-Id: <20230508094425.723503024@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

commit aa88019851a85df80cb77f143758b13aee09e3d9 upstream.

In commit fe08cc504448 we reworked the valid superblock version
checks. If it is a V5 filesystem, it is always valid, then we
checked if the version was less than V4 (reject) and then checked
feature fields in the V4 flags to determine if it was valid.

What we missed was that if the version is not V4 at this point,
we shoudl reject the fs. i.e. the check current treats V6+
filesystems as if it was a v4 filesystem. Fix this.

cc: stable@vger.kernel.org
Fixes: fe08cc504448 ("xfs: open code sb verifier feature checks")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -72,7 +72,8 @@ xfs_sb_validate_v5_features(
 }
 
 /*
- * We support all XFS versions newer than a v4 superblock with V2 directories.
+ * We current support XFS v5 formats with known features and v4 superblocks with
+ * at least V2 directories.
  */
 bool
 xfs_sb_good_version(
@@ -86,16 +87,16 @@ xfs_sb_good_version(
 	if (xfs_sb_is_v5(sbp))
 		return xfs_sb_validate_v5_features(sbp);
 
+	/* versions prior to v4 are not supported */
+	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_4)
+		return false;
+
 	/* We must not have any unknown v4 feature bits set */
 	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
 	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
 	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
 		return false;
 
-	/* versions prior to v4 are not supported */
-	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
-		return false;
-
 	/* V4 filesystems need v2 directories and unwritten extents */
 	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
 		return false;


