Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F317317145;
	Sat, 12 Sep 2026 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227445; cv=none; b=sP3Y1uhlnO3AS8IQ1xPZvbOf2IshX6YEmtn7SD0hHOLAtAFoFy0xssAbO99Udiz038yIR7m/330kUlLnIx2rotgHAnhIkSRs5xXC8Kk8755QSwCNejvlG9Pc6aYBN2Fq69+IJ61QEck2GWNRpMniIEflOfxLdiv345suzWhxT6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227445; c=relaxed/simple;
	bh=EbcLh3OsB9WICxgRLKWiSzMOfgrhhlqeBeTyHTBsguI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rkj+k6XGMMjqORnmFv5AXMHT7Ey8/MYgtVvaeDbjwLWF0tR/MSrM9zbtZdMqEJhpCxKBcEqxvGImunChTGY0CyoL25KQb62j/hlcFrngzmu7iMrIMkij9Nx55Yd9OLcxXEI6hlxA0oxgG300xk9TVoHEO+FH4GLWQzGBBVn3Dak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fl8FeZd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fl8FeZd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8501F000FF;
	Sat, 12 Sep 2026 15:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227444;
	bh=hKhzQtYuC0MNQT6DvBMvuNPDsdxRVdYTEJaxqmGgXEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fl8FeZd+xNlnqq86J3w0BYza7fUdWsrkqNV76s25SkqJtKJxY8jvolpczp4CIkaoE
	 yqYYcJQ/QTX7TWtdy3kzby4YBig3mL2EQB4KJWMVWw7+59nUveJm92dOXV3vNYQwUX
	 Ff0yoYyHsesOxVILheS6OrTOySkAl47THg5NKGp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 0181/1191] power: supply: max17040: synchronize work cancellation on suspend
Date: Sat, 12 Sep 2026 08:48:29 +0200
Message-ID: <20260912065552.281573942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -532,7 +532,7 @@ static int max17040_suspend(struct devic
 		// disable soc alert to prevent wakeup
 		max17040_set_soc_alert(chip, 0);
 	else
-		cancel_delayed_work(&chip->work);
+		cancel_delayed_work_sync(&chip->work);
 
 	if (client->irq && device_may_wakeup(dev))
 		enable_irq_wake(client->irq);


