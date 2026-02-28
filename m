Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A9B38D014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302175; cv=none; b=I7I8NsMuyRKMFWj7xv4LGHPgscH4u7gFAaLzzCske9YobOlcCIZ4QplE5ZWyujywREtH7GR6kZ+f2rnGgMjsFirThov4C6VPuT9aT6sZ10IdoT91V8hllIqgSXC6n2xfpbMgNqE7PcTwHp6TbVTwFB3tr/8EbgEQnK9Xzzzlw3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302175; c=relaxed/simple;
	bh=0EE7IJPuvydy11z66BBVTENbRCSKXA0wnqpjsu4IkSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSicCBeAGVv+Dy3ZmHOLWUBvadShTSmPk+XJQTD1vf0z19++v/v4G/xxFUSClvW16QD4mqS8jJ3jcwdIOYjjjNwWeZqrNkPUZVtG1ydNugWvD2p3HTOWultJ142Iz8UEmbsGmBweoS5Kj9nY8gc3KgS4gdUinIe1aKCWngCKMCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfBPhJvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfBPhJvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E648BC19423;
	Sat, 28 Feb 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302175;
	bh=0EE7IJPuvydy11z66BBVTENbRCSKXA0wnqpjsu4IkSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfBPhJvLn918A5mUs7FpSwKr6vosYjUNvowrw6LRIftaYdZXLkkg1yO//MgbiXnU2
	 IWbbc+RmhAkHhon0VAFg0MkLqhrNnZ72pRxX7tfZzkWjBQoX8aRaukWXmL0I+3ObQc
	 bZORov2wNTvQzhMA/KJ3rsh5PBK53Pb78MXhbNdAmgnVTp9D+a89JzjAoi+Kwxk6aj
	 QY+HmdKOaI/VEEz6+/l5AQ4566fQK6BIBBBtzq24y6qHLRsPOQhwMbozmP8EEyVV6m
	 BrWh6iDCvXPOaypExUm+PlTJ4SWeTJRd/MdHqzpNW7QaFX7qrvouACGhC060DOXKQm
	 RrxHYbJNFhjvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/283] power: supply: cpcap-battery: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:05:16 -0500
Message-ID: <20260228180709.1583486-174-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 5dd76c0ac98da..d84b81e773628 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -1122,10 +1122,6 @@ static int cpcap_battery_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ddata);
 
-	error = cpcap_battery_init_interrupts(pdev, ddata);
-	if (error)
-		return error;
-
 	error = cpcap_battery_init_iio(ddata);
 	if (error)
 		return error;
@@ -1142,6 +1138,10 @@ static int cpcap_battery_probe(struct platform_device *pdev)
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

