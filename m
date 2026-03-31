Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44808423A7C;
	Tue, 31 Mar 2026 16:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975948; cv=none; b=gEorX1tRSDP4ZfU3Wjwi/uosksp46cuXFBIlu5BrhiGshmx9Hagr9AH101nL7FglOKZJHtASyusLID1vs+PbNX8TPhpYg5G1EmTelohOdXBSqOu0/sNo/fAaXo/mhvMWTKWdJ3jwHJ/oyKvBsXF9jVOvkBkg3C6ietHhnOpJk54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975948; c=relaxed/simple;
	bh=az/tbwwybVECnE/sghykLnICiGoGfPtrsSkbz7HVHT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2up5VTxIUsfHPNUvxGtF9DhfDE3pEfw+e52V8MzOP6+JaveEtOBbx/ck5wsxSZ3gSKHuFkAf1XSb1b4eJnQD4aXwn02sUHS0rJ2jajiTZxOlRvzA48QGT43jzNcYAnNHQE8TWOI6w0obkWKVB3XVHJEUKkJ517w5zahp3h/D3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ip8Nrdl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ip8Nrdl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9FEC19423;
	Tue, 31 Mar 2026 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975948;
	bh=az/tbwwybVECnE/sghykLnICiGoGfPtrsSkbz7HVHT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ip8Nrdl8TrRyvZH3qZfV0KMjFyZ15eg0INvgl+KbOoCPR1Vue4FrStehSwUxe/htY
	 TBlhA12SYevoDfTHH3SppqsT+77IdG3LnyJVIZfHmp7qsASzJzuW1fhHHeyGnk4qb5
	 zcz2YwJIkGPwdbv4MvOuFzhmjXojH+djK0w5rZX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 149/244] hwmon: (pmbus/isl68137) Add mutex protection for AVS enable sysfs attributes
Date: Tue, 31 Mar 2026 18:21:39 +0200
Message-ID: <20260331161747.267289817@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit 3075a3951f7708da5a8ab47b0b7d068a32f69e58 upstream.

The custom avs0_enable and avs1_enable sysfs attributes access PMBus
registers through the exported API helpers (pmbus_read_byte_data,
pmbus_read_word_data, pmbus_write_word_data, pmbus_update_byte_data)
without holding the PMBus update_lock mutex. These exported helpers do
not acquire the mutex internally, unlike the core's internal callers
which hold the lock before invoking them.

The store callback is especially vulnerable: it performs a multi-step
read-modify-write sequence (read VOUT_COMMAND, write VOUT_COMMAND, then
update OPERATION) where concurrent access from another thread could
interleave and corrupt the register state.

Add pmbus_lock_interruptible()/pmbus_unlock() around both the show and
store callbacks to serialize PMBus register access with the rest of the
driver.

Fixes: 038a9c3d1e424 ("hwmon: (pmbus/isl68137) Add driver for Intersil ISL68137 PWM Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260319173055.125271-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/isl68137.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -78,7 +78,15 @@ static ssize_t isl68137_avs_enable_show_
 					     int page,
 					     char *buf)
 {
-	int val = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
+	int val;
+
+	val = pmbus_lock_interruptible(client);
+	if (val)
+		return val;
+
+	val = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
+
+	pmbus_unlock(client);
 
 	if (val < 0)
 		return val;
@@ -100,6 +108,10 @@ static ssize_t isl68137_avs_enable_store
 
 	op_val = result ? ISL68137_VOUT_AVS : 0;
 
+	rc = pmbus_lock_interruptible(client);
+	if (rc)
+		return rc;
+
 	/*
 	 * Writes to VOUT setpoint over AVSBus will persist after the VRM is
 	 * switched to PMBus control. Switching back to AVSBus control
@@ -111,17 +123,20 @@ static ssize_t isl68137_avs_enable_store
 		rc = pmbus_read_word_data(client, page, 0xff,
 					  PMBUS_VOUT_COMMAND);
 		if (rc < 0)
-			return rc;
+			goto unlock;
 
 		rc = pmbus_write_word_data(client, page, PMBUS_VOUT_COMMAND,
 					   rc);
 		if (rc < 0)
-			return rc;
+			goto unlock;
 	}
 
 	rc = pmbus_update_byte_data(client, page, PMBUS_OPERATION,
 				    ISL68137_VOUT_AVS, op_val);
 
+unlock:
+	pmbus_unlock(client);
+
 	return (rc < 0) ? rc : count;
 }
 


