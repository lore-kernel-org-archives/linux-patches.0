Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBC6320CD9;
	Tue, 17 Feb 2026 20:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360844; cv=none; b=MpZVRcjp+7HqKKDo9tbqdxOFvqeA81pnqJJ9WiZUvuSx0Yn1oIMxqvKjKPVaNhDwqAVh5lsylkdxEnzBbo6VSGwCyr0FHYrTSPJkoMtrTzDnFDop2iSidyuTvIfqG9h3BsxuuU3sAOPO1Es7kBmU1+lY1xQk8gT6s06I6uYt2Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360844; c=relaxed/simple;
	bh=pHzlN07lAONPSintpWTjBDkQo1F5b5ibyAIiAkFxkjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjMMJbavIVdoJCAonxJBCFps+FxE+97CmRMIqP8yHDkHfyVWxHRSYDNf/vW006gG2nBuqgjaKqbBvb7rhEIFmoyxch/aLdABinO9UYZdGiu0dB5+4da6e4JfJ/aoef+GV88rdKn8lYHrEkHvkKxNGpQr8GUmyMYrE89ill9XlVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvBeDFEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvBeDFEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9B1C4CEF7;
	Tue, 17 Feb 2026 20:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360844;
	bh=pHzlN07lAONPSintpWTjBDkQo1F5b5ibyAIiAkFxkjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvBeDFEjewYDda4ZOJ2AmqcigHCMunjZVx3YGeg947nua/gGTZzFFRXMr7oh5Pzaf
	 hQbfDHmnFaS6jOJzpySeepOxzF5LibPFVYxjwNLQmhqqIGT6BMxpGGUN/iS5FbZ03f
	 jEQBSzoMrYzg68beSh8B0NDw0L+s3p8BJ9aBl5vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	stable <stable@kernel.org>,
	Steve Glendinning <steve.glendinning@shawell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 31/39] fbdev: smscufx: properly copy ioctl memory to kernelspace
Date: Tue, 17 Feb 2026 21:30:53 +0100
Message-ID: <20260217200005.406488385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -988,7 +988,6 @@ static int ufx_ops_ioctl(struct fb_info
 			 unsigned long arg)
 {
 	struct ufx_data *dev = info->par;
-	struct dloarea *area = NULL;
 
 	if (!atomic_read(&dev->usb_active))
 		return 0;
@@ -1003,6 +1002,10 @@ static int ufx_ops_ioctl(struct fb_info
 
 	/* TODO: Help propose a standard fb.h ioctl to report mmap damage */
 	if (cmd == UFX_IOCTL_REPORT_DAMAGE) {
+		struct dloarea *area __free(kfree) = kmalloc(sizeof(*area), GFP_KERNEL);
+		if (!area)
+			return -ENOMEM;
+
 		/* If we have a damage-aware client, turn fb_defio "off"
 		 * To avoid perf imact of unnecessary page fault handling.
 		 * Done by resetting the delay for this fb_info to a very
@@ -1012,7 +1015,8 @@ static int ufx_ops_ioctl(struct fb_info
 		if (info->fbdefio)
 			info->fbdefio->delay = UFX_DEFIO_WRITE_DISABLE;
 
-		area = (struct dloarea *)arg;
+		if (copy_from_user(area, (u8 __user *)arg, sizeof(*area)))
+			return -EFAULT;
 
 		if (area->x < 0)
 			area->x = 0;


