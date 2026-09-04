Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F067D26AC3;
	Fri,  4 Sep 2026 05:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499713; cv=none; b=j/xfDj2/PRFPd6I4i8ey6ucrvRwjkGGQvKgx/CCF45Tmz6OZqC8o/El/oNFa3d5cnVXCy+zybLDWBkPLbgdRqnglznVeOJyGvcD1bTxuFSnzyOeMkVBa7IU2MnI1mjiTtKhxJIoARflBad5DMMwTGQ21pfHIGANJhU64IfVYDSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499713; c=relaxed/simple;
	bh=B1XXvKRuwnKIKv6HNXlWokPqnuRoxeO2/rb45i/Gk8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cW/oDuspK02AN8wxPQCRBIND76oHC3iuZnrADYwteZTy7ivnluWBo8vl5nrY9BmuaHSGmLTvCeRGVHYgAQ7iNxXpFldYkgmMK0Hak3SCekJFO6wvqdyCRvXei56aWOIu8B83H9cVRmRTeB7+bk2Ek1qehJuiK5RX/sfyAoqofuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5PxsNtj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5PxsNtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B9F1F00A3D;
	Fri,  4 Sep 2026 05:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499711;
	bh=Cwe9lBaySTsuGLlBzmlp5N80t3Be5GJwjnOMXIlkoLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5PxsNtjeTNoXJcJOcwFfE6uCMVunt4/i/HlQclyRvRRMvP9Jk8qpq5lq2uRpycKa
	 A1W+75SjNA101ND390BLnxUZzf45nNftBz8ZRUXvLv4WOjmzEDyFaZWRFZWY0PPd3N
	 uRqA414Q+woW8Y2Bb8GQvKwTwmVRL0jcUeg5vMjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.2 514/713] power: supply: max17040: synchronize work cancellation on suspend
Date: Fri,  4 Sep 2026 06:58:02 +0200
Message-ID: <20260904045815.339825129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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


