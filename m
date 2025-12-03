Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AA015ADB4;
	Wed,  3 Dec 2025 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775979; cv=none; b=VIBd/PECS9yoH9pc6v/UM00dnJ3wQlM2/WILcnZVojR/SprlKUeo2V8Aj4nN7ITVapoe+AO+c5bqkK6iT+HbtYx/07CM2KbqSqgSezw6WiICFh2L3Jqc51FcXjJiXLsF+ASZI173Nxth1wQNmpPykAjVlSEm6VES43RNDeR0WhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775979; c=relaxed/simple;
	bh=YJnTz/yE5SevmFowk2YZuq5ZCyKswDWbpUILtUn3uSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NX03DZ/y58RIGIz/c8lrktx91VisuwK/uiMLw8HkAahAgO4k3YHD+Gvo3llvucTpljQFQA1ZWNiFJjZMJjerY3nJjzyRzHU6ONUSmivKvyf05qI3NxeFGkZamRf+ylBknx5B4RoURRLisSkBYorFtCyBXjcTDo+ZVTxD2L7goak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ru7dQSqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ru7dQSqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C59AC4CEF5;
	Wed,  3 Dec 2025 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775979;
	bh=YJnTz/yE5SevmFowk2YZuq5ZCyKswDWbpUILtUn3uSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ru7dQSqxAZ+avoqPftOzKW31R6h54CwUUAHcM4UWQRcNqSihfLbr8L8N+4DuC6r2g
	 uzG8g0YwtuOGPMfOunVjSsTP14UpPKlV+ERFZXJNlu0b/X19w+h+OY2rkdq2LA60Bz
	 t1VHBtWIJ85gLVdNDlef4YOaOFfCE7kK9YO+pcOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/300] xfs: always warn about deprecated mount options
Date: Wed,  3 Dec 2025 16:23:51 +0100
Message-ID: <20251203152401.465791988@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted m_features field reference to m_flags ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1162,16 +1162,25 @@ suffix_kstrtoint(
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
-			!!(XFS_M(fc->root->d_sb)->m_flags & flag) == value)
-		return;
 	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
 }
 
@@ -1314,19 +1323,19 @@ xfs_fc_parse_param(
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
+		xfs_fs_warn_deprecated(fc, param);
 		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, false);
+		xfs_fs_warn_deprecated(fc, param);
 		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_ATTR2, true);
+		xfs_fs_warn_deprecated(fc, param);
 		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_NOATTR2, true);
+		xfs_fs_warn_deprecated(fc, param);
 		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
 		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
 		return 0;


