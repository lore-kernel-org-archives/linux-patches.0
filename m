Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621006;
	b=JNukfCBpyq06qkRLncW/AxGvXgOzYpX8JtQFilrWfwT8KrvrN9MiSIBGAPQTbSdrzAR1
	 VB2SrohS7CE+lwGXbLdYsaxevvA6zly26coF232n4BPoNWU47tnFfnxPDtWtyDpaLE6K8
	 0xbvaYwQda33PVJ/rkssuyr1dJlONtcelYwrBVf6v/ECqsUCuz1X7ZqW1dbn45mBNkgUf
	 WGPN9d1lnLNuDGy/UL+FTf3eZUM5Thyn3+DleLBjkBHFFhP+icfCCnBvYq/7nL86fd/LX
	 kYe+6wSV4l+Y2N7S58lKsRNXvq3ux1EkQs589jD3ru0VgHqjVfCkuDNhQX8LNqJDwtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R/XTlnTEEaA6w25B4uUTIbfhzmrM5KTyD3/M3g4PKEE=;
	b=0BRHIAgoAUSBJ35EDXcNlr7X3JeoFkOmdWBAETwXae+YaBKmej6m37ijx1U6THIjOd1G
	 Z8gt40B78CFUjUm/zTN4asOKBIjIg609l/6HCcZHGvDtse9UqkUqwsroTjO2bn4erP9PN
	 BRe2ES8mLiQ29X05f38aXFGfS+xTi8EbcVnDTIVmbrMyLYgpez59H4L4JUFlqTC8/5sg/
	 HcLiJL+5ekjwmzTHkEdqBM8+SGBw6cU1NZjDHX3g+RkuD8DNmIVEUQn9pI4+vA0tSeVhr
	 QQ6swcfjT3GVwUckIUesR1KgmVBXp2FXVNZl+HR6q04AXeo5GvFqomz0LhP7ry4SgPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JIoFT731;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAEB60A261B;
	Wed, 25 Nov 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JIoFT731
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B181F000C4;
	Wed, 25 Nov 2026 15:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621006;
	bh=R/XTlnTEEaA6w25B4uUTIbfhzmrM5KTyD3/M3g4PKEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIoFT731CO7MeGdtbsHdeJ5yrZEwiS9YR2Jb/55MfG1OmXWluKH+tmIeeKtIM2YPM
	 mzyFpA1RtnV5tNM2iKBFGi19/+H7q0jIRUWIULfb2DBiDPNjD0ofmFH4CXigPXUAje
	 cSLbBZ79bUlFzc6bjvDO8u6RYRyhO/9OYWNxmX1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/990] btrfs: zoned: fix double free of bitmaps on clone failure
Date: Wed, 25 Nov 2026 15:24:18 +0100
Message-ID: <20261125143824.222591130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 8c66a6aa59a5df1d672d72b7cd379d897ff73200 ]

btrfs_clone_dev_zone_info() duplicates the original orig_dev->zone_info
with kmemdup(), which also copies the seq_zones, empty_zones and
active_zones pointers. The clone then replaces them one by one with
fresh bitmaps. If one of the allocations fails, the error path frees all
three pointers, including those not yet replaced, which still point to
the bitmaps owned by the original device.

Clear the three pointers right after kmemdup() so the error path only frees
what this function allocated.

Fixes: 21e61ec6d0bb ("btrfs: zoned: clone zoned device info when cloning a device")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 88559307bac7d..69ede4e4d0c20 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -642,6 +642,11 @@ struct btrfs_zoned_device_info *btrfs_clone_dev_zone_info(struct btrfs_device *o
 	if (!zone_info)
 		return NULL;
 
+	/* Don't let the error path free the bitmaps still owned by @orig_dev. */
+	zone_info->seq_zones = NULL;
+	zone_info->empty_zones = NULL;
+	zone_info->active_zones = NULL;
+
 	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
 	if (!zone_info->seq_zones)
 		goto out;
-- 
2.53.0



