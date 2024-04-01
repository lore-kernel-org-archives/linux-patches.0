Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745BB1CA8F;
	Mon,  1 Apr 2024 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987559; cv=none; b=q0MLK+E4a1Fuwfkl2SFo7o8uXLm/RDyWjo2aJCiOO23cXq+pMuEO4GzCpafjveAQYavRBrLlx5LY3IkVJBIAaNd0g0MzdsIBKIvlzT3mD9RLj6x9EsF9Ms2vWnMztLurBnvd1b7my2c20gcum7hA2sq60hnhwIP7HWeRSzsnFlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987559; c=relaxed/simple;
	bh=/gOt41U+14Rf6ZT3R/JPtviCLQ2fHoxzHYEyDgQRZI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER6HYVtJEbJaD7PTGvRv4zC0E/xqBdlueN08xAidnfdEpjFRvIbjnwok8tXxmnSJ/70FsWDRrGJAkkDzOMEXlAWyiCDSPM6/VXrmDAmaWKD9jR75X07EasysoaKBjFpNG8BbnT/Ztk0Qtxz2VlXjBQnh0DAV0ygFYkE2INxr5DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0e/MEls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0e/MEls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42B5C433F1;
	Mon,  1 Apr 2024 16:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987559;
	bh=/gOt41U+14Rf6ZT3R/JPtviCLQ2fHoxzHYEyDgQRZI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0e/MElsX8K4nXheK0Ko/17NA16zBD2YGeN8kPcjPv59b2goLZPPDdTNCuL7lLKeN
	 oYDlCEz5zxI5pQJlkNinD2QF99ek3JVUB1iP3DuV+zwCvZ4QS1bbzmlKotiirW5AQk
	 dc/ZOONfq6Z5SpUshV6GNV8dzytgTwbqVAvrYhKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 294/399] btrfs: validate device maj:min during open
Date: Mon,  1 Apr 2024 17:44:20 +0200
Message-ID: <20240401152557.963456801@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

commit 9f7eb8405dcbc79c5434821e9e3e92abe187ee8e upstream.

Boris managed to create a device capable of changing its maj:min without
altering its device path.

Only multi-devices can be scanned. A device that gets scanned and remains
in the btrfs kernel cache might end up with an incorrect maj:min.

Despite the temp-fsid feature patch did not introduce this bug, it could
lead to issues if the above multi-device is converted to a single device
with a stale maj:min. Subsequently, attempting to mount the same device
with the correct maj:min might mistake it for another device with the same
fsid, potentially resulting in wrongly auto-enabling the temp-fsid feature.

To address this, this patch validates the device's maj:min at the time of
device open and updates it if it has changed since the last scan.

CC: stable@vger.kernel.org # 6.7+
Fixes: a5b8a5f9f835 ("btrfs: support cloned-device mount capability")
Reported-by: Boris Burkov <boris@bur.io>
Co-developed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Boris Burkov <boris@bur.io>#
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -694,6 +694,16 @@ static int btrfs_open_one_device(struct
 	device->bdev = bdev_handle->bdev;
 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 
+	if (device->devt != device->bdev->bd_dev) {
+		btrfs_warn(NULL,
+			   "device %s maj:min changed from %d:%d to %d:%d",
+			   device->name->str, MAJOR(device->devt),
+			   MINOR(device->devt), MAJOR(device->bdev->bd_dev),
+			   MINOR(device->bdev->bd_dev));
+
+		device->devt = device->bdev->bd_dev;
+	}
+
 	fs_devices->open_devices++;
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	    device->devid != BTRFS_DEV_REPLACE_DEVID) {


