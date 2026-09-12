Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB77E279DC3;
	Sat, 12 Sep 2026 19:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241455; cv=none; b=r6yZkxsjjuwnT5o53zjo+8jCa+4uvS7rdbJ+9qsxFbjNBtqMJh6x1+SEt3ee7gjgeqaaj5CVXbWWNxBFlRtuFRPLFXHqUhfclZAwTtD23nQORsif77sX3wYT3yRaea5xQhONJaF2f0qo4pzobPNWTwqWyEohR5JL2HjWro4scRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241455; c=relaxed/simple;
	bh=us5My/pri9JblAHNtWKy+P6wQ0kWB8G640cD48hc5Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWlzu85/cTnbgTymHIIRkWynNGCjzpmnqUXCQKGk0ZtVTdoMXjx5s58EDBwKPwW9LHAnj1BXp0QFD1l+xKxJHNHmpwbO5Pd4eFxQFR92dk2IUaPurlTqQmYs6UGq/DVFUFpi1w7o3RL2chzmpF2SD1PIphm34al8ZTdKBnkAki4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2t1m4FZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2t1m4FZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85DF1F000FF;
	Sat, 12 Sep 2026 19:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241454;
	bh=OMWq+CNT8CNHt5VTaZFYfqf6NgBoIh9GHTQo9jrQNG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2t1m4FZ7u716YQfPTKpT8JOqc78LSfTpxlOb9uAi6sbBPqGwy0M7p7fV6rYmR+TLG
	 SCFBglErW3+r3sbX+l/XY2Ohcvkq8Whho6KBGXWEpZ+Wp2c1vxDsMZK85OZl6j8Xok
	 K2RSR3TtofmewlnAcaaiAGo8GMFFVxfj8k4UTWaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 138/798] power: supply: max17040: synchronize work cancellation on suspend
Date: Sat, 12 Sep 2026 08:56:06 +0200
Message-ID: <20260912065520.141796801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -566,7 +566,7 @@ static int max17040_suspend(struct devic
 		// disable soc alert to prevent wakeup
 		max17040_set_soc_alert(chip, 0);
 	else
-		cancel_delayed_work(&chip->work);
+		cancel_delayed_work_sync(&chip->work);
 
 	if (client->irq && device_may_wakeup(dev))
 		enable_irq_wake(client->irq);


