Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C99A2FE042;
	Tue, 31 Mar 2026 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976755; cv=none; b=bgFIAE7942gsTZrCem2TblNkeIxVFRZuAnDfLDSg2UVRzDEVK+UPiKncHTqkIDiutOIGwO2dq2g2pCpn4LSoZIRT9cxQLb4MWQlLGFEtNZA46FTSvWyV+eV2b5db7ANBvBVx0mosKKOqhe/BLAHjcHWskTm3k4rh9L5hZNzomg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976755; c=relaxed/simple;
	bh=K1qgHuU6FxK/+pfmQFNJs1EldLOOKLGEI0OQ7w1bRug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6S3xctfy9F13hYjvkG5NL701hjsE60gabR1OxsaO5e6/lVdKdhYBb7qTanU6hZ5G4a6YzA6TiGNVnh1zdG8rOSsGgZiOh7zL77P2OoZqiSyZOhnJIFnD7hZDTTAyBUssmLJ+VD7prXT0tCZxLrVq4a37Ux3uS876BObKqbwD1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFKk4nd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFKk4nd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D97C19423;
	Tue, 31 Mar 2026 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976755;
	bh=K1qgHuU6FxK/+pfmQFNJs1EldLOOKLGEI0OQ7w1bRug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFKk4nd72sqPP9knoQ/Ke+8ZxXomIPz5naPgTqnB+zPRUAxBY9F02iVndFaOMkmPa
	 5msU9k327lOMlkX/4/cEvw0gJQ/3KHFshvvl6gUv+jCKYX1SJIRLR+ZikCin+koRBw
	 5M+FacudWsrJq5jUUpvXLjpE/chNqsoBAjQ2G35Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 216/309] ovl: fix wrong detection of 32bit inode numbers
Date: Tue, 31 Mar 2026 18:21:59 +0200
Message-ID: <20260331161801.399807842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit 53a7c171e9dd833f0a96b545adcb89bd57387239 upstream.

The implicit FILEID_INO32_GEN encoder was changed to be explicit,
so we need to fix the detection.

When mounting overlayfs with upperdir and lowerdir on different ext4
filesystems, the expected kmsg log is:

  overlayfs: "xino" feature enabled using 32 upper inode bits.

But instead, since the regressing commit, the kmsg log was:

  overlayfs: "xino" feature enabled using 2 upper inode bits.

Fixes: e21fc2038c1b9 ("exportfs: make ->encode_fh() a mandatory method for NFS export")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/util.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -90,7 +90,10 @@ int ovl_can_decode_fh(struct super_block
 	if (!exportfs_can_decode_fh(sb->s_export_op))
 		return 0;
 
-	return sb->s_export_op->encode_fh ? -1 : FILEID_INO32_GEN;
+	if (sb->s_export_op->encode_fh == generic_encode_ino32_fh)
+		return FILEID_INO32_GEN;
+
+	return -1;
 }
 
 struct dentry *ovl_indexdir(struct super_block *sb)


