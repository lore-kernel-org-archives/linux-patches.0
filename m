Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDFD7868A;
	Wed, 21 Feb 2024 13:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521563; cv=none; b=hCFiOk/0sVLWmP6xWrFMk16uzojwnlsaHO//0ko8AVuFiC/Xnh1NfKe0LOkVNVR8HZ1fKi+D4k9B4Ne2bhMsjzTzADCfbs3UgoKOGDgqWckUDF4d9f9B73rxqWZjauk3gy/uaxNe6wELc+8gVLce/LLqKLUH/ZZoMYuyAK7P2FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521563; c=relaxed/simple;
	bh=j2QJ7WDr+cjejnHmOr8TB3+sfF4ZSwkPQFkF7RNQcME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBD4t2MfyeqKxlMiyeUqEMb5otnRnAp5GgeOSo8zxbLjGqNv83zjOJvNI1ojFNimgvA1Vu06xIpMGBw3w29YuAc+UL7F19SORTmPaoX0Y/hlnxlaKUcF4WAAoxPnymjyjF/mM1cdq87601+ScBbkNP0bzMSe9EXq5VabBnnPb6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VvW0qn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VvW0qn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A60C433B1;
	Wed, 21 Feb 2024 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521563;
	bh=j2QJ7WDr+cjejnHmOr8TB3+sfF4ZSwkPQFkF7RNQcME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VvW0qn9KPiuRJIT/QwJ2DGYXdCanE7O6ED+S3s5QmQCzrmM6RNcKXVwziWSpIgJ2
	 q0c3n7O2VfoHtmpXbTxF9n5R8c9W8vh5hGBxoxwzNJc7hgF04agthSxwWjbmwn9M0u
	 DDW8xaUul6GhHJYPnOM0TRJ3sK6Sh4FoMsPPO/wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/202] leds: trigger: panic: Dont register panic notifier if creating the trigger failed
Date: Wed, 21 Feb 2024 14:06:57 +0100
Message-ID: <20240221125935.480912408@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d735526b9db4..2fc04418a87e 100644
--- a/drivers/leds/trigger/ledtrig-panic.c
+++ b/drivers/leds/trigger/ledtrig-panic.c
@@ -67,10 +67,13 @@ static long led_panic_blink(int state)
 
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



