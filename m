Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF092B9BC;
	Tue, 23 Jan 2024 01:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972129; cv=none; b=I7hP+OGSJhlWC3phdvv3uFva8VkUBQ0Mk+Rd27jLsrULhavsmxliAFSyuUenPqI5MpLjTBDTRoo0saiH2DHUcbvvDnRu5CLNQ9Uqa0oTap1GRCUHjr7eFdRxthPnaB6hM7vMinkB6z4SS4UIq4+k0/X2/wOEjgRaxJqMn2Sy0Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972129; c=relaxed/simple;
	bh=GN21wtElZQ1qiwcEgiMpMQKAF39p+GEXX3Jt0/klQRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YW9Fc5NEoAnuu6gUbSXKqhbcH/EsxWitJSzEwXlrafNYAP5ExfMU+Wsx0VisOwuSlbXSGyBA22FpvESlGeE1sR1YrcGutCTOcQKvaDCmLDThXKHylA1YAWvVTvB8zaMkhLI2aCGT03J4IX0Nz03UWFi2lorcuGXYzbnqCbeHEoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cp0Sspzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cp0Sspzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A35C433B2;
	Tue, 23 Jan 2024 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972129;
	bh=GN21wtElZQ1qiwcEgiMpMQKAF39p+GEXX3Jt0/klQRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cp0Sspztndz0dxh4dkiTLUQwPBUcAovAKRo0GNQ9FShDtHeXd2epvChpQxlwM20j9
	 8G55BkUKSV+XeIqcTqNNAKcIhy8meGFXrhraxqqrSBz5mkcMdFhXkIstEx9QVX7q4z
	 SFOPPD4VaTxZp1bjA+5FQg0G4Tgfi7YGSrInNjqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 062/374] leds: ledtrig-tty: Free allocated ttyname buffer on deactivate
Date: Mon, 22 Jan 2024 15:55:18 -0800
Message-ID: <20240122235746.775325227@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


