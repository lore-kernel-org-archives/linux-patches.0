Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDC42033B;
	Thu, 18 Jan 2024 11:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575786; cv=none; b=H9ybWIUe+r8V+hYlP9Vxpy2BuXss8xaiZflhKpl9jegyZIgWcK0YLqUxErz/XO6/KC1b9Hr+SRi0W17mpEQP+yPuMnTTlrxbahRuAxvFniHSM0iOrTKPkVWQ+uwwOWrU1jTfmgMxWlaXaMZktGNtK2znLC9A410pXCJsCH1/vUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575786; c=relaxed/simple;
	bh=Qk8CYZcc3ejZPUHllpO+023mtZ0j9jzVvKNtf+SOpUs=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=Ea8/uso0S+NBtTgepRr9rZC0jyqxQs/vH3An+PRdM3Vw1pfV77nVZVb4GzQ5VGxRAVnw9wx+DvD/opEyr8n/Rupkw7DJVQ/p28M60Cm17kKIdrOufBkZC/0MMQ7kw6ZmocHguiqlfH0h1/wj1/lrpqztoRRo1LM7hQpmt2OiDcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Di9YUDTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Di9YUDTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439F3C433F1;
	Thu, 18 Jan 2024 11:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575786;
	bh=Qk8CYZcc3ejZPUHllpO+023mtZ0j9jzVvKNtf+SOpUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Di9YUDTTsQLqQfRzqRNiZpDmN19j9RXgvuWEdOPL9W2optBHnpuVSYVTZnOLYin5y
	 I3J3+tFx31zNRMfsgCrGqyOxFQYAKDjL2Z9HLcFobuUHuSSXdVTkxlQOeN8/RaOvIN
	 X6LylYREX+d1WIfNg9di06E8AFtNFXbHxkxtePGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 097/100] leds: ledtrig-tty: Free allocated ttyname buffer on deactivate
Date: Thu, 18 Jan 2024 11:49:45 +0100
Message-ID: <20240118104315.060761764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


