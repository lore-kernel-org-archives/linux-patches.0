Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251CC51121F;
	Wed, 30 Sep 2026 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790345; cv=none; b=UMZbis/asu777IIhFclMAsE3Z76o2o30s/ED8TJr7NApfNTggzNyUbHjmh4yMzGLPaodZ1AeFmwM3j4EMqSAVkuU0QfWsmSrEZXNunYUr66mydyiWXQGgiGMfVOcKi53rs5H1iYD1+LmLZhzVtof3UpS8zYUmCeGxxAOU9DcI6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790345; c=relaxed/simple;
	bh=xAGgz95mOn2/5jRhUPTAahKvyzccwNXIvdN+IH3xgKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0Mg+w4cXEmh2a87ZDEPVeqhaDkMvnD/2IJVy/S6+Ix31RFHN1JDnFFCYpPgosDmyyDu+Qq1BXXEjG+PzejEfB6t9aASYG8A7b+9yFJn3LFNpD+FHkjDs+CnVRv8CoAowBPXQMXZgwUUx3qchN0mIUfrH/Q8iqX4S/cuorfNoeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yolde4Mz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yolde4Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB3F1F000FF;
	Wed, 30 Sep 2026 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790344;
	bh=nFjHtzPc2oHKdC1BRUKZDoxGjk6aqGBINDA2BgqV7kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yolde4Mz6q6onlZgirF098rDPABHhvo8GBiHGdiwqkac/VuhMg+2g5RbNb0iUYcTl
	 mF7gGTgpvQLm9xWigF1JtiS1FCckxinPGLg4Yli5ohjQtYS1N72CWmn+Xtfog/oeg/
	 DBWISSJMnbKN5QLi4YonAtyzvql8ZsE/UW5mahps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 797/877] Input: hp_sdc - shut down kicker timer on module exit
Date: Wed, 30 Sep 2026 17:28:28 +0200
Message-ID: <20260930152431.914647033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 309731e95917125bbd13626a7a5600490a5bf44f ]

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
[ adjusted the removal hunk to match del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/hp_sdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -980,7 +980,7 @@ static void hp_sdc_exit(void)
 	free_irq(hp_sdc.irq, &hp_sdc);
 	write_unlock_irq(&hp_sdc.lock);
 
-	del_timer_sync(&hp_sdc.kicker);
+	timer_shutdown_sync(&hp_sdc.kicker);
 
 	tasklet_kill(&hp_sdc.task);
 


