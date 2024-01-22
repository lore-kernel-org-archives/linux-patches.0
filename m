Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CBD12F5A7;
	Tue, 23 Jan 2024 00:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969019; cv=none; b=O6kCZ3O5dFActkFV2eohyscN4uxNoi2yg7JqT91+IJzJHh/9qc1gHQPjYNbiMWbD4Iu065bZHKepKpoG+aUNbcQebswdMYXTPJX7CizF1mlRrmcV1x3yIekr6vvGhYKLAPw+V1CBHb62Ru9PThmYJoQzfCYt653bUve2YwkFeKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969019; c=relaxed/simple;
	bh=L68J52t/c7OopDjKsEsLdEkxPRccGmM5s4YUkg2ez+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGDe6m2/z02DFnjZwqrjwH1uu5KfalpW+5B/ReJG0VAZ6f/5AqJYZcuJlTWCPo3F4hmTj/7tD2QLYD3Koi+t3LPEdkji6NoeOquaBMymExz1CLEt/kynCs55V/7FBSnCK+Y8KWjpagrV8C2PByntq3o2a3ETNJAVRAH676ssfiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcWFUHMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcWFUHMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BDCC43399;
	Tue, 23 Jan 2024 00:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969019;
	bh=L68J52t/c7OopDjKsEsLdEkxPRccGmM5s4YUkg2ez+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcWFUHMH6zvjsedISymCG3e2AKxDJe4WzecejMEeWxoFH+21+QjH0nnX0GvF5YEXt
	 jW3U06Ub05QXoUDUMX0KIi7k3OvxJJasabHVAc7fouhdB+07OPBwc+R6TNdyEjRBbo
	 Vg/breCJPB52tUyp8xsOcJA1PFR56RzvYdXkEd64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 156/194] fbdev: flush deferred work in fb_deferred_io_fsync()
Date: Mon, 22 Jan 2024 15:58:06 -0800
Message-ID: <20240122235725.881928211@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


