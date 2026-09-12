Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F17832D7F8;
	Sat, 12 Sep 2026 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236942; cv=none; b=aMcRs8EYjfY2ZYMDoy8+RNDIc6V3rj6VmZ26k69K/ecZv4ndW1PkFlk0vdMSOFKsZiVWsu0dUJhBF7Ix8tnZ0v0jWm9Phc68gwtrGRi07l8+dEa1270CgRxn3JO5BhFtCi/W94lqe19tCQ3D04X1DwD82NLzaiPlvTTVzc9NSnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236942; c=relaxed/simple;
	bh=D0XBmXFvD+Q+kr7C8A04j4aZs0WZYRS7YVeI5MQIyEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9M9rOBn9oye9vWuXvudgyYlehC5XDSjMeQ9Z/GwAHmQxVtXuKFwpuhwrFua5G9dK+yBRzoO5/n2/Z4R77aTJHoy74YuzhhPybeMItdSnN0T73LLAOBDZbvyHaVRkdtXn9R7+WrqK57DFE+8qhh0uOyGfsNc1GyVM52bfYKVzjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbDvDWs6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbDvDWs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443F81F000FF;
	Sat, 12 Sep 2026 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236941;
	bh=VVOjHpt2I3bjcV0XaqCR+YkUnAAZLhPa6kjdtyYC1uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbDvDWs6F2GivDyc7XTtiRzsGsHO7R+y7scXZZYDrn2I3659vKiRG36Bf88LYUVTt
	 38Q099k7QJp5316krr/gaE2KXngdb6Pd9ZG2DXcQ4eKOYcLeKILXk1fKJ/GdxB09kk
	 7+hh6aEhM5a1ZR8zRh8R9Zlw1QzOY+SwB/D/5vWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 157/935] power: supply: max17040: synchronize work cancellation on suspend
Date: Sat, 12 Sep 2026 08:53:07 +0200
Message-ID: <20260912065530.423231967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


