Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF846254B18;
	Thu, 17 Apr 2025 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914824; cv=none; b=M9vITN4jGKvxrmRt9UnoZgaL5kevhsssbCziqQqEucfUT1twO+ixB6SffKlKuMPeavs+IWGcb6maOM0MpL+xa7peoIku9GaOy0KhAUH8krbGBTJIQxbOkVBY0HMhscWAbAYTyW77OA7i6g2z/7EGhrV84gMZcrlApXzDGwQF+yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914824; c=relaxed/simple;
	bh=NuyAaFu5/1XdbCjDlmyjweW3C+nR0vejL8e/yy4d1nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STSfNJFEaR5sZFCKV8XYaoc7EEG5mkBrggXNBv23tlsqtYSwCOzFqdTmYtYhkiXiDqvMx7aMRgKRLBYo2GlXaoy6rQzZvCoMCZ2PPNTxuAlhkN8qNImt6YTrnHVngHkOuEV5G6z1kPbierAudcwQQ+F0OoCu0CStOfaNJfV+3Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G60B3Q9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G60B3Q9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5DDC4CEE4;
	Thu, 17 Apr 2025 18:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914824;
	bh=NuyAaFu5/1XdbCjDlmyjweW3C+nR0vejL8e/yy4d1nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G60B3Q9hjI2R4yq/2SBhaKUJNqaUZzemVQvyGHEFgMYHtsKZqEpPSQ+YU93PmkQCn
	 ekO9rWB74e+hUQuCpq3RJemmyrqlTJ11+vteaymiRHJG3gMRoOjqcWrinWCny+G9d6
	 9SREsO58TUGJ5pvqiXb/DOIJeq3hj5rxVNUV8Mpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 314/414] btrfs: zoned: fix zone activation with missing devices
Date: Thu, 17 Apr 2025 19:51:12 +0200
Message-ID: <20250417175124.061870123@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 2bbc4a45e5eb6b868357c1045bf6f38f6ba576e0 upstream.

If btrfs_zone_activate() is called with a filesystem that has missing
devices (e.g. a RAID file system mounted in degraded mode) it is accessing
the btrfs_device::zone_info pointer, which will not be set if the device in
question is missing.

Check if the device is present (by checking if it has a valid block
device pointer associated) and if not, skip zone activation for it.

Fixes: f9a912a3c45f ("btrfs: zoned: make zone activation multi stripe capable")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2111,6 +2111,9 @@ bool btrfs_zone_activate(struct btrfs_bl
 		physical = map->stripes[i].physical;
 		zinfo = device->zone_info;
 
+		if (!device->bdev)
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 


