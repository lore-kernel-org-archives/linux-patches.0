Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1391B36F431;
	Tue, 17 Feb 2026 20:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360946; cv=none; b=NMOj6F73nCTnIitjTu0U4yzLB2ipDtp57Eu4YOnDiVLvS9t/kkM9nQjmCylaYAYyZm77r0Vk5juVgOd7QDkccxAVTDBgXCU7bOGxf6I6LUv5z60wGlNyHp1qOIWwIyMUPx8HGBZHCmxs6ia+wPXdk9oayuM7vN33hm4QOHy2LkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360946; c=relaxed/simple;
	bh=2DqAIjAlF75z7cnwy01LwAGCm8XOX19PHcCwBFAbOoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhMvSwrUz4k+F9EYb1/y+Q/V7Edk7Mq03AJi+yVdzUnr2a+B4us2dgB7H2s49/1jBPmS/d2h4SvkyejsqxgRLsImXN5TY9QpMvDRQbzFYaliyFjjyEdUvPvPFnyC21DwBnoQ0BiOW2hMsShZkx/kTuoHr9iWwLP5GUVYNcMUYZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcRNqr/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcRNqr/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73562C4CEF7;
	Tue, 17 Feb 2026 20:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360945;
	bh=2DqAIjAlF75z7cnwy01LwAGCm8XOX19PHcCwBFAbOoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcRNqr/f5y9XAh0dm4trM531rBkYCx4EY3Q88UT1C2E/cLegKtCEh0ykJtO4EIW7a
	 CbLzB7qsu8JRDEIDZL6lS1eArmfTXrtipxxay4ML0VAmCaurxkXABU2nQ6lWw9mnBF
	 sABs8O9iwE+Exae23vEFDvsLhehJh/mIotnwTkcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	stable <stable@kernel.org>,
	Steve Glendinning <steve.glendinning@shawell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 21/24] fbdev: smscufx: properly copy ioctl memory to kernelspace
Date: Tue, 17 Feb 2026 21:31:34 +0100
Message-ID: <20260217200001.533191163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 120adae7b42faa641179270c067864544a50ab69 upstream.

The UFX_IOCTL_REPORT_DAMAGE ioctl does not properly copy data from
userspace to kernelspace, and instead directly references the memory,
which can cause problems if invalid data is passed from userspace.  Fix
this all up by correctly copying the memory before accessing it within
the kernel.

Reported-by: Tianchu Chen <flynnnchen@tencent.com>
Cc: stable <stable@kernel.org>
Cc: Steve Glendinning <steve.glendinning@shawell.net>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/smscufx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -987,7 +987,6 @@ static int ufx_ops_ioctl(struct fb_info
 			 unsigned long arg)
 {
 	struct ufx_data *dev = info->par;
-	struct dloarea *area = NULL;
 
 	if (!atomic_read(&dev->usb_active))
 		return 0;
@@ -1002,6 +1001,10 @@ static int ufx_ops_ioctl(struct fb_info
 
 	/* TODO: Help propose a standard fb.h ioctl to report mmap damage */
 	if (cmd == UFX_IOCTL_REPORT_DAMAGE) {
+		struct dloarea *area __free(kfree) = kmalloc(sizeof(*area), GFP_KERNEL);
+		if (!area)
+			return -ENOMEM;
+
 		/* If we have a damage-aware client, turn fb_defio "off"
 		 * To avoid perf imact of unnecessary page fault handling.
 		 * Done by resetting the delay for this fb_info to a very
@@ -1011,7 +1014,8 @@ static int ufx_ops_ioctl(struct fb_info
 		if (info->fbdefio)
 			info->fbdefio->delay = UFX_DEFIO_WRITE_DISABLE;
 
-		area = (struct dloarea *)arg;
+		if (copy_from_user(area, (u8 __user *)arg, sizeof(*area)))
+			return -EFAULT;
 
 		if (area->x < 0)
 			area->x = 0;


