Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B1E2236EB;
	Tue, 30 Sep 2025 15:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245153; cv=none; b=uGH6UleFa/yj3jfzNlD+yv+IodRZfBGdvUeIHb23s6++8ebdOzOR/IlrtnVVYAhx/50fyBTzZvkj0zZzFnT8+vQDtOQZ5M9+MUDvETSUTC91aWp3vkhQMPBtH0hYf73cC5wnHWT/2B1MgbNT4KOcrR/nDg9BWg5p6hGdNMw1avY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245153; c=relaxed/simple;
	bh=LqnVtTHgtUUIKrmD9VwppnMi1s9pw1ygLUcxyewC4TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjCxZKUYnz5KJrKyetbLP7g/oJDPQUvZ+Zy6ZhQvTKWcLy0Z/v/rtActT6mxcU8CJYZUlztdKEG3khTsP7EDLeRHCrgmrdkR9Yid0BnIVmBqJVYqgzv56ngh3V5QyYYfQQ0Y9bD7zaAtAGLnsxhCH+L9UvkBZ6vx3pcXeyIR/1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuaYRKAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuaYRKAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BE2C4CEF0;
	Tue, 30 Sep 2025 15:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245152;
	bh=LqnVtTHgtUUIKrmD9VwppnMi1s9pw1ygLUcxyewC4TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuaYRKAD0ZkVd0jrGGw5mJ22o71UxzhXBDPQLJcYbJ4HDOH4mNLrQRKEkeLXHiLee
	 OYcYU9vW0zZPZBJbr3T4wiSSYwk6h4x2jQYooASAw90LytPZ4Ln6KuwF9g5s4i71Y6
	 H7vjLPGkjzHmCuT6sxxMCKpXofEcmxE0ALL+zi6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Lv <Jerry.Lv@axis.com>,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 080/151] power: supply: bq27xxx: restrict no-battery detection to bq27000
Date: Tue, 30 Sep 2025 16:46:50 +0200
Message-ID: <20250930143830.777540842@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 1e451977e1703b6db072719b37cd1b8e250b9cc9 upstream.

There are fuel gauges in the bq27xxx series (e.g. bq27z561) which may in some
cases report 0xff as the value of BQ27XXX_REG_FLAGS that should not be
interpreted as "no battery" like for a disconnected battery with some built
in bq27000 chip.

So restrict the no-battery detection originally introduced by

    commit 3dd843e1c26a ("bq27000: report missing device better.")

to the bq27000.

There is no need to backport further because this was hidden before

	commit f16d9fb6cf03 ("power: supply: bq27xxx: Retrieve again when busy")

Fixes: f16d9fb6cf03 ("power: supply: bq27xxx: Retrieve again when busy")
Suggested-by: Jerry Lv <Jerry.Lv@axis.com>
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/dd979fa6855fd051ee5117016c58daaa05966e24.1755945297.git.hns@goldelico.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1872,8 +1872,8 @@ static void bq27xxx_battery_update_unloc
 	bool has_singe_flag = di->opts & BQ27XXX_O_ZERO;
 
 	cache.flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, has_singe_flag);
-	if ((cache.flags & 0xff) == 0xff)
-		cache.flags = -ENODEV; /* read error */
+	if (di->chip == BQ27000 && (cache.flags & 0xff) == 0xff)
+		cache.flags = -ENODEV; /* bq27000 hdq read error */
 	if (cache.flags >= 0) {
 		cache.temperature = bq27xxx_battery_read_temperature(di);
 		if (di->regs[BQ27XXX_REG_TTE] != INVALID_REG_ADDR)


