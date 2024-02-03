Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABC8182B3;
	Sat,  3 Feb 2024 04:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933638; cv=none; b=b0gnC8GnBrTxaVOjJD30i7il6xlfGgcaSqZXaJafmn8p7HvNqR0vNr9ib9T4QLTgK5/MfBFoBJUzBvMdHkZtGXX30IoV6pFRQX/8ibX0l75RvPRG1e5eQuQRql3Aum8O1hyizk/0xOtxP3hLg9IVAD6ccSpsq1pgGNUst7ZJkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933638; c=relaxed/simple;
	bh=G9VST/y9FcWBmogtaDGrCJf1UCdNWV+XIhUnbax14Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTGQ1oh0L9kEKEvTdLPVgmOwGLFgqs5btnDDs10/E5/NVWPcwyYd5Eqk3N8JRNKhwfkUdHDmIvh+vu3RkYQXF0Va2er3eEWfAMNXJz90sbidI4OSwI7IcTZIahsbtEszSXvuPTOdJ3bHNrHLXFXCMIG0Aj2oJVoFUsGcCaoYwsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCUr8SZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCUr8SZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84554C43390;
	Sat,  3 Feb 2024 04:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933638;
	bh=G9VST/y9FcWBmogtaDGrCJf1UCdNWV+XIhUnbax14Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCUr8SZcQWNl8cY5n78WwK7JT31MTYwOdzf5bS2d7k2vSmMhtZB31VDXkcvNJ+WYq
	 GjZeXUQYPWZ2ms3An9A5+dbpuUpbYJKgCVhDF+6ktUmxG57Q2e7IjFyuofC60nKycX
	 8HxgIzc2mTkoVfr4uBK5PZRWON7OEJdcdgKafgUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/322] leds: trigger: panic: Dont register panic notifier if creating the trigger failed
Date: Fri,  2 Feb 2024 20:05:16 -0800
Message-ID: <20240203035406.317711764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



