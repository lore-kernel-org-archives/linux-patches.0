Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D86539790;
	Wed, 23 Sep 2026 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175025; cv=none; b=hRqb1zMWOkoAmWvFXsdKcGoYu+WvfxfOhPckH+hXb3dzqUuRHtlO57r4XZ1bN6bMYS5WzgFZJkxT82NGljJsVfZbI9QZnTVuNNH2O2/dt0ZWnhDsAIMqRVVScvdVBu6hUaxxK9RTibMvOpiKZv+zAZ8RsbnGrNUZl6zHaNJjS54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175025; c=relaxed/simple;
	bh=DNN1jYSZHsNumfPzXUDUyN5zWWXh/+zxs4GUVmQCqbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDcmNASBumsmyoWIQwbZ7csZ8RCNYXv8A6hzvaadrt27YEhgMRnbYb9cxumoztIE8b6g2XWZ19lpgAdh0ORLzDmc43HMy1Ul5ppIJPyPXjsRqYiDZill6NWD0wImb6S4AQE7d2YO/hhH40mrmsoQkwcrWvzs6Mm7Ecg9do8jxM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+0Y4TkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+0Y4TkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDEE1F000FF;
	Wed, 23 Sep 2026 14:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175024;
	bh=iNK/2m+cJ9y5OHHrBQHWGFlsRRNTpnEFeTrzgXIsUkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+0Y4TkBjJEkwIvseyJW0aIZmLJr1DGlEFac2GFiWDdLUs6ZOJsQjvNJhdRzyedEw
	 KQ35USK32vmaeGgGJxJMUCYGO05vJqaNfim7Oh69jUI9re6VUv4RD7bZ1JYVcfW81H
	 wt6DwgWvuBtITQWj2Ri6a8YLx9PjSB1igJY8oZc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 298/398] Input: hp_sdc - shut down kicker timer on module exit
Date: Wed, 23 Sep 2026 16:06:12 +0200
Message-ID: <20260923140651.146678663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 309731e95917125bbd13626a7a5600490a5bf44f upstream.

hp_sdc_kicker() rearms hp_sdc.kicker with mod_timer() after scheduling the
tasklet.  The module exit path uses timer_delete_sync().  That waits for a
callback already running but can still leave the timer rearmed.

A callback can therefore leave the timer pending while hp_sdc_exit() tears
down the driver, allowing timer activity to access dismantled driver state.

Use timer_shutdown_sync() for final teardown.  It waits for a running
callback and prevents rearming after module exit begins.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Helge Deller <deller@gmx.de>
Link: https://patch.msgid.link/20260902154004.3595416-1-runyu.xiao@seu.edu.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/hp_sdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -981,7 +981,7 @@ static void hp_sdc_exit(void)
 	free_irq(hp_sdc.irq, &hp_sdc);
 	write_unlock_irq(&hp_sdc.lock);
 
-	timer_delete_sync(&hp_sdc.kicker);
+	timer_shutdown_sync(&hp_sdc.kicker);
 
 	tasklet_kill(&hp_sdc.task);
 


