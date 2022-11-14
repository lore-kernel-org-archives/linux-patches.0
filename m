Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90B54C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319A1C433C1;
	Mon, 14 Nov 2022 12:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430696;
	bh=+k7f3ERpIhzgGvt/56nHrrXcZijM1pibjzFdkSmyqm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzbwWl7oYetvPEKXpdYkvCfqWzlhBQ/mtFp7LNHF6NLSMTJwQoOlJEZhh3r4e/br4
	 ssPvNPj6gXpX6szCLIXVBJNp15VWFMzgIBLXMhh+ftNgwa3E555diHJ20rN3QAEBhv
	 QFRCpRN3cQjX7O1i3L5A2B9gsU54P2o2xYYN5YDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+031687116258450f9853@syzkaller.appspotmail.com,
	Nikolay Borisov <nborisov@suse.com>,
	Liu Shixin <liushixin2@huawei.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 104/131] btrfs: fix match incorrectly in dev_args_match_device
Date: Mon, 14 Nov 2022 13:46:13 +0100
Message-Id: <20221114124453.107792189@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin <liushixin2@huawei.com>

commit 0fca385d6ebc3cabb20f67bcf8a71f1448bdc001 upstream.

syzkaller found a failed assertion:

  assertion failed: (args->devid != (u64)-1) || args->missing, in fs/btrfs/volumes.c:6921

This can be triggered when we set devid to (u64)-1 by ioctl. In this
case, the match of devid will be skipped and the match of device may
succeed incorrectly.

Patch 562d7b1512f7 introduced this function which is used to match device.
This function contains two matching scenarios, we can distinguish them by
checking the value of args->missing rather than check whether args->devid
and args->uuid is default value.

Reported-by: syzbot+031687116258450f9853@syzkaller.appspotmail.com
Fixes: 562d7b1512f7 ("btrfs: handle device lookup with btrfs_dev_lookup_args")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6841,18 +6841,18 @@ static bool dev_args_match_fs_devices(co
 static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
 				  const struct btrfs_device *device)
 {
-	ASSERT((args->devid != (u64)-1) || args->missing);
+	if (args->missing) {
+		if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) &&
+		    !device->bdev)
+			return true;
+		return false;
+	}
 
-	if ((args->devid != (u64)-1) && device->devid != args->devid)
+	if (device->devid != args->devid)
 		return false;
 	if (args->uuid && memcmp(device->uuid, args->uuid, BTRFS_UUID_SIZE) != 0)
 		return false;
-	if (!args->missing)
-		return true;
-	if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) &&
-	    !device->bdev)
-		return true;
-	return false;
+	return true;
 }
 
 /*


