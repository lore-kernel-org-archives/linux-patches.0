Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0E13594D;
	Thu, 17 Apr 2025 18:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915946; cv=none; b=NNBZ7ay+9CSFMbrWOpKxBU5R8H9v/8IKGp0mLQcXzj/XnuPCqCVmVKdXObUvMqJFU25kKFQXxImH9/tfzDF1/Ga0MOc7nhZWl8kWpysg0O+uwgEyqdvk5sO8mNlequ9m1hdoZqDxpXdMu+uRnA6ziLB9oOIkIUVW9BhBSpiLa9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915946; c=relaxed/simple;
	bh=e5R4Q9EG7HOHhJjwmzAv3fMy4OtAjN5djD0AsHoyI5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shJ0SLD142Z06erKotQAwXtjwiC711xBGU/EjzbpzNwchtQ8fNOtZ5x5oK9gVKOuob4LmiaRucHwIirNHkMaHNTkZ1R9io/0VwMYIpypSSgKA6Id6s8OdHiv2XCkl4OS69KP7Hn3OrR97pAjIEQWvOPCseXxeH9hq5bWPnF+2mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBGvVf9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBGvVf9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87314C4CEE4;
	Thu, 17 Apr 2025 18:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915946;
	bh=e5R4Q9EG7HOHhJjwmzAv3fMy4OtAjN5djD0AsHoyI5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBGvVf9b7/Vf0Y+/U8l+gJTnKAkmEAhXRNNzBYNb1NdfRj+IWoQQb3pGoyDqNoKzs
	 NrpkBRkz0ORoFrPEjWFwjNITefurw7Ce3tf2WlatJGSbqJDUxZO46pkEjZ0TxsUrOe
	 m5V4dGlE+eRITmttilvZGU+sZOVCU30b6uxAj98U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 293/393] btrfs: zoned: fix zone finishing with missing devices
Date: Thu, 17 Apr 2025 19:51:42 +0200
Message-ID: <20250417175119.400084856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 35fec1089ebb5617f85884d3fa6a699ce6337a75 upstream.

If do_zone_finish() is called with a filesystem that has missing devices
(e.g. a RAID file system mounted in degraded mode) it is accessing the
btrfs_device::zone_info pointer, which will not be set if the device
in question is missing.

Check if the device is present (by checking if it has a valid block device
pointer associated) and if not, skip zone finishing for it.

Fixes: 4dcbb8ab31c1 ("btrfs: zoned: make zone finishing multi stripe capable")
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
@@ -2271,6 +2271,9 @@ static int do_zone_finish(struct btrfs_b
 		struct btrfs_zoned_device_info *zinfo = device->zone_info;
 		unsigned int nofs_flags;
 
+		if (!device->bdev)
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 


