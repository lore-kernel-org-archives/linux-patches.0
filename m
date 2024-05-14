Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C041774E10;
	Tue, 14 May 2024 11:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687690; cv=none; b=DSJbJ/t25KXR9uwmvKyRK8RbKEQkb3ONhGJLKTKNTPJXS9rv/VmtbBqi8aKyZHqQQOhWdb6i26ItiNxR9dwrsUWUgfOHDaw22tVZLVDn+gwpcqanJipANXB9PhNS3xO9rBW5tH3LwAH7YsIAPlAavSj0EKQI8wsrTjmzHmhZS/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687690; c=relaxed/simple;
	bh=CfhfR7owzufQCcN4TDKfgIpAt+O4lePXXvuLE4TDxpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roUigH+sVgzFitJUeRwpd0A6W59s63Lq8KQuId5IfbUfiKO7GCw+tEd0r5ufI0sCEDfIipdhRReOsEfNLWmnKm4RuSw4JBWcQPiaOVzvvNjKPwFl1fL+7/dEMKhhMDBqYsS+ip7601JQycpqISNrR3ttynzyAwWPHkJ571MMGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xpr29AZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xpr29AZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA41C2BD10;
	Tue, 14 May 2024 11:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687690;
	bh=CfhfR7owzufQCcN4TDKfgIpAt+O4lePXXvuLE4TDxpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xpr29AZwhtFvITRhitB8IeJy5T5kVdiEr59MlfaWEfwn6UW+OMTqJEJM2verYtDfZ
	 rEh/cVg7oe1yhRiggC5E5Ee1F6w4kLeoeEMqjUu2xZ8x59ZrCiSMUzA3fDwNcu3RTu
	 BiCeAu+Q5ALsE/bzxcz811yY95XBO42FJvLv5CGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/168] btrfs: return accurate error code on open failure in open_fs_devices()
Date: Tue, 14 May 2024 12:19:28 +0200
Message-ID: <20240514101009.337372465@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit 2f1aeab9fca1a5f583be1add175d1ee95c213cfa ]

When attempting to exclusive open a device which has no exclusive open
permission, such as a physical device associated with the flakey dm
device, the open operation will fail, resulting in a mount failure.

In this particular scenario, we erroneously return -EINVAL instead of the
correct error code provided by the bdev_open_by_path() function, which is
-EBUSY.

Fix this, by returning error code from the bdev_open_by_path() function.
With this correction, the mount error message will align with that of
ext4 and xfs.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 36e77956c63fa..2a0d44fd2dd98 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1260,25 +1260,32 @@ static int open_fs_devices(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_device *device;
 	struct btrfs_device *latest_dev = NULL;
 	struct btrfs_device *tmp_device;
+	int ret = 0;
 
 	flags |= FMODE_EXCL;
 
 	list_for_each_entry_safe(device, tmp_device, &fs_devices->devices,
 				 dev_list) {
-		int ret;
+		int ret2;
 
-		ret = btrfs_open_one_device(fs_devices, device, flags, holder);
-		if (ret == 0 &&
+		ret2 = btrfs_open_one_device(fs_devices, device, flags, holder);
+		if (ret2 == 0 &&
 		    (!latest_dev || device->generation > latest_dev->generation)) {
 			latest_dev = device;
-		} else if (ret == -ENODATA) {
+		} else if (ret2 == -ENODATA) {
 			fs_devices->num_devices--;
 			list_del(&device->dev_list);
 			btrfs_free_device(device);
 		}
+		if (ret == 0 && ret2 != 0)
+			ret = ret2;
 	}
-	if (fs_devices->open_devices == 0)
+
+	if (fs_devices->open_devices == 0) {
+		if (ret)
+			return ret;
 		return -EINVAL;
+	}
 
 	fs_devices->opened = 1;
 	fs_devices->latest_dev = latest_dev;
-- 
2.43.0



