Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44D63D563;
	Mon, 18 Dec 2023 14:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiRmRmhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E6DC433C7;
	Mon, 18 Dec 2023 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908297;
	bh=uU/kijjPGuTjnrQhraDjskZt0UpFX2xAVWpQ3TOCwIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiRmRmhL355gOiMQZNimcTWvYfYZOwkXcfH2jErsmKFEuglMZ9TlpUXB4Fh7wBkiY
	 qgY4lodAGU51JdEDLUvjC6V0KhTZLY3MY7X8ipy/UiXDDDH3Ar61XzwON69UvpKdKm
	 Q2No4BXeAtL6TaqvMbwAWp8qciQgNI3GSp8uH9jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Neal Gompa <neal@gompa.dev>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 126/166] btrfs: do not allow non subvolume root targets for snapshot
Date: Mon, 18 Dec 2023 14:51:32 +0100
Message-ID: <20231218135110.708146453@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit a8892fd71933126ebae3d60aec5918d4dceaae76 upstream.

Our btrfs subvolume snapshot <source> <destination> utility enforces
that <source> is the root of the subvolume, however this isn't enforced
in the kernel.  Update the kernel to also enforce this limitation to
avoid problems with other users of this ioctl that don't have the
appropriate checks in place.

Reported-by: Martin Michaelis <code@mgjm.de>
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1290,6 +1290,15 @@ static noinline int __btrfs_ioctl_snap_c
 			 * are limited to own subvolumes only
 			 */
 			ret = -EPERM;
+		} else if (btrfs_ino(BTRFS_I(src_inode)) != BTRFS_FIRST_FREE_OBJECTID) {
+			/*
+			 * Snapshots must be made with the src_inode referring
+			 * to the subvolume inode, otherwise the permission
+			 * checking above is useless because we may have
+			 * permission on a lower directory but not the subvol
+			 * itself.
+			 */
+			ret = -EINVAL;
 		} else {
 			ret = btrfs_mksnapshot(&file->f_path, idmap,
 					       name, namelen,


