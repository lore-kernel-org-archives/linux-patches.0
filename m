Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C643749F7;
	Wed, 23 Sep 2026 14:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173831; cv=none; b=IA1kSfcGzEvkXgoTlhc8HjY+Y+lFDCvD47kN3BtM1c8pSqUjCxk6uoSXd85da/VrYkJpDuwn7s9+vhtzGoK5TcEBeSOzPZ+BbPIOshgZD/zcBfRNw3YcAR+vSBaeQ7ab24bH9QDM1ymyPZA1h/pGZ4g3/w2r/L3J5eRRfSfSR9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173831; c=relaxed/simple;
	bh=lSjgbMhq78E0s5moVnWj8arJKK+wNJA8orJxeMDJ20I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nY9WLKJPI+z9XrEs7xd46/f0bo3gVAvOrvidVH+Oc+6fsQ0qVmsYHFRkKTXp45ajwlUgaAtLOf/2gtQ9E/RsKWxFe9tqr8p+JIRRyaUNc6fzZuxpka2QKon7McYXrVI4jfE1sMjpZegQNzxGcH8YlLa6fiWKM5iKHmgJmf8MjKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2g9CFhF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2g9CFhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B388C1F000FF;
	Wed, 23 Sep 2026 14:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173830;
	bh=NLHE97tI9Y0qXGINNYQ8v8Np4yja0nWSApVrQ2s6lIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2g9CFhFZJc/AJ7d0OJV+eifIotv3cQ0CEtv1MDHQYgVGPu1Bkqy/PbaFQc8bkVz4
	 iIov6apjx01O04gSpYph2Dd7Fu44bcECSLezcQXo6bveTTnCnknV5XVAB7XkiJYX+d
	 ylAVBDLx4J2DdnC7569AZSdb6PUQVFNQUFd0UMCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 357/438] Input: hp_sdc - shut down kicker timer on module exit
Date: Wed, 23 Sep 2026 16:06:18 +0200
Message-ID: <20260923140654.093501588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


