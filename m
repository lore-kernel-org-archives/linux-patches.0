Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E20E2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8919C433EF;
	Sun, 22 Jan 2023 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401023;
	bh=CFvgNyULNgMdeeWyAlzJYbWcoamXUydYUC5K9i10rMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqoXsicBqpDmNaGyMvP2SjMlDpIkYuxL4K6lL6JrcJ34yIPCyE6LhIouiGLkb0qty
	 kGUuz+3B5/On9dPFyrjsjUqKLcGVZDrtTznFWsty077XvtsDizZ00FGph034zZe72p
	 gwMI5HwpTzjw2GZcYWqH2RQVtZF/ctFXgndYgNdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 081/193] btrfs: add extra error messages to cover non-ENOMEM errors from device_add_list()
Date: Sun, 22 Jan 2023 16:03:30 +0100
Message-Id: <20230122150250.074877448@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

commit ed02363fbbed52a3f5ea0d188edd09045a806eb5 upstream.

[BUG]
When test case btrfs/219 (aka, mount a registered device but with a lower
generation) failed, there is not any useful information for the end user
to find out what's going wrong.

The mount failure just looks like this:

  #  mount -o loop /tmp/219.img2 /mnt/btrfs/
  mount: /mnt/btrfs: mount(2) system call failed: File exists.
         dmesg(1) may have more information after failed mount system call.

While the dmesg contains nothing but the loop device change:

  loop1: detected capacity change from 0 to 524288

[CAUSE]
In device_list_add() we have a lot of extra checks to reject invalid
cases.

That function also contains the regular device scan result like the
following prompt:

  BTRFS: device fsid 6222333e-f9f1-47e6-b306-55ddd4dcaef4 devid 1 transid 8 /dev/loop0 scanned by systemd-udevd (3027)

But unfortunately not all errors have their own error messages, thus if
we hit something wrong in device_add_list(), there may be no error
messages at all.

[FIX]
Add errors message for all non-ENOMEM errors.

For ENOMEM, I'd say we're in a much worse situation, and there should be
some OOM messages way before our call sites.

CC: stable@vger.kernel.org # 6.0+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -770,8 +770,11 @@ static noinline struct btrfs_device *dev
 					BTRFS_SUPER_FLAG_CHANGING_FSID_V2);
 
 	error = lookup_bdev(path, &path_devt);
-	if (error)
+	if (error) {
+		btrfs_err(NULL, "failed to lookup block device for path %s: %d",
+			  path, error);
 		return ERR_PTR(error);
+	}
 
 	if (fsid_change_in_progress) {
 		if (!has_metadata_uuid)
@@ -836,6 +839,9 @@ static noinline struct btrfs_device *dev
 
 	if (!device) {
 		if (fs_devices->opened) {
+			btrfs_err(NULL,
+		"device %s belongs to fsid %pU, and the fs is already mounted",
+				  path, fs_devices->fsid);
 			mutex_unlock(&fs_devices->device_list_mutex);
 			return ERR_PTR(-EBUSY);
 		}
@@ -910,6 +916,9 @@ static noinline struct btrfs_device *dev
 			 * generation are equal.
 			 */
 			mutex_unlock(&fs_devices->device_list_mutex);
+			btrfs_err(NULL,
+"device %s already registered with a higher generation, found %llu expect %llu",
+				  path, found_transid, device->generation);
 			return ERR_PTR(-EEXIST);
 		}
 


