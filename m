Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2C72BCF7F;
	Wed, 23 Apr 2025 15:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421500; cv=none; b=cpdybnOp4PMAZT/7JVXSjVUiyCvdrNO7WO32vMn/NRZZsUTuvdKINvyN56x43e8nhKRDOGxnQSnawAqiU8JkRs2ULFaBZj7H3KQTPQDhIOVrPT9QPOMJOk87yATXc7IdLfQVJQfGvmh0EQa9GbMv10p8kWyZ5B19OTSCk2P3yF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421500; c=relaxed/simple;
	bh=Y2OeIHOClCJsou7Cq8lcAddAUk2qAkJ7jIpDs9hwdPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8mhoeTLGzgHLfLGr7VWsibZ1e9OtHwxlJx0nIo/br98lg1tJ19ANLpYGCfmoa4I8HhoQr+6XGr7kmowEcV8zdBiG6igbcfalhZpjBjyzs62hGrTcry3X3Y31MpqnCxKX/FS+5wV+I/HXQdpT5crqyVbS4mG+024IjMlWiB+x2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2X2z/jAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2X2z/jAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2848C4CEE3;
	Wed, 23 Apr 2025 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421500;
	bh=Y2OeIHOClCJsou7Cq8lcAddAUk2qAkJ7jIpDs9hwdPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2X2z/jAnkqBrNmzhRquDE4Yly1X2LOG6iCI+rQUBTk3SIo8ttHW6rb3xtYei2PWBF
	 gebpnPmHnasr82zAhpRGIcYpoDHkh5XvOq74lNR8gFWQnOsU/dkBSiMneoSXUOfDD7
	 OGIJSBpaGwistyHZrndgm6zTr+ocNVucRQvr8HUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 185/393] btrfs: zoned: fix zone finishing with missing devices
Date: Wed, 23 Apr 2025 16:41:21 +0200
Message-ID: <20250423142651.022134777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2168,6 +2168,9 @@ static int do_zone_finish(struct btrfs_b
 		const u64 physical = map->stripes[i].physical;
 		struct btrfs_zoned_device_info *zinfo = device->zone_info;
 
+		if (!device->bdev)
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 


