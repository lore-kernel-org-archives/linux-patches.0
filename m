Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387963C2F;
	Wed, 21 Feb 2024 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522818; cv=none; b=YTUhyO5tKMVtL5gUMZ5x1F+W55EB1i5wr3SaHuxD05GguAt5Jl9D481Xk6yWfxh7BGD5Hhh3wAtiENNY2RhdmMwZfTaACjP00jyF+T0get+Q2BshTX448GIQPFmQ+cK/wAYYC+bjTylOBftB+wpmiEG94Ai3DSsQfrbJiBuQ9wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522818; c=relaxed/simple;
	bh=0R+dryajc/nY1r9J0/RY3vO7nBUL8sk4M0B8ovc8X0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kq3YowSASlRoBX1+fHIYZ6qErphWHoxwZrw84ILDdRtyuJejnNDqMsTmTyplq4xZMIi37Zj/lp6uTBTc6v4RVmulzqw62E1BfEiZ/+Xd2CUgHEDefdEpbaGra2WaY3bpLJ0ybEqX+GyL3J71BfS6audcw4KHRiEq0tk/esnni74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlFZ4QZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlFZ4QZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDD4C433C7;
	Wed, 21 Feb 2024 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522818;
	bh=0R+dryajc/nY1r9J0/RY3vO7nBUL8sk4M0B8ovc8X0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlFZ4QZ8qKu3V38pu+7LpbsykB4mw+i1MFO0UaAw0tLXN/UUDkHyYSwShFhuOoy7a
	 Gdc1/jlN6dMxM7A1ISfnEr1ULSPZ8sKIL/ZLmIPUwNpAioVFPfjlEunNmG86fq49VM
	 q4haXgH1bVKOdflwNaAsE4nwcCNu43Cf+kssx8BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/476] leds: trigger: panic: Dont register panic notifier if creating the trigger failed
Date: Wed, 21 Feb 2024 14:04:51 +0100
Message-ID: <20240221130016.754910487@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



