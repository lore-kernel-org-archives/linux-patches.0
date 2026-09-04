Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA823876B3;
	Fri,  4 Sep 2026 05:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501360; cv=none; b=OKaUz3p+lWuCMt+jba5hdg8v/+f+8RrdwiR848OT2FrkAM9iHPZgV1o7HfCZ5pqZNYpLBsdZJn8/scD8YhKJJEjxVAY66SyrkrrZB015Qt1oJPB0PxPMBNi7lrX2CTAmT9GTmJmGCcyf4sqMMlPoEaYpLSgOFg+gS+6zlK4DyVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501360; c=relaxed/simple;
	bh=8QCv/i+Ja0eKAbwKMDGibQGBSIJnfI99w1wm8adiov8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVilkCDBBEWDq7MqZYeHRdvCtm5+M0xcFzcxnmkFkgP9bwBuOYk/fMEauKBHh/XkoxV6HpSgGJUnyvjAtmX/HFO/NrTIRjeBw1LafwzZb8bNw4FI9uGkAZpg2n3ig09xVZAkfp/DjzU46FBjHTyVZptIiK/OBjpaJxvyXDLeShk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2nR72W0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2nR72W0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D551F00A3D;
	Fri,  4 Sep 2026 05:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501359;
	bh=gmLsuHgwvJmYu1CebdCd3hQGbSiwU+/ioJyBnWt8eag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2nR72W0GUnmxf7Um+WCQcw8ROYriKtpW3Htewq2+IGEoarz4RvbNLJYgavhH/kGa
	 UayyhRv/7C8mDy/3+06Y635CZCOc26uQDmYdUnmS62aO+pJEks86dxs7d0xsYtjV7g
	 F+1dQDYw3l0Mw43n3usb+Pws+0QJ1kI/tbF5AnCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 381/552] power: supply: max17040: synchronize work cancellation on suspend
Date: Fri,  4 Sep 2026 06:58:58 +0200
Message-ID: <20260904045758.853292185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Jianing Li <m13940358460@163.com>

commit 86a3a8a926aa5969c329d1df2d3259f189961bbc upstream.

max17040_work() requeues itself after every poll. cancel_delayed_work()
only cancels a pending instance and does not wait for a callback that is
already running.

If system suspend races with the polling callback, the callback can
continue accessing the fuel gauge and requeue itself after the suspend
callback returns.

Use cancel_delayed_work_sync() to ensure polling is quiesced before
suspend completes.

Fixes: c6f4a42de60b ("Add MAX17040 Fuel Gauge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jianing Li <m13940358460@163.com>
Link: https://patch.msgid.link/20260810004701.1683-1-m13940358460@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17040_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -580,7 +580,7 @@ static int max17040_suspend(struct devic
 		// disable soc alert to prevent wakeup
 		max17040_set_soc_alert(chip, 0);
 	else
-		cancel_delayed_work(&chip->work);
+		cancel_delayed_work_sync(&chip->work);
 
 	if (client->irq && device_may_wakeup(dev))
 		enable_irq_wake(client->irq);


