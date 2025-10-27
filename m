Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2C132D0C0;
	Mon, 27 Oct 2025 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592094; cv=none; b=E4ayNcyNst09jT1vZgwWbVtKLBrCnxzm9IH3p/CZLFcPHAoRP9OEFdG+ha2AnEwRbl/66wXdMfiLPYul8ln+Kft1518q1IiM+tGocQDZLWiaxEmPdSXfQbi6roafT0FYx7VQeKIPR+CehL//Di/fhvIXnD4o2+FDR2RsD+I5xzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592094; c=relaxed/simple;
	bh=2BGDq72nEvaerL3K/q0XoQym4ThkDFpnYYyoLvzSEGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJRds3aYnr33doS9JvYYQcWa5RGIeyJEL52MUgeGigb0rb1U2yuvJARdsCtF8l9JZcuMGS7jp5c07Pzw3MUVHCFxatqgMB66cUQNcVfwiW+oGYphAsYGealQg3o8w3w0J1tnvRBe9KVzQtL9tv+DCx7LMz479Ep6HI7u8MlndAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOI0rI4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOI0rI4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86E3C4CEFD;
	Mon, 27 Oct 2025 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592093;
	bh=2BGDq72nEvaerL3K/q0XoQym4ThkDFpnYYyoLvzSEGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOI0rI4YqZO6t56Ba7XCWTc2iVMu1Kc0XXzI+fNxiLQ6PJ1LeB4ihJqP1kiZATGSQ
	 M1UESm4NxfgRDiBrd9Yd1MxJvnnFyW3d8fs3RB5io/1KQ3g4N9kKmyVya3gJDptjG/
	 B5XnhcFzxHSXkp5HwKudYXV2fJaPKmVFytMK+ze0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/123] xfs: always warn about deprecated mount options
Date: Mon, 27 Oct 2025 19:36:35 +0100
Message-ID: <20251027183449.463819408@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 630785bfbe12c3ee3ebccd8b530a98d632b7e39d ]

The deprecation of the 'attr2' mount option in 6.18 wasn't entirely
successful because nobody noticed that the kernel never printed a
warning about attr2 being set in fstab if the only xfs filesystem is the
root fs; the initramfs mounts the root fs with no mount options; and the
init scripts only conveyed the fstab options by remounting the root fs.

Fix this by making it complain all the time.

Cc: stable@vger.kernel.org # v5.13
Fixes: 92cf7d36384b99 ("xfs: Skip repetitive warnings about mount options")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Update existing xfs_fs_warn_deprecated() callers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1178,16 +1178,25 @@ suffix_kstrtoint(
 static inline void
 xfs_fs_warn_deprecated(
 	struct fs_context	*fc,
-	struct fs_parameter	*param,
-	uint64_t		flag,
-	bool			value)
+	struct fs_parameter	*param)
 {
-	/* Don't print the warning if reconfiguring and current mount point
-	 * already had the flag set
+	/*
+	 * Always warn about someone passing in a deprecated mount option.
+	 * Previously we wouldn't print the warning if we were reconfiguring
+	 * and current mount point already had the flag set, but that was not
+	 * the right thing to do.
+	 *
+	 * Many distributions mount the root filesystem with no options in the
+	 * initramfs and rely on mount -a to remount the root fs with the
+	 * options in fstab.  However, the old behavior meant that there would
+	 * never be a warning about deprecated mount options for the root fs in
+	 * /etc/fstab.  On a single-fs system, that means no warning at all.
+	 *
+	 * Compounding this problem are distribution scripts that copy
+	 * /proc/mounts to fstab, which means that we can't remove mount
+	 * options unless we're 100% sure they have only ever been advertised
+	 * in /proc/mounts in response to explicitly provided mount options.
 	 */
-	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
-            !!(XFS_M(fc->root->d_sb)->m_features & flag) == value)
-		return;
 	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
 }
 
@@ -1326,19 +1335,19 @@ xfs_fs_parse_param(
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, true);
+		xfs_fs_warn_deprecated(fc, param);
 		parsing_mp->m_features |= XFS_FEAT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, false);
+		xfs_fs_warn_deprecated(fc, param);
 		parsing_mp->m_features &= ~XFS_FEAT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_ATTR2, true);
+		xfs_fs_warn_deprecated(fc, param);
 		parsing_mp->m_features |= XFS_FEAT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_NOATTR2, true);
+		xfs_fs_warn_deprecated(fc, param);
 		parsing_mp->m_features |= XFS_FEAT_NOATTR2;
 		return 0;
 	default:


