Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A8135AC06
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302725; cv=none; b=jIxdr5JrZbKpMoV30h+2KT9Rf+xH4gqn5f3Rd5l2CSiG6ocnb4CHUqaL53Tq3vbPl923EigE3dXLGy38goFBD1OV537sGG/sfbzbPzdV+o70GY0t8qaAifLD+yN6hmINpfbpbkvfBvvuUVAIJUHO6iBQBn9x7PxaJdtv6kd9/40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302725; c=relaxed/simple;
	bh=MHVJqGulCgiqb3jl56+qcDnjg4YPjAeZDpjUjGYtwYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qac675El2YbFZ2DQnfoFkaQqbB/B9LqJEI1NXM7ru/uTAi80JGuuM8mvm2MiEE7e1zzpvwrA1fuAkMk4hVW749iXCMNPQ/E5B1B4Tdn1l2TupEhNNhUMlHScopt3/VaXuRPflrTXI1yRTdaY6HHWc0absf4KMakbzsw5NMgpDFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOrDspQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOrDspQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABB3C19424;
	Sat, 28 Feb 2026 18:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302725;
	bh=MHVJqGulCgiqb3jl56+qcDnjg4YPjAeZDpjUjGYtwYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOrDspQMxRxfWQGzrJqjS6rszFHeXdZPluEJACW3ttj7W2lw9PmeUq4ZXHFOdJwTv
	 GmTgHk5uYTmrNnPloMdnUuEBv4tvPgf2ndm0ki+NkQOSrIYG2YGphG6GKNV3VhZZFG
	 ltuItMlQgD3beWQIkQUKD9coIDCGB6TvJGyxv8SRNj93+GS6LuicpmkPJvv/a1+XKR
	 uZ37jNqX8V3fNHvo8fxDE1t4JgwUQPWk/qvsMkO2NkFO/Hsp8q2QbYKfrVB6d81NGF
	 yVUAyGbj8Tmdfp9M7TLHB2XMYwHk6HK8n/9W7+QwI4Qj0IhCU34/ab+CkG5D9WQ4am
	 aE6QOuOyewrhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/147] power: supply: cpcap-battery: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:16:34 -0500
Message-ID: <20260228181736.1605592-86-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit 642f33e34b969eedec334738fd5df95d2dc42742 ]

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `power_supply` handle, means that
the `power_supply` handle will be deallocated/unregistered _before_ the
interrupt handler (since `devm_` naturally deallocates in reverse
allocation order). This means that during removal, there is a race
condition where an interrupt can fire just _after_ the `power_supply`
handle has been freed, *but* just _before_ the corresponding
unregistration of the IRQ handler has run.

This will lead to the IRQ handler calling `power_supply_changed()` with
a freed `power_supply` handle. Which usually crashes the system or
otherwise silently corrupts the memory...

Note that there is a similar situation which can also happen during
`probe()`; the possibility of an interrupt firing _before_ registering
the `power_supply` handle. This would then lead to the nasty situation
of using the `power_supply` handle *uninitialized* in
`power_supply_changed()`.

Fix this racy use-after-free by making sure the IRQ is requested _after_
the registration of the `power_supply` handle.

Fixes: 874b2adbed12 ("power: supply: cpcap-battery: Add a battery driver")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/81db58d610c9a51a68184f856cd431a934cccee2.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-battery.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index 793d4ca52f8a1..e39f7f7414cb9 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -888,10 +888,6 @@ static int cpcap_battery_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ddata);
 
-	error = cpcap_battery_init_interrupts(pdev, ddata);
-	if (error)
-		return error;
-
 	error = cpcap_battery_init_iio(ddata);
 	if (error)
 		return error;
@@ -919,6 +915,10 @@ static int cpcap_battery_probe(struct platform_device *pdev)
 		return error;
 	}
 
+	error = cpcap_battery_init_interrupts(pdev, ddata);
+	if (error)
+		return error;
+
 	atomic_set(&ddata->active, 1);
 
 	error = cpcap_battery_calibrate(ddata);
-- 
2.51.0

