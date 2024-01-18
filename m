Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9AA1774B;
	Thu, 18 Jan 2024 10:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575477; cv=none; b=dUVjsMrZIzQ6yVNetZUjPN4TXKIaTEkjz8Xa4ea7AI3F/BzcKwgUPSoqrqpZzAQTLn0pDpg8pFV8F5ij9EgsBTdcanpT5PnCN1IDSJxZoLqOEY9iVI1JiQnPNSYq1sict6r0QRVJH3qGsDm0ZU2slpAl3t+tKYxYQFMHjYXJd1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575477; c=relaxed/simple;
	bh=aFIY3Rc0nvctBtB7dFZ2H2Wc/ZZhT8axgwxboJ5QbQI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=el7VKtKZfdQNI7rb8w5pqF9F467ov24MrAekVAUx/ZgiTfR1J6kwMLXbL1laXV18j+mO1bOKEHeW7bqSDZHEggM9YamqWX4d6bIUVDYTWV2qOoTkStbe/SfF2TtkYco54Z0Aftkbo9Vy3MhKUpOEpUDky+bTNa5V831GZKJRM/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEPMkTgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEPMkTgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCC7C433C7;
	Thu, 18 Jan 2024 10:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575477;
	bh=aFIY3Rc0nvctBtB7dFZ2H2Wc/ZZhT8axgwxboJ5QbQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEPMkTgMuDeXc/qqxJAHYUBNdY1oPQRKlRV8cdsXBkECK5z3HEv177tib1cLEWgcU
	 gX7sA3CEV9p0cCFPkdY3XhtpbbJCz0E2QhS/M6AFp/W746ZRB4FT3GDdUR8TzTEDd7
	 mpAm+BlmgTPVyGmtEKGKyLok+omUXnRIjwFR3fqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 146/150] leds: ledtrig-tty: Free allocated ttyname buffer on deactivate
Date: Thu, 18 Jan 2024 11:49:28 +0100
Message-ID: <20240118104326.817467242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


