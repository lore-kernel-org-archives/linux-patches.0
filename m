Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2354320CD3;
	Sat, 12 Sep 2026 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226869; cv=none; b=MPQEM2pr8nqWc5IiaIh6ECHoQjIgFF6jvYFbUj1g+Yfh1ZH8yeSJdOL8g7vr43JErdmoxvcGrP2xESdvLTcsiv+GlN0K8EOCxYEn0TTBfwnc3Tf88esVk6qSoNMu1jQcPAxiu5jOkxAj+QQghoQLSszOtTc6TCv7dgbHjdc8zMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226869; c=relaxed/simple;
	bh=0L00bPfmRghn2dz2y7eMAo+yEepdT+SiDuKhUb1GBfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+qXJF/nrZ3nR1KeSbrh6ARWoSK/sKpjXBCFNKAtuz9Z9L471+9Ne+ZYWu7O9+PCXm1juvOBVMN+Pk3p6b0P+H46JofAGPV999lsNmg2FrvFbfODJo/nTAc5Rcm5zULm37yxX9QZDqbOpa+kY582A4dvgjhEZ3WILHQVdO74jDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSravTHS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSravTHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68871F000FF;
	Sat, 12 Sep 2026 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226868;
	bh=IwR3SzsvxJ3UM4qeflLGfDCmkrJtUcmNCTcCNNMoxFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSravTHStv9ebfnwYJFu8dwVqmunG6g+YrczdFS60RX5BbK3ezLfTJ+USCfu2tKw7
	 dwCOutFyeNGwM4o8/Z0uZYIWcQe2rdx7Vv3SjAA5YWswCRlO0frFLA9DBzBU4eVf5Q
	 Q0t8AUVY9SGIKrrAaZ7LXELgwuYaHSezx1rT7WLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 0066/1191] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Sat, 12 Sep 2026 08:46:34 +0200
Message-ID: <20260912065549.641916518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit 6c322f5cf7476ded7a9a20f7be72462065a03c68 upstream.

With len == 0 (clone to EOF), the effective length is computed as:

    len = src_inode->i_size - off;

If off > i_size, this is a negative loff_t, corrupting the ByteCount
in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and inverting the range
in filemap_write_and_wait_range().  The existing off >= i_size check
fires only after the ioctl has already been sent.

Snapshot i_size_read() once for both the bounds check and the length
calculation, eliminating the TOCTOU and 32-bit torn-read risk.  Reject
off > src_size with -EINVAL.  Treat off == src_size as a no-op,
consistent with __generic_remap_file_range_prep().

Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1317,8 +1317,19 @@ static loff_t cifs_remap_file_range(stru
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
 
-	if (len == 0)
-		len = src_inode->i_size - off;
+	if (len == 0) {
+		loff_t src_size = i_size_read(src_inode);
+
+		if (off > src_size) {
+			rc = -EINVAL;
+			goto unlock;
+		}
+		len = src_size - off;
+		if (!len) {
+			rc = 0;
+			goto unlock;
+		}
+	}
 
 	cifs_dbg(FYI, "clone range\n");
 


