Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3093414A2A;
	Fri,  4 Sep 2026 06:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502654; cv=none; b=O6RKhbAZOstMY/NQJa8GYRWuNV77F8V7FWjwgx5U9dPA49EFFfriXCw5q9/8ajYjbvzD88H3ALPfxjrBeK3QOotd6OPf1XFQpoEEJCKyDXAVmRpDJMACcPCQEiOOTcRn0WcpHirUIvkTvTSxJgLuI3J2YDekLU/0yWiRUIr059k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502654; c=relaxed/simple;
	bh=GIBSI7NKHx0UE1374Hl82ZzfkDrTKxvnGDD/h1EWhqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9Mi5tKFeJyk4L5nA4Ao0uWohl71P1JJJQc5dlTxARwpAomehyGOYAqZElhnRwQpaigLyM/SnLsL/PTb40hyXuiFtwM71V44ZOWTdqD7XiABNtkjT8Tjf1E61wExFwSHA90qj9IWr8Mw8tSsM0hBS6yDP3sgcZUW+LXlHLaNy7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AquRxhtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AquRxhtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88871F00A3D;
	Fri,  4 Sep 2026 06:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502653;
	bh=paOZ7AnZBdd56P1bHjuQumDbRari7qMrsDtYBDI9zNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AquRxhtR7kXDnnixqIPaB4T28g8YnIeRgTXmvopt5FtVcwobx7qHPsiCV7WzVmkW6
	 qPtGPCeCCb6fxz8gN28KSFD1OuvdbJx8ByDEjcOcg9c6yUHsxpLBLnjF7yoZp1x6l2
	 Cx29LvhKMSEHr+5X07VMuz/Nmo0zyDu/hzf+zGHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 284/403] power: supply: max17040: synchronize work cancellation on suspend
Date: Fri,  4 Sep 2026 07:01:27 +0200
Message-ID: <20260904045741.314487470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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


