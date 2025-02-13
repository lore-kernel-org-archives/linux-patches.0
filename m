Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B04A26B096;
	Thu, 13 Feb 2025 15:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460725; cv=none; b=lx8y+9dX0yWu9rW88LPUen0yHqarr+oLf6cvHOE/lfSGPUdftdC/yIj0noH5mF1eTwOcQxo0pC1g187om8M7YBKSf1lLzWL3Og7RBjwPTiFA1YNg9rzeSEpxaIuckD2El6hZOoJoAFRjTzsWBKEXO2p3WMJbGCVBOdlWC2PWDdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460725; c=relaxed/simple;
	bh=s5ecC1YQmFXSTXrRAT/DUGg8Ec0+bvV6+kzD7NAHH68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkkmX31Nfe+jrsluVJ6jiAkHW08XQvvJyEfbSAbgp+hf+Oqi5IKgwp/ImidzTWJvDHa0B29ABkVluhqzjL40B9ia+6w3f+vMcGKrGCTxc7QDehJzH2dCmi7W5v/iys4gx9mxXO6Jov9sLylxFoTfeTC4SH+r5hYB+qSDbC4n0Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FoffpYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FoffpYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A181C4CED1;
	Thu, 13 Feb 2025 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460725;
	bh=s5ecC1YQmFXSTXrRAT/DUGg8Ec0+bvV6+kzD7NAHH68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FoffpYkoAnIxU/ll/qsWtF1+5KDfy56CFuSSoMEHFMNEccXqknqdtdYEfpw8Sanr
	 /PJaQVOLMMDYX6hUms1nyYS6lHDDFSmIsvnOv7PJ/ytpgBA9fN2pzinWNWxHAgHQ3U
	 yT4I7HHUGChB788k1bS0czjOAu0JqEZ1yn2Bc3xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 194/273] xfs: Add error handling for xfs_reflink_cancel_cow_range
Date: Thu, 13 Feb 2025 15:29:26 +0100
Message-ID: <20250213142414.991511182@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 26b63bee2f6e711c5a169997fd126fddcfb90848 upstream.

In xfs_inactive(), xfs_reflink_cancel_cow_range() is called
without error handling, risking unnoticed failures and
inconsistent behavior compared to other parts of the code.

Fix this issue by adding an error handling for the
xfs_reflink_cancel_cow_range(), improving code robustness.

Fixes: 6231848c3aa5 ("xfs: check for cow blocks before trying to clear them")
Cc: stable@vger.kernel.org # v4.17
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1738,8 +1738,11 @@ xfs_inactive(
 		goto out;
 
 	/* Try to clean out the cow blocks if there are any. */
-	if (xfs_inode_has_cow_data(ip))
-		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+	if (xfs_inode_has_cow_data(ip)) {
+		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+		if (error)
+			goto out;
+	}
 
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*


