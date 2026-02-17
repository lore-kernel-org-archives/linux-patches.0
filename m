Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED8F2DC76B;
	Tue, 17 Feb 2026 20:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361109; cv=none; b=oNrgQyatlQWETBBazZAMh1ExzS1GIFMn/KUW32T0z1Lye3fYTAaZOi7Q/Bq9NOyJU7tnH1bqYxhrKRbWvJqks6Yknrvs1WCAjqeRu1KYQpJF2hrGdQ06F1XUwkd75xhloPiAlDv6oc42rhZ7ryF6nd4hvOezCCk8nDR+1nMRaxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361109; c=relaxed/simple;
	bh=dsVbNXzHudBTSCrhUCbc40ooaBS6jFsdZtMSJkIz128=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjTD4SU7oRP7y9JWwhZrIS3QcfGjin5JUz6ha72XfxPMgMgCam5A+udI43THKDsAUq9mLSaxnE3wgQFghQAEWkC6JQM88YV5Y2uVt1uuKVA754p1CBBX2P4ndqFknnf0j0Gqlz+qfavQhkFBZtaL+F7oJeejX4bFjDqYJ7A7ito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMEL5JGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMEL5JGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC93C4CEF7;
	Tue, 17 Feb 2026 20:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361109;
	bh=dsVbNXzHudBTSCrhUCbc40ooaBS6jFsdZtMSJkIz128=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMEL5JGL7Zwi7R8yiGZDkF9uZJYb9CzSnN46qbrvBV19sIFodXrMqUEgBQ1+6uymh
	 VrDXVfjvpvIgaWzdS0Ef+BPjy7P23/eLNZDRMPpojT/moOI9CXHnm98iIDvc0HtfDF
	 7orBkKLD8fRwuxcSS+joxWcQffRWXXNqmMHrZ+pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	stable <stable@kernel.org>,
	Steve Glendinning <steve.glendinning@shawell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 36/39] fbdev: smscufx: properly copy ioctl memory to kernelspace
Date: Tue, 17 Feb 2026 21:31:45 +0100
Message-ID: <20260217200004.333406960@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -986,7 +986,6 @@ static int ufx_ops_ioctl(struct fb_info
 			 unsigned long arg)
 {
 	struct ufx_data *dev = info->par;
-	struct dloarea *area = NULL;
 
 	if (!atomic_read(&dev->usb_active))
 		return 0;
@@ -1001,6 +1000,10 @@ static int ufx_ops_ioctl(struct fb_info
 
 	/* TODO: Help propose a standard fb.h ioctl to report mmap damage */
 	if (cmd == UFX_IOCTL_REPORT_DAMAGE) {
+		struct dloarea *area __free(kfree) = kmalloc(sizeof(*area), GFP_KERNEL);
+		if (!area)
+			return -ENOMEM;
+
 		/* If we have a damage-aware client, turn fb_defio "off"
 		 * To avoid perf imact of unnecessary page fault handling.
 		 * Done by resetting the delay for this fb_info to a very
@@ -1010,7 +1013,8 @@ static int ufx_ops_ioctl(struct fb_info
 		if (info->fbdefio)
 			info->fbdefio->delay = UFX_DEFIO_WRITE_DISABLE;
 
-		area = (struct dloarea *)arg;
+		if (copy_from_user(area, (u8 __user *)arg, sizeof(*area)))
+			return -EFAULT;
 
 		if (area->x < 0)
 			area->x = 0;


