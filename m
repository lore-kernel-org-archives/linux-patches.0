Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7FA261B70;
	Tue, 17 Feb 2026 20:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361559; cv=none; b=LFEAyaiJvT1bhaTX8F7krqK8sxWnSCsvX4aXfx8tX/51B1TKdscfkTOV4rMsi/eOZFxUjLXvoJE8AwTEdR9ViwzWaCrEhj33C8ighre1DbKywgzyisTJsDZ8y3DME1vA+odExpnQwvc94d3DtJQzCj/Ll/Qc902jlNhoCRlgY7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361559; c=relaxed/simple;
	bh=OV5jF8nap+oTo2mWVEmhrQhz0rvikFcY/0SWWpksj2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZsP7tVbc6m14qIjTF/MAEWsi+x8ys2zpOYT5TUrnULriaks66YDVQIMe4aHXCC3/bYITy3IETg1Iw6GkJNekKuWQtYMx45vBcFyaDUNLqCi86Cl0uBcP+9b6dBo8Ukos6//aDa+/E/To2rTUIF+swecBoL87owybZ0noVW0C1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCjEhabl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCjEhabl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9D3C4CEF7;
	Tue, 17 Feb 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361559;
	bh=OV5jF8nap+oTo2mWVEmhrQhz0rvikFcY/0SWWpksj2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCjEhablq+v31WzPNXqPxMGqHf6UfcxAWxLyo8gmSlniM8CHgyvhm9t6y8EdSPWp6
	 HfdQiJ32/wsFHtsjwLAPYYtU94s/PhlRFuhzX2ynv6r5z1xM3RiJ5Svz8mHclwNFu/
	 4NPUKnR5P8GoGc8oWo+KkbneNxx6sXl2nAsIhR44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	stable <stable@kernel.org>,
	Steve Glendinning <steve.glendinning@shawell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 31/43] fbdev: smscufx: properly copy ioctl memory to kernelspace
Date: Tue, 17 Feb 2026 21:32:11 +0100
Message-ID: <20260217200007.663186155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -932,7 +932,6 @@ static int ufx_ops_ioctl(struct fb_info
 			 unsigned long arg)
 {
 	struct ufx_data *dev = info->par;
-	struct dloarea *area = NULL;
 
 	if (!atomic_read(&dev->usb_active))
 		return 0;
@@ -947,6 +946,10 @@ static int ufx_ops_ioctl(struct fb_info
 
 	/* TODO: Help propose a standard fb.h ioctl to report mmap damage */
 	if (cmd == UFX_IOCTL_REPORT_DAMAGE) {
+		struct dloarea *area __free(kfree) = kmalloc(sizeof(*area), GFP_KERNEL);
+		if (!area)
+			return -ENOMEM;
+
 		/* If we have a damage-aware client, turn fb_defio "off"
 		 * To avoid perf imact of unnecessary page fault handling.
 		 * Done by resetting the delay for this fb_info to a very
@@ -956,7 +959,8 @@ static int ufx_ops_ioctl(struct fb_info
 		if (info->fbdefio)
 			info->fbdefio->delay = UFX_DEFIO_WRITE_DISABLE;
 
-		area = (struct dloarea *)arg;
+		if (copy_from_user(area, (u8 __user *)arg, sizeof(*area)))
+			return -EFAULT;
 
 		if (area->x < 0)
 			area->x = 0;


