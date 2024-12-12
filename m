Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1636E216E28;
	Thu, 12 Dec 2024 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016070; cv=none; b=WshGJk4/w9M+Fdd64/9Oqq5T1N7xrpILOUVr6RkBt922OyGSzAwYwDFgi+y3N6DFzjMiLw/yM0RIBffOPCdO0VLE75xrDBpzuHy1UAehdu80ZuXcltwopvMv6R5s99ne42sglAqADiF+W943YB1BwSMjzdSDlWmyZR7u+sMO2ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016070; c=relaxed/simple;
	bh=3tpX/S8Rmx/omHwlXFMvrTikkkLzYAD1QGz3WPOwRKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9e082aMSLXGVRFCUOD3ImjStoLzX/mgKYZkeQsULThRolM/KUAFi3pZZEbIu02ojzO4oAg9gedG+5dNkywLAfpmUIishYPZN1lfE/7IZ9xL42zuskWagLCKhmgymzW4lcryalL98IpK5iKzDQNWtrVbH53jrmKMFYE2peiQsTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2LIIXhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2LIIXhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BE0C4CED0;
	Thu, 12 Dec 2024 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016070;
	bh=3tpX/S8Rmx/omHwlXFMvrTikkkLzYAD1QGz3WPOwRKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2LIIXhsH5ziAbn9KNQjc34+iRJwHxeyRgJPXKuFooyk7WJnuKRSjUj94mL9JIlnK
	 vlQ3KtrXR7XODojtYaofE+wrbVK2vBV0lGgnwhoVLJQbgzdbww3iZ8/4lrVjCAE1cK
	 EA4TAAcdakVeQtP4XlNujT+C8U9oxUXw7wP7gM3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael <auslands-kv@gmx.de>,
	Kenny Levinsen <kl@kl.wtf>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 122/466] HID: i2c-hid: Revert to using power commands to wake on resume
Date: Thu, 12 Dec 2024 15:54:51 +0100
Message-ID: <20241212144311.627952570@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenny Levinsen <kl@kl.wtf>

commit 34851431ceca1bf457d85895bd38a4e7967e2055 upstream.

commit 7d6f065de37c ("HID: i2c-hid: Use address probe to wake on resume")
replaced the retry of power commands with the dummy read "bus probe" we
use on boot which accounts for a necessary delay before retry.

This made at least one Weida device (2575:0910 in an ASUS Vivobook S14)
very unhappy, as the bus probe despite being successful somehow lead to
the following power command failing so hard that the device never lets
go of the bus. This means that even retries of the power command would
fail on a timeout as the bus remains busy.

Remove the bus probe on resume and instead reintroduce retry of the
power command for wake-up purposes while respecting the newly
established wake-up retry timings.

Fixes: 7d6f065de37c ("HID: i2c-hid: Use address probe to wake on resume")
Cc: stable@vger.kernel.org
Reported-by: Michael <auslands-kv@gmx.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219440
Link: https://lore.kernel.org/r/d5acb485-7377-4139-826d-4df04d21b5ed@leemhuis.info/
Signed-off-by: Kenny Levinsen <kl@kl.wtf>
Link: https://patch.msgid.link/20241119235615.23902-1-kl@kl.wtf
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 43664a24176f..4e87380d3edd 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -414,7 +414,19 @@ static int i2c_hid_set_power(struct i2c_hid *ihid, int power_state)
 
 	i2c_hid_dbg(ihid, "%s\n", __func__);
 
+	/*
+	 * Some STM-based devices need 400µs after a rising clock edge to wake
+	 * from deep sleep, in which case the first request will fail due to
+	 * the address not being acknowledged. Try after a short sleep to see
+	 * if the device came alive on the bus. Certain Weida Tech devices also
+	 * need this.
+	 */
 	ret = i2c_hid_set_power_command(ihid, power_state);
+	if (ret && power_state == I2C_HID_PWR_ON) {
+		usleep_range(400, 500);
+		ret = i2c_hid_set_power_command(ihid, I2C_HID_PWR_ON);
+	}
+
 	if (ret)
 		dev_err(&ihid->client->dev,
 			"failed to change power setting.\n");
@@ -976,14 +988,6 @@ static int i2c_hid_core_resume(struct i2c_hid *ihid)
 
 	enable_irq(client->irq);
 
-	/* Make sure the device is awake on the bus */
-	ret = i2c_hid_probe_address(ihid);
-	if (ret < 0) {
-		dev_err(&client->dev, "nothing at address after resume: %d\n",
-			ret);
-		return -ENXIO;
-	}
-
 	/* On Goodix 27c6:0d42 wait extra time before device wakeup.
 	 * It's not clear why but if we send wakeup too early, the device will
 	 * never trigger input interrupts.
-- 
2.47.1



