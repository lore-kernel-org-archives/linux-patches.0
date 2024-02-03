Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2031111CBE;
	Sat,  3 Feb 2024 04:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933428; cv=none; b=hFPGk7T7GGYc8zWZa+CI0Gd8fCeraJLjp7elVHHSXtl0y3J+C8YgqsQUZB3C3GDk9uCcKK0i8et+4sO1qIB+/st5Vy2BqZVa1CWfeEYk9GdEqdNitmGxi1aG4QL4LoMKfYE7icQc1XMo1AWzuSTQK8sDszaBJjn07rfsU8FqE4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933428; c=relaxed/simple;
	bh=dnlPbdbolLxdr5RfNICWLH6ktmk+w3Jouw4nTeZBIe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Deflqr+xqTdd9mD9WvXy2Z5J0Kc/Bm82hu4OgCc+AMt/0wbczPleqHH/UBQaxHm3frfqNjTnj7IGhnYSK0cPeKZAUUE9Z8l0F9qaDgy1skDQwprHPwh2zqWp2PKvPUYQPDWMoNvmfQpvItuETlwOWUMXhDbhPpgdgJ0Yd5kHnCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhIEGgYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhIEGgYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF391C433F1;
	Sat,  3 Feb 2024 04:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933428;
	bh=dnlPbdbolLxdr5RfNICWLH6ktmk+w3Jouw4nTeZBIe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhIEGgYWTRfKW2IXoNVkITkiADGqBqAJPZyb9lHzuKINIXRVYmJm1XrDbi9EmxhWn
	 5/dBHmXyI5lWKridmOuACWbJqrXYXnDFfjfEtDpKrdCP+tTBVcAyswuXPuekt0++TS
	 hjG5c3AXT7zyOxMlxvlaZbBsEYx+1k+Wp8qcnW8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/219] leds: trigger: panic: Dont register panic notifier if creating the trigger failed
Date: Fri,  2 Feb 2024 20:05:20 -0800
Message-ID: <20240203035337.842388098@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



