Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8396969950;
	Tue, 14 May 2024 10:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683739; cv=none; b=CZjl/bJv/2XUKADgBbl9O019G2qss/ONPULeZeSDR7lZmwbFdOprfGZHO40OW8XBaM3s/0ysUc+FnVcc1M2k8volkB0P5hJJYZu/YyV5/Tzkzoj36C9nf1IJqfTxm1a5WmzdkBJYAP4rpqTV++YrGNDCdUkpcVcBRPUGMQQa86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683739; c=relaxed/simple;
	bh=C2VC+mcxLt3k151YIxSGa29SyEBfNIFoQ0SHTaA26cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKF14sS2EPayko0YBoD0yBCkKNkndp9kEB4sEx37L4g52QRctHZELVdSzkIz6nS7qrZO0kDmWF/9FYEB5YNyQP1m4xw6Qz3ch/1EXFojyxfHYCDdClZx+ZRcXmwgOmiXUCuXAHSyWBDGZI3UGvXpq9i2AErebxZOA5LCRzb//L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuYD94om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuYD94om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DAAC2BD10;
	Tue, 14 May 2024 10:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683739;
	bh=C2VC+mcxLt3k151YIxSGa29SyEBfNIFoQ0SHTaA26cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuYD94om0Fe7kj5KoWERlSSbfkMtefneB+v//Awdscpkxyw61wbhZsYeUepdtXURS
	 nwi01AH8OqBSu1tjbXsmRyCSZQpI7tHDix7piXeYd9GOuacDCzRUXLRDl8YznGlVBb
	 fmrPT9XjlbEMTpNurOKHqNvLNtKupOCZC1bDaE4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 265/336] btrfs: qgroup: do not check qgroup inherit if qgroup is disabled
Date: Tue, 14 May 2024 12:17:49 +0200
Message-ID: <20240514101048.620087195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit b5357cb268c41b4e2b7383d2759fc562f5b58c33 upstream.

[BUG]
After kernel commit 86211eea8ae1 ("btrfs: qgroup: validate
btrfs_qgroup_inherit parameter"), user space tool snapper will fail to
create snapshot using its timeline feature.

[CAUSE]
It turns out that, if using timeline snapper would unconditionally pass
btrfs_qgroup_inherit parameter (assigning the new snapshot to qgroup 1/0)
for snapshot creation.

In that case, since qgroup is disabled there would be no qgroup 1/0, and
btrfs_qgroup_check_inherit() would return -ENOENT and fail the whole
snapshot creation.

[FIX]
Just skip the check if qgroup is not enabled.
This is to keep the older behavior for user space tools, as if the
kernel behavior changed for user space, it is a regression of kernel.

Thankfully snapper is also fixing the behavior by detecting if qgroup is
running in the first place, so the effect should not be that huge.

Link: https://github.com/openSUSE/snapper/issues/894
Fixes: 86211eea8ae1 ("btrfs: qgroup: validate btrfs_qgroup_inherit parameter")
CC: stable@vger.kernel.org # 6.8+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3052,6 +3052,8 @@ int btrfs_qgroup_check_inherit(struct bt
 			       struct btrfs_qgroup_inherit *inherit,
 			       size_t size)
 {
+	if (!btrfs_qgroup_enabled(fs_info))
+		return 0;
 	if (inherit->flags & ~BTRFS_QGROUP_INHERIT_FLAGS_SUPP)
 		return -EOPNOTSUPP;
 	if (size < sizeof(*inherit) || size > PAGE_SIZE)


