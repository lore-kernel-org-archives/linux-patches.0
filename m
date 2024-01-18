Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1045B65C;
	Thu, 18 Jan 2024 10:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575051; cv=none; b=ZVmUU7sYARkBBQN4M3jd/POPxTGHsGR74yDHHMkSDpsLMnmQV5yh7g9fvnyFOFBvrWXKEkxl+XkkVVz9ZcNuBIR8/fJJAhVLsPQqSr0NBvK+6IgftvR8NRMNCjJmqaPPpfLPbJQpHpenQFw9KOFwZ55sXn/2oaVeOJ6XCvwyjVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575051; c=relaxed/simple;
	bh=D899onBO7v2hnluCiMbrmLZ0+ThPTHDx1aPQXJxrAhU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=IG9aOyCOhITcIC39+8ASzrANpDfsS4NHa9a8uGrifJIsab7SdZvdC/yYQHlYbuldIui5AO2VrsWA3QBP3zEjBSlIE2YVPHnBFTqc5U0ml6lkDuXYu6ERRd2Vk+XuHdAdk+Ipo/6BqA+KuwDiJDL2DNZ2VWOVopWTgq2ouq4FeFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vlqm5mD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vlqm5mD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD35C433F1;
	Thu, 18 Jan 2024 10:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575051;
	bh=D899onBO7v2hnluCiMbrmLZ0+ThPTHDx1aPQXJxrAhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vlqm5mDg7E8D3Z//3wh+1WxCAR5yQySFG9/L+E9IwPdFDVyr2sn4poIi21KlnhWI
	 /N0cuplm7/UsbU3b1VwcttpwUr6YDpDM40/UednR7Tz8NZrA4l7/Ji3xMX67Doc7Mh
	 MEnVMCnz9U0y0gJI3sqMbpYJ3HWPV895BDmLuZEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.7 23/28] leds: ledtrig-tty: Free allocated ttyname buffer on deactivate
Date: Thu, 18 Jan 2024 11:49:13 +0100
Message-ID: <20240118104302.021359138@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Eckert <fe@dev.tdt.de>

commit 25054b232681c286fca9c678854f56494d1352cc upstream.

The ttyname buffer for the ledtrig_tty_data struct is allocated in the
sysfs ttyname_store() function. This buffer must be released on trigger
deactivation. This was missing and is thus a memory leak.

While we are at it, the TTY handler in the ledtrig_tty_data struct should
also be returned in case of the trigger deactivation call.

Cc: stable@vger.kernel.org
Fixes: fd4a641ac88f ("leds: trigger: implement a tty trigger")
Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20231127081621.774866-1-fe@dev.tdt.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/trigger/ledtrig-tty.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/leds/trigger/ledtrig-tty.c
+++ b/drivers/leds/trigger/ledtrig-tty.c
@@ -168,6 +168,10 @@ static void ledtrig_tty_deactivate(struc
 
 	cancel_delayed_work_sync(&trigger_data->dwork);
 
+	kfree(trigger_data->ttyname);
+	tty_kref_put(trigger_data->tty);
+	trigger_data->tty = NULL;
+
 	kfree(trigger_data);
 }
 


