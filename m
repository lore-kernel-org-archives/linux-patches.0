Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2923D961;
	Mon,  1 Apr 2024 16:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988964; cv=none; b=e4IyVrHvNWqdznfHKPpiYxFrD7UPFXBfCqT/o3goRSUruxJz3PpJkKayys33boRc4YLyzO8i/7LwabKjkOtixZNd0ocNgRV1w2zb0VnfqBt2myZbt3TKAbMHHhjTDKhprgN4Z5rsL+cR5fQdVdw6hzRZh1OQK6CPWS0BE4XGRBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988964; c=relaxed/simple;
	bh=oLbsF4RjFm46muyAGMrln3GUjiT2eik7aiIqbLiT3vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY9GVMYfFWgEyFwgOlseXxHuGKv54k87iItjfKnmQzp1yhM6qICVGhj3i3VVMrvPR3v5vzQhjvgcYgXt4Hd9ELG8O0ouhigxCKllOzXiREyqyryBjpn3vEAGwNpl0rdZu9DOXfrIHN20KVXyUHt/f/onpleDtDIGBMp4REl3OLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fuav2PAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fuav2PAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368A2C433C7;
	Mon,  1 Apr 2024 16:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988964;
	bh=oLbsF4RjFm46muyAGMrln3GUjiT2eik7aiIqbLiT3vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fuav2PAz6cbVz6JNXWGhAkTqZER8pxuLZfGF9aTGGnGOA4nT7wg4a4KlGhGe/SzDA
	 csO6TS6RxCsCyPreNVBWWBprlvkp8EdIIZsTYTg5hW/Lx5HWrDF6BQTHkSoL6wdZqW
	 8V0FJ72IPipE/+e2USAGSqqgigATrI6buOcdKv6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 341/432] btrfs: validate device maj:min during open
Date: Mon,  1 Apr 2024 17:45:28 +0200
Message-ID: <20240401152603.407774255@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -683,6 +683,16 @@ static int btrfs_open_one_device(struct
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


