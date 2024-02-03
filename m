Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A9251005;
	Sat,  3 Feb 2024 04:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933892; cv=none; b=otJUkpcE7j9epeRICmh5IO1cW0gz9Ezf2xo/jl+yMdC5W79l+d8HdmEHeJ8JchvLywNRAnBQeiCywFuf71vKsGtOVULvfaXqQzs4pxQ0lqzxb6KB7qtPVpxbXag0jY3hz9miKSlkouvE/ETs5RdHv4G2miPj0V+EOnPaHKTREak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933892; c=relaxed/simple;
	bh=Kn3lkkRntuqFrOwMPsyfUrL2y1wWejkqpPjR8ba0hVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZcg1VJNYHFfDMKJvN7sZc1ivb/M/92/VaYu8symSyhB2RX97w26W2UNg13aBpbL9GrChwKaOuy1c4FkjSqcQ/9cw+69yBzHuq+YuBPHDzVOLcYbwN9I/k4U/+vbMsWr8x+UcFp/2l6/V6XnnnGnnrpoDIBX9+rlP0gEcVH9NwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl08UU5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl08UU5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54508C43390;
	Sat,  3 Feb 2024 04:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933892;
	bh=Kn3lkkRntuqFrOwMPsyfUrL2y1wWejkqpPjR8ba0hVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl08UU5aGyqyCR7Cw+bfZbLfxv8VfBc3sK47ev2cG/HtBhMCCefq3Q6EVT9hJKnd3
	 zdjqMfFkJbLsk2UD9LBNNkYqWD4yqXeXOMbatpZyTWnencgtJLIpPCgis8nvCGmYLd
	 qbjIPgw4C137Qudx2Ki8hIJDW+ArDezsFcjC1YRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 238/353] leds: trigger: panic: Dont register panic notifier if creating the trigger failed
Date: Fri,  2 Feb 2024 20:05:56 -0800
Message-ID: <20240203035411.206218900@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit afacb21834bb02785ddb0c3ec197208803b74faa ]

It doesn't make sense to register the panic notifier if creating the
panic trigger failed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/8a61e229-5388-46c7-919a-4d18cc7362b2@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-panic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-panic.c b/drivers/leds/trigger/ledtrig-panic.c
index 64abf2e91608..5a6b21bfeb9a 100644
--- a/drivers/leds/trigger/ledtrig-panic.c
+++ b/drivers/leds/trigger/ledtrig-panic.c
@@ -64,10 +64,13 @@ static long led_panic_blink(int state)
 
 static int __init ledtrig_panic_init(void)
 {
+	led_trigger_register_simple("panic", &trigger);
+	if (!trigger)
+		return -ENOMEM;
+
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &led_trigger_panic_nb);
 
-	led_trigger_register_simple("panic", &trigger);
 	panic_blink = led_panic_blink;
 	return 0;
 }
-- 
2.43.0



