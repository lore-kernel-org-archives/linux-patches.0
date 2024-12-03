Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B21E33FE;
	Tue,  3 Dec 2024 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238126; cv=none; b=AgjRqfa772dl4suUm2lrtGg8xPZWIPa53IldGdfaBRKjFvWp+D9Sg/SuyCn9adB99T8c+9pgKBnI0BQdm32cY9nO+583dYNcHX3MY3kCTJKAv1gwfxugexL8SjcsZnemY21FtYQtu2HqsuBdyeKdbhcCh2ldVvHWCTkT8x+r7HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238126; c=relaxed/simple;
	bh=mQdhALqRKGX1WSCW/hs4NGEES/DNft8/fuxRkThyUhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW6BZzCYXAGrHVFDUrXlwtCiaoUU952Znim7COFHX+oNk6VGeJw6sPKDAtXuWLYo+axnuKBCf4d4xUJCpSQs/yz7LsjTMC3cGYTpt61GuxCaljSwkTukFphstgimHMbhZlwgHcUAP3xFr8p9gZlDdIYO+VQ6DS+UHUFdq7vxXCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywrnm3s2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywrnm3s2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D46C4CECF;
	Tue,  3 Dec 2024 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238126;
	bh=mQdhALqRKGX1WSCW/hs4NGEES/DNft8/fuxRkThyUhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywrnm3s2EbHoVNUKRYk5dX2sfE3TTlBOwYUgHMSrzqWuso+kdDDPhwp66k8fEqOs9
	 IZ3RQndGNHINUawYuYjpEYjyNgQ+T2qKdSzVv4AU6xQub0NIrdB4ukJ1ELc4woj4zI
	 fKTyStIbuz8APylbC47tDma4mCAacxYlhPmkz9tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 139/817] clocksource/drivers/timer-ti-dm: Fix child node refcount handling
Date: Tue,  3 Dec 2024 15:35:11 +0100
Message-ID: <20241203144001.149595277@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit e5cfc0989d9a2849c51c720a16b90b2c061a1aeb ]

of_find_compatible_node() increments the node's refcount, and it must be
decremented again with a call to of_node_put() when the pointer is no
longer required to avoid leaking the resource.

Instead of adding the missing calls to of_node_put() in all execution
paths, use the cleanup attribute for 'arm_timer' by means of the
__free() macro, which automatically calls of_node_put() when the
variable goes out of scope.

Fixes: 25de4ce5ed02 ("clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241031-timer-ti-dm-systimer-of_node_put-v3-1-063ee822b73a@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm-systimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index c2dcd8d68e458..d1c144d6f328c 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -686,9 +686,9 @@ subsys_initcall(dmtimer_percpu_timer_startup);
 
 static int __init dmtimer_percpu_quirk_init(struct device_node *np, u32 pa)
 {
-	struct device_node *arm_timer;
+	struct device_node *arm_timer __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
 
-	arm_timer = of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
 	if (of_device_is_available(arm_timer)) {
 		pr_warn_once("ARM architected timer wrap issue i940 detected\n");
 		return 0;
-- 
2.43.0



