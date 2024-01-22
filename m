Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B41A133435;
	Tue, 23 Jan 2024 01:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971875; cv=none; b=n27scCk9BVyw8gpu8RNeEwGZzf/eHphAwrYh0bPcSWKz789mzOqdztz5BUqkYDapiWbZzDvcFbxkJPis+OfmtOwls0nha60IuKrWIkPkTCaYJSHnr2LBWpmtfb4sYTmUrBynsOqE0DeT818SW6BqVkPFLcbjH8yLaUTKq2X7AT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971875; c=relaxed/simple;
	bh=0W7gLgHlBiR9lIAddxdGHl+nAVQJBLGgmGa2p01PsJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzNoNZ5/cCOuW7yJZ92swMIGqLYzgmKlpF/bX6+63yn1YqdyzGOQSHfYhLNAQR9s2TRVxQuUPjYTasEJXLzLbj6VWpSyLHHRgPnRHC9hOed8txFz8hLvzzD1474uosYOSCjkTUEZj2Omq1Rup+rj9LbPRoO2hYEjcHuickLB5WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwFpjRgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwFpjRgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E156CC43390;
	Tue, 23 Jan 2024 01:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971875;
	bh=0W7gLgHlBiR9lIAddxdGHl+nAVQJBLGgmGa2p01PsJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwFpjRgs3HCMuYq6Lwv9oco1cj1VZ1lF8+Us8mTJFHZvPf8GGhcF6MRV7vRDTL2nE
	 MTOXpB6f1GekJa3rTpHE0ql4WQApGPsuvidwXUZ+YVzMgeSYQgzB0Wn8EbJ+jS467J
	 +OO20G3zOOUNVf78q8bN3phzb/NRG1FvOCPzYx4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 222/286] fbdev: flush deferred work in fb_deferred_io_fsync()
Date: Mon, 22 Jan 2024 15:58:48 -0800
Message-ID: <20240122235740.627717544@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nam Cao <namcao@linutronix.de>

commit 15e4c1f462279b4e128f27de48133e0debe9e0df upstream.

The driver's fsync() is supposed to flush any pending operation to
hardware. It is implemented in this driver by cancelling the queued
deferred IO first, then schedule it for "immediate execution" by calling
schedule_delayed_work() again with delay=0. However, setting delay=0
only means the work is scheduled immediately, it does not mean the work
is executed immediately. There is no guarantee that the work is finished
after schedule_delayed_work() returns. After this driver's fsync()
returns, there can still be pending work. Furthermore, if close() is
called by users immediately after fsync(), the pending work gets
cancelled and fsync() may do nothing.

To ensure that the deferred IO completes, use flush_delayed_work()
instead. Write operations to this driver either write to the device
directly, or invoke schedule_delayed_work(); so by flushing the
workqueue, it can be guaranteed that all previous writes make it to the
device.

Fixes: 5e841b88d23d ("fb: fsync() method for deferred I/O flush.")
Cc: stable@vger.kernel.org
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fb_defio.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -78,11 +78,7 @@ int fb_deferred_io_fsync(struct file *fi
 		return 0;
 
 	inode_lock(inode);
-	/* Kill off the delayed work */
-	cancel_delayed_work_sync(&info->deferred_work);
-
-	/* Run it immediately */
-	schedule_delayed_work(&info->deferred_work, 0);
+	flush_delayed_work(&info->deferred_work);
 	inode_unlock(inode);
 
 	return 0;


