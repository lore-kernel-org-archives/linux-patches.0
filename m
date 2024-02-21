Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB5A69317;
	Wed, 21 Feb 2024 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524289; cv=none; b=ibedCICaRlE8Jzu4ZUl83B++GiIncJksaMgJpPu+PgufFXPLvYExKRXVq8jtzGpPKCpXUxhS7DjgHOLow8Ni+oeZ5JRlUv+V1fhgngrtaHpfBJk3n55ZzAjn97WdkrB/zy/LyXaz7K32+QJDFDBYxEgwUuB9eTC771EV0r/xma8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524289; c=relaxed/simple;
	bh=zcVQ3OAIMuTMYPGHoShCc9a+hFkIGnp4zQlKFc/M1qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJUV0cuzwKTrE3l9k6QJmok3qvBLAp3Iyvghx80DDR9J5incgT/S0fFjBzMz/6EvrsAUZURfChNi1++a3CYi0LAM2dzsVIdtcOeLQqIJlkmBQu/9zpSTSgIVGjKAkWJyKvfC3fmY78s6yhOCRq9dUA8w0fYXxZ1khhenEgHzZwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxzoaJXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxzoaJXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEC6C433C7;
	Wed, 21 Feb 2024 14:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524289;
	bh=zcVQ3OAIMuTMYPGHoShCc9a+hFkIGnp4zQlKFc/M1qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxzoaJXpFOmApL6OU8e1mevvltH8vTs79mSDuT6FCtSVi1XUtzNPFDBntzV2YPEDI
	 bH+E3FnSJwfqEPY8HrzO2AqAjoAFFohbVb66jMRP40Y2eoV9jkpR+Cu/CG9soDXAer
	 rneAQIO6VQyHWLz6jfWkPwLxWQwweZINiyQvhzsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/379] leds: trigger: panic: Dont register panic notifier if creating the trigger failed
Date: Wed, 21 Feb 2024 14:06:19 +0100
Message-ID: <20240221130000.820325587@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5751cd032f9d..4bf232465dfd 100644
--- a/drivers/leds/trigger/ledtrig-panic.c
+++ b/drivers/leds/trigger/ledtrig-panic.c
@@ -63,10 +63,13 @@ static long led_panic_blink(int state)
 
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



